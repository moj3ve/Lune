#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <AudioToolbox/AudioServices.h>

// Utils
HBPreferences *pfs;

// Thanks to Nepeta for the DRM
BOOL dpkgInvalid = NO;

// Moon ImageView
UIImageView* dndImageView;

// Option Switches
BOOL enabled = YES;
BOOL hideDNDBannerSwitch = YES;
BOOL ringerIconSwitch = NO;
BOOL preferRingerIconSwitch = NO;

// Coordinate Sliders
NSString* xCordinate = @"5";
NSString* yCordinate = @"215";
NSString* moonSize = @"20";
NSString* moonIconList = @"0";
NSString* moonIconRingerList = @"6";

// Detection Variables
BOOL isDNDActive;
BOOL isRingerSilent;

@interface SBFLockScreenDateView : UIView
- (void)layoutSubviews;
- (void)setMoon;
@end

@interface SBIconController : UIViewController
- (void)viewDidAppear:(BOOL)animated;
@end