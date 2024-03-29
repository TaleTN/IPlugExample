// Double quotes, spaces OK.
#define PLUG_MFR  "Tale"
#define PLUG_NAME "IPlug Example"

// Double quotes, spaces OK, 16 chars max (optional).
// #define PLUG_SHORT_NAME PLUG_NAME

// No quotes or spaces.
#define PLUG_CLASS_NAME PlugExample

// To-do: Set AudioComponents description and name in AU-Info.plist to
// PLUG_NAME " AU" and PLUG_MFR ": " PLUG_NAME.

// Double quotes, no spaces. BUNDLE_DOMAIN must contain only alphanumeric
// (A-Z, a-z, 0-9), hyphen (-), and period (.) chars. BUNDLE_NAME must be
// less than 16 chars.
#define BUNDLE_DOMAIN "com.TaleTN"
#define BUNDLE_NAME   "IPlugExample"

#ifdef __APPLE__
	// To-do: Set Product Bundle Indentifier in Xcode project to
	// BUNDLE_DOMAIN.aax.BUNDLE_NAME (AAX target),
	// BUNDLE_DOMAIN.audiounit.BUNDLE_NAME (AU target),
	// BUNDLE_DOMAIN.clap.BUNDLE_NAME (CLAP target),
	// BUNDLE_DOMAIN.vst.BUNDLE_NAME (VST2 target), and
	// BUNDLE_DOMAIN.vst3.BUNDLE_NAME (VST3 target).

	// No spaces.
	#define PLUG_FACTORY    PlugExample_Factory
	#define PLUG_ENTRY      PlugExample_Entry
	#define PLUG_ENTRY_STR "PlugExample_Entry"
	#define VIEW_CLASS      PlugExample_View
	#define VIEW_CLASS_STR "PlugExample_View"

	// To-do: Create export file with two entries: PLUG_ENTRY and
	// PLUG_FACTORY, each with leading underscore (e.g. PlugExample.exp
	// with entries _PlugExample_Entry and _PlugExample_Factory).

	// To-do: Set NSPrincipalClass in AU-Info.plist to VIEW_CLASS.
#endif

// Interpreted as 0xMajrMnBg.
#define PLUG_VER  0x00000800 // 0.8.0
#define VERSIONINFO_VERSION     0,8,0,0
#define VERSIONINFO_STR        "0.8.0"

#define VERSIONINFO_PRERELEASE // Define if alpha, beta, or RC
#define VERSIONINFO_COPYRIGHT "2020-2023 Theo Niessink"

// Windows version info resource (optional).
#ifdef _WIN32
	#define VERSIONINFO_ORG_FILE "IPlugExample"

// Apple version info (non-optional).
#elif defined(__APPLE__)
	// To-do: Set INFOPLIST_KEY_NSHumanReadableCopyright and
	// MARKETING_VERSION in Xcode project to VERSIONINFO_COPYRIGHT and
	// VERSIONINFO_STR.

	// To-do: Set AudioComponents version in AU-Info.plist to PLUG_VER.
#endif

// 4 chars, single quotes.
#define PLUG_UNIQUE_ID 'Iplg'
#define PLUG_MFR_ID    'Tale'

// Note: VST2 IDs can no longer be registered, so choose wisely to avoid
// possible clashes with other VST2 plugins.

// To-do: Set CFBundleSignature in AAX/AU/VST2-Info.plist to PLUG_UNIQUE_ID.
// To-do: Register PLUG_MFR_ID with Avid.

// To-do: Set AudioComponents manufacturer and subtype in AU-Info.plist to
// PLUG_MFR_ID and PLUG_UNIQUE_ID.

// e1a04daa-24f8-481f-aac3-da0e978bd171 (source: https://guidgenerator.com/)
#define PLUG_UNIQUE_GUID 0xE1A04DAA, 0x24F8481F, 0xAAC3DA0E, 0x978BD171
// ab98e836-e9d2-4f8d-b55b-82dcafdf2907
#define VST3_COMPAT_GUID 0xAB98E836, 0xE9D24F8D, 0xB55B82DC, 0xAFDF2907

// Cubase VST2 -> VST3 compatibility (double quotes, no commas).
#define VST3_COMPAT_OLD_GUIDS \
	"56535449706C6769706C75676578616D" /* IPlugExample */

// Plugin I/O config.
#define PLUG_CHANNEL_IO "1-1 2-2"

// Latency in samples.
#define PLUG_LATENCY 0

// Plugin flags.
#define PLUG_IS_INST       0
#define PLUG_DOES_MIDI_IN  0
#define PLUG_DOES_MIDI_OUT 0

// To-do: Set AudioComponents type in AU-Info.plist to aufx (audio effect),
// aumu (instrument), or aumf (audio effect with MIDI input).

#define PLUG_MFR_URL   "https://www.taletn.com/"
#define PLUG_MFR_EMAIL "eggbaconspam@steinberg.de"

// Unique IDs for each image resource, bit 0 is scale (0 = full, 1 = half).

#define BG_2X_PNG_ID     100
#define BYPASS_2X_PNG_ID 110
#define KNOB_2X_PNG_ID   120
#define HANDLE_2X_PNG_ID 130
#define SHAPE_2X_PNG_ID  140

#define BG_PNG_ID        101
#define BYPASS_PNG_ID    111
#define KNOB_PNG_ID      121
#define HANDLE_PNG_ID    131
#define SHAPE_PNG_ID     141

// #define FONT_TTF_ID   150

// Image resource filenames (case-sensitive!).

#define BG_2X_PNG_FN     "img/bg@2x.png"
#define BYPASS_2X_PNG_FN "img/bypass@2x.png"
#define KNOB_2X_PNG_FN   "img/knob@2x.png"
#define HANDLE_2X_PNG_FN "img/handle@2x.png"
#define SHAPE_2X_PNG_FN  "img/shape@2x.png"

#define BG_PNG_FN        "img/bg.png"
#define BYPASS_PNG_FN    "img/bypass.png"
#define KNOB_PNG_FN      "img/knob.png"
#define HANDLE_PNG_FN    "img/handle.png"
#define SHAPE_PNG_FN     "img/shape.png"

// #define FONT_TTF_FN   "img/font.ttf"

// To-do: Add resources to RC script, Windows makefile, Visual Studio
// project, and/or Xcode project.
