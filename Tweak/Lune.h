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

// Cordinate Sliders
NSString* xCordinate = @"5";
NSString* yCordinate = @"215";
NSString* moonSize = @"20";
NSString* moonIconList = @"0";

BOOL isDNDActive;

@interface SBFLockScreenDateView : UIView
- (void)layoutSubviews;
- (void)setMoon;
@end

@interface SBIconController : UIViewController
- (void)viewDidAppear:(BOOL)animated;
@end