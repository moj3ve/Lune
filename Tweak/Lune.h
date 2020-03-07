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
BOOL colorTimeSwitch = NO;
BOOL colorMoonSwitch = NO;
BOOL glowSwitch = NO;
BOOL hideDNDBannerSwitch = NO;

// Coordinate Sliders, Size Slider And Moon Icon
NSString* xCordinate = @"150";
NSString* yCordinate = @"215";
NSString* moonSize = @"15";
NSString* moonIconList = @"0";

// Custom Glow Options
BOOL customGlowSwitch = NO;
BOOL purpleGlowIfPurpleMoonSwitch = NO;
BOOL customShadowRadiusSwitch = NO;
BOOL customShadowOpacitySwitch = NO;
NSString* radiusValue = @"0";
NSString* opacityValue = @"0";

// Ringer Options
BOOL ringerIconSwitch = NO;
BOOL preferRingerIconSwitch = NO;
NSString* moonIconRingerList = @"6";

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

@interface SBIconController : UIViewController
- (void)viewDidAppear:(BOOL)animated;
@end