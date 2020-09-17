#include "IPlugExample.h"
#include "IPlug/IPlug_include_in_plug_src.h"

#include <math.h>
#include "WDL/denormal.h"

static const int kNumPresets = 16;

PlugExample::PlugExample(void* const instanceInfo)
: IPLUG_CTOR(kNumParams, kNumPresets, instanceInfo)
{
	// Define parameter ranges, display units, labels.
	IParam* const pParam = new IBoolParam("Bypass", false);
	pParam->SetGlobal(true);
	AddParam(kParamBypass, pParam);

	// (exp(curve*0.5) - 1) / (exp(curve) - 1) = (4 - 0.1) / (20 - 0.1)
	static const double curve = 2.8232243382083610;

	AddParam(kParamRate, new IDoubleExpParam(curve, "Rate", 4.0, 0.1, 20.0, 2, "Hz"));
	AddParam(kParamDepth, new IDoubleParam("Depth", 12.0, 0.0, 24.0, 1, "dB"));
	AddParam(kParamShape, new IBoolParam("Shape", false, "Sine", "Square"));

	// Make some presets.
	MakeDefaultPreset("Default");

	MakePreset("Slow Square", false, 1.0, 6.0, true);
	MakePreset("Subtle Sine", false, 3.0, 4.5, false);
	MakePreset("Pulsating Pulse", false, 6.0, 18.0, true);

	MakePresetFromNamedParams("Is It On?", 3, kParamRate, 0.2, kParamDepth, 1.0, kParamShape, false);
	MakePresetFromNamedParams("Too Much", 2, kParamRate, 20.0, kParamDepth, 24.0);

	RestorePreset(0);
	PopulateUninitializedPresets();

	// Instantiate GUI.
	IGraphics* const pGraphics = MakeGraphics(this, 1200, 600);

	pGraphics->HandleMouseWheel(IGraphics::kMouseWheelModKey);
	pGraphics->EnableTooltips(true);

	const IBitmap bg(BG_PNG_ID, pGraphics->Width(), pGraphics->Height());
	pGraphics->AttachBackground(new IBackgroundControl(this, &bg));

	// Attach controls to GUI. Controls are automatically linked to
	// parameter if you construct control with parameter index. All pixel
	// units are at full (@2x) size to accommodate HDPI.

	// Toggle switch linked to bypass parameter.
	const IBitmap bypass(BYPASS_PNG_ID, 46, 46, 2);
	IControl* pControl = new ISwitchControl(this, 66, 66, kParamBypass, &bypass);
	pControl->Reverse(true);
	pControl->SetTooltip("Bypass");
	pGraphics->AttachControl(pControl);

	// Multibitmap knob linked to rate parameter.
	const IBitmap knob(KNOB_PNG_ID, 202, 174, 33);
	IKnobMultiControl* const pRate = new IKnobMultiControl(this, 127, 212, kParamRate, &knob);
	pRate->GetTargetRECT()->B += 32;
	pRate->SetGearing(2.0);
	pRate->SetTooltip("Tremolo Rate");
	pGraphics->AttachControl(pRate);

	// Fader linked to depth parameter.
	const IBitmap handle(HANDLE_PNG_ID, 128, 44);
	pControl = new IFaderControl(this, 510, 156, 288, kParamDepth, &handle);
	pControl->SetTooltip("Tremolo Depth");
	pGraphics->AttachControl(pControl);

	// Toggle switch linked to shape parameter.
	const IBitmap shape(SHAPE_PNG_ID, 124, 108, 2);
	pControl = new ISwitchControl(this, 886, 246, kParamShape, &shape);
	pControl->SetTooltip("Modulation Shape");
	pGraphics->AttachControl(pControl);

	// Load custom font (not implemented in this example).
	// pGraphics->LoadFont(IPLUG_RESOURCE(FONT_TTF));

	// Attach GUI to plugin.
	AttachGraphics(pGraphics);
}

PlugExample::~PlugExample()
{
	// No cleanup necessary; plugin manages/cleans up parameters,
	// GUI manages/cleans up resources.
}

bool PlugExample::OnGUIRescale(const int wantScale)
{
	// Load image set depending on host GUI DPI.
	IGraphics* const pGraphics = GetGUI();
	pGraphics->Rescale(wantScale);

	typedef IGraphics::BitmapResource Resource;

	// Half scale image set.
	static const Resource half[] =
	{
		Resource(IPLUG_RESOURCE(BG_PNG)),
		Resource(IPLUG_RESOURCE(BYPASS_PNG)),
		Resource(IPLUG_RESOURCE(KNOB_PNG)),
		Resource(IPLUG_RESOURCE(HANDLE_PNG)),
		Resource(IPLUG_RESOURCE(SHAPE_PNG)),
		Resource()
	};

	// Full scale image set.
	static const Resource full[] =
	{
		Resource(IPLUG_RESOURCE(BG_2X_PNG)),
		Resource(IPLUG_RESOURCE(BYPASS_2X_PNG)),
		Resource(IPLUG_RESOURCE(KNOB_2X_PNG)),
		Resource(IPLUG_RESOURCE(HANDLE_2X_PNG)),
		Resource(IPLUG_RESOURCE(SHAPE_2X_PNG)),
		Resource()
	};

	const Resource* const pResources = wantScale == IGraphics::kScaleFull ? full : half;
	pGraphics->LoadBitmapResources(pResources);

	return true;
}

void PlugExample::OnParamChange(const int paramIdx)
{
	// Called when parameter is initialized, or when it changes, e.g.
	// because user clicks in GUI, parameter is automated, project is
	// loaded, etc.
	switch (paramIdx)
	{
		case kParamBypass:
		{
			mBypass = GetParam<IBoolParam>(kParamBypass)->Bool();
			break;
		}

		case kParamRate:
		{
			const double rate = GetParam<IDoubleExpParam>(kParamRate)->Value();
			mLfoPeriod = rate / GetSampleRate();
			break;
		}

		case kParamDepth:
		{
			mAmpDepth = GetParam<IDoubleParam>(kParamDepth)->DBToAmp();
			break;
		}

		case kParamShape:
		{
			mModShape = GetParam<IBoolParam>(kParamShape)->Bool();
			break;
		}

		default: break;
	}
}

void PlugExample::SetSampleRate(const double sampleRate)
{
	// Called when sample rate is initialized or changes.
	IPlug::SetSampleRate(sampleRate);

	// factor = -5/(16.5 / 1000) i.e. 16.5 ms.
	static const double factor = -303.03030303030303;

	OnParamChange(kParamRate);
	mSmoothCoeff = 1.0 - exp(factor / GetSampleRate());
}

void PlugExample::Reset()
{
	// Called when plugin is instantiated, sample rate or max block size
	// changes, audio processing stops/starts, etc.
	mSmoothState = mLfoPhase = 0.0;
}

void PlugExample::ProcessDoubleReplacing(const double* const* const inputs, double* const* const outputs, const int nFrames)
{
	// Called for each sample block. Beware that nFrames can be anything
	// from 0 up to and including GetSamplesBlock().

	// Make sure we have a valid sample rate and block size.
	if (!PlugInit())
	{
		// Default passthrough.
		IPlug::ProcessDoubleReplacing(inputs, outputs, nFrames);
		return;
	}

	// Flush denormals to zero.
	#ifdef WDL_DENORMAL_FTZMODE
	WDL_denormal_ftz_scope denormalFtz;
	#endif

	// Apply tremolo effect to sample block.
	ProcessTremolo(inputs, outputs, nFrames);
}

void PlugExample::ProcessTremolo(const double* const* const inputs, double* const* const outputs, const int nFrames)
{
	// https://youtu.be/ZPv1UV0rD8U
	static const double tau = 2.0 * M_PI;

	// threshold = 10^(-24 / 20) i.e. -24 dB.
	static const double threshold = 0.063095734448019325;

	// LFO
	double phase = mLfoPhase;
	const double period = mLfoPeriod;

	// Amplitude modulation depth.
	double amp = mAmpDepth;

	// Smoothing filter.
	double filter = mSmoothState;
	const double coeff = mSmoothCoeff;

	// Modulation shape.
	const bool shape = mModShape;
	if (shape && amp <= threshold) amp = 0.0;

	if (mBypass) amp = 1.0;

	// Sample loop.
	for (int i = 0; i < nFrames; ++i)
	{
		double mod;
		if (shape)
		{
			// Toggle square wave between 0.0dB and depth.
			mod = phase < 0.5 ? 1.0 : amp;
		}
		else
		{
			// Scale cosine to [depth, 0.0dB] range.
			mod = (cos(phase * tau) + 1.0) * 0.5;
			mod = (1.0 - mod) * amp + mod;
		}

		// Increment LFO phase.
		phase += period;
		phase -= (int)phase;

		// Apply smoothing filter to modulation signal.
		filter += (mod - filter) * coeff;
		denormal_fix_double(&filter);

		// Apply modulation to audio signal amplitude.
		for (int ch = 0; ch < 2; ++ch)
		{
			outputs[ch][i] = inputs[ch][i] * filter;
		}
	}

	// Save LFO phase and smoothing filter state.
	mLfoPhase = phase;
	mSmoothState = filter;
}
