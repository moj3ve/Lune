#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

// Utils
HBPreferences *pfs;

// Thanks to Nepeta for the DRM
BOOL dpkgInvalid = NO;

// Moon ImageView
UIImageView* dndImageView;

// Option Switches
extern BOOL enabled;

// Coordinate Sliders, Size Slider And Moon Icon
BOOL colorMoonSwitch = NO;
BOOL glowSwitch = NO;
BOOL customGlowSwitch = NO;
BOOL purpleGlowIfPurpleMoonSwitch = NO;
BOOL customShadowRadiusSwitch = NO;
BOOL customShadowOpacitySwitch = NO;
NSString* xCordinate = @"150";
NSString* yCordinate = @"215";
NSString* moonSize = @"15";
NSString* moonIconList = @"0";
NSString* radiusValue = @"0";
NSString* opacityValue = @"0";

// Sun Options
BOOL sunIconSwitch = NO;
BOOL colorSunSwitch = NO;
BOOL sunGlowSwitch = NO;
BOOL customSunGlowSwitch = NO;
BOOL yellowGlowIfYellowSunSwitch = NO;
BOOL customSunShadowRadiusSwitch = NO;
BOOL customSunShadowOpacitySwitch = NO;
NSString* sunIconList = @"0";
NSString* sunXCordinate = @"150";
NSString* sunYCordinate = @"215";
NSString* sunSize = @"15";
NSString* sunRadiusValue = @"0";
NSString* sunOpacityValue = @"0";

// Ringer Options
BOOL ringerIconSwitch = NO;
BOOL preferRingerIconSwitch = NO;
NSString* moonIconRingerList = @"6";

// Status Bar Coloring
BOOL purpleItemsSwitch = NO;

// Miscellaneous
BOOL hideDNDBannerSwitch = NO;

// Detection Variables
BOOL isDNDActive;
BOOL isRingerSilent;

@interface SBFLockScreenDateView : UIView
- (void)layoutSubviews;
- (void)setMoon;
@end

@interface DNDState : NSObject
- (BOOL)isActive;
@end

@interface SBRingerControl : NSObject
- (BOOL)isRingerMuted;
@end

@interface _UIStatusBarStringView : UIView
- (void)setTextColor:(id)arg1;
@end

@interface _UIStatusBarWifiSignalView : UIView
-(void)_updateBars;
@end

@interface SBIconController : UIViewController
- (void)viewDidAppear:(BOOL)animated;
@end