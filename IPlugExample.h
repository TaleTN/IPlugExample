#pragma once

#include "IPlug/IPlug_include_in_plug_hdr.h"

enum EParams
{
	kParamBypass = 0,

	kParamRate,
	kParamDepth,
	kParamShape,

	kNumParams
};

class PlugExample: public IPlug
{
public:
	PlugExample(void* instanceInfo);
	~PlugExample();

	void OnParamChange(int paramIdx);
	void SetSampleRate(double sampleRate);

	void Reset();
	void ProcessDoubleReplacing(const double* const* inputs, double* const* outputs, int nFrames);

	bool OnGUIRescale(int wantScale);

private:
	void ProcessTremolo(const double* const* inputs, double* const* outputs, int nFrames);

	double WDL_FIXALIGN mLfoPhase, mLfoPeriod, mAmpDepth;
	double WDL_FIXALIGN mSmoothState, mSmoothCoeff;

	bool mModShape, mBypass;
}
WDL_FIXALIGN;
