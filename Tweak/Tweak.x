#import "Lune.h"

BOOL enabled = NO;

%group Lune

%hook SBFLockScreenDateView

%property(nonatomic, strong)UIImageView* dndImageView;

// Using The layoutSubviews Because They're Being Called More Often Than didMoveToWindow
- (void)layoutSubviews {

	%orig;
    // Removing The Moon Before Showing, Workaround To Fix The Moon Not Hiding When DND Mode Is Disabled
    self.dndImageView.hidden = YES;
    // Show The Moon If DND Is Active
    [self setMoon];

}

%new
- (void)setMoon {

    if (enabled && (isDNDActive || (isRingerSilent && ringerIconSwitch))) {
        // Get The Values From The Sliders
        self.dndImageView.hidden = NO;
        double xCordinateValue = [xCordinate doubleValue];
        double yCordinateValue = [yCordinate doubleValue];
        double moonSizeValue = [moonSize doubleValue];
        int moonIconValue = [moonIconList intValue];
        int moonIconRingerValue = [moonIconRingerList intValue];
        NSString* moonIconPath = [NSString stringWithFormat: @"/Library/Lune/moonIcon%d.png", moonIconValue]; // Setting The Paths Of The Images
        NSString* moonIconRingerPath = [NSString stringWithFormat: @"/Library/Lune/moonIcon%d.png", moonIconRingerValue];
        // Set The Image, Mode And Postition
        if (!self.dndImageView) self.dndImageView = [[UIImageView alloc] init];
        if (!colorMoonSwitch) { // If The Moon Should Not Be Colored We Go Straight To The Image Initialisation
            if (ringerIconSwitch) {
                if (isRingerSilent && preferRingerIconSwitch) {
                    self.dndImageView.image = [UIImage imageWithContentsOfFile: moonIconRingerPath]; 

                } else if (isRingerSilent && !isDNDActive) {
                    self.dndImageView.image = [UIImage imageWithContentsOfFile: moonIconRingerPath]; 

                } else {
                    self.dndImageView.image = [UIImage imageWithContentsOfFile: moonIconPath]; 

                }

            } else if (enabled && !ringerIconSwitch) {
                self.dndImageView.image = [UIImage imageWithContentsOfFile: moonIconPath]; 

            }

        } else if (colorMoonSwitch) { // Else If The Moon Should Be Colored We Have To Create An UIImage first, Setting The Image, Mode And Color
            UIImage* moonImage;
            if (ringerIconSwitch) {
                if (isRingerSilent && preferRingerIconSwitch) {
                    moonImage = [UIImage imageWithContentsOfFile: moonIconRingerPath];  // Allocation Of The Image From The Path

                } else if (isRingerSilent && !isDNDActive) {
                    moonImage = [UIImage imageWithContentsOfFile: moonIconRingerPath];

                } else {
                    moonImage = [UIImage imageWithContentsOfFile: moonIconPath];

                }

            } else if (enabled && !ringerIconSwitch) {
                moonImage = [UIImage imageWithContentsOfFile: moonIconPath];

            }

            moonImage = [moonImage imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate]; // Setting The Mode So It Can Be Colored
            self.dndImageView.tintColor = [UIColor colorWithRed:0.40 green:0.38 blue:0.83 alpha:1.0]; // Setting The Color
            self.dndImageView.image = moonImage; // And Setting The Image From The UIImageView

        }

        self.dndImageView.contentMode = UIViewContentModeScaleAspectFit; // Display Mode Of The UIImageView
        self.dndImageView.frame = CGRectMake(xCordinateValue, yCordinateValue, moonSizeValue, moonSizeValue); // Postition And Size
    // Add A Glow To The Moon
    if (glowSwitch) {
        double radius = [radiusValue doubleValue];
        double opacity = [opacityValue doubleValue];

        self.dndImageView.layer.shadowOffset = CGSizeZero;

        if (!colorMoonSwitch)
            self.dndImageView.layer.shadowColor = [[UIColor whiteColor] CGColor];
        else if (colorMoonSwitch && purpleGlowIfPurpleMoonSwitch)
            self.dndImageView.layer.shadowColor = [[UIColor colorWithRed:0.40 green:0.38 blue:0.83 alpha:1.0] CGColor];
        else
            self.dndImageView.layer.shadowColor = [[UIColor whiteColor] CGColor];

        if (!customGlowSwitch || !customShadowRadiusSwitch)
            self.dndImageView.layer.shadowRadius = 5;
        else if (customGlowSwitch && customShadowRadiusSwitch)
            self.dndImageView.layer.shadowRadius = radius;

        if (!customGlowSwitch || !customShadowOpacitySwitch)
            self.dndImageView.layer.shadowOpacity = 1;
        else if (customGlowSwitch && customShadowOpacitySwitch)
            self.dndImageView.layer.shadowOpacity = opacity;

    }
        // Add It To The View
        [self addSubview: self.dndImageView];

    } else if (enabled && (!isDNDActive && sunIconSwitch)) {
        // Get The Values From The Sliders
        self.dndImageView.hidden = NO;
        double sunXCordinateValue = [sunXCordinate doubleValue];
        double sunYCordinateValue = [sunYCordinate doubleValue];
        double sunSizeValue = [sunSize doubleValue];
        int sunIconValue = [sunIconList intValue];
        int moonIconRingerValue = [moonIconRingerList intValue];
        NSString* sunIconPath = [NSString stringWithFormat: @"/Library/Lune/moonIcon%d.png", sunIconValue]; // Setting The Paths Of The Images
        NSString* moonIconRingerPath = [NSString stringWithFormat: @"/Library/Lune/moonIcon%d.png", moonIconRingerValue];
        // Set The Image, Mode And Postition
        if (!self.dndImageView) self.dndImageView = [[UIImageView alloc] init];
        if (!colorSunSwitch) { // If The Moon Should Not Be Colored We Go Straight To The Image Initialisation
            if (ringerIconSwitch) {
                if (isRingerSilent && preferRingerIconSwitch) {
                    self.dndImageView.image = [UIImage imageWithContentsOfFile: moonIconRingerPath]; 

                } else if (isRingerSilent && !isDNDActive) {
                    self.dndImageView.image = [UIImage imageWithContentsOfFile: moonIconRingerPath]; 

                } else {
                    self.dndImageView.image = [UIImage imageWithContentsOfFile: sunIconPath]; 

                }

            } else if (enabled && !ringerIconSwitch) {
                self.dndImageView.image = [UIImage imageWithContentsOfFile: sunIconPath]; 

            }

        } else if (colorSunSwitch) { // Else If The Moon Should Be Colored We Have To Create An UIImage first, Setting The Image, Mode And Color
            UIImage* sunImage;
            if (ringerIconSwitch) {
                if (isRingerSilent && preferRingerIconSwitch) {
                    sunImage = [UIImage imageWithContentsOfFile: moonIconRingerPath];  // Allocation Of The Image From The Path

                } else if (isRingerSilent && !isDNDActive) {
                    sunImage = [UIImage imageWithContentsOfFile: moonIconRingerPath];

                } else {
                    sunImage = [UIImage imageWithContentsOfFile: sunIconPath];

                }

            } else if (enabled && !ringerIconSwitch) {
                sunImage = [UIImage imageWithContentsOfFile: sunIconPath];

            }

            sunImage = [sunImage imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate]; // Setting The Mode So It Can Be Colored
            self.dndImageView.tintColor = [UIColor colorWithRed:1.00 green:0.93 blue:0.00 alpha:1.00]; // Setting The Color
            self.dndImageView.image = sunImage; // And Setting The Image From The UIImageView

        }

        self.dndImageView.contentMode = UIViewContentModeScaleAspectFit; // Display Mode Of The UIImageView
        self.dndImageView.frame = CGRectMake(sunXCordinateValue, sunYCordinateValue, sunSizeValue, sunSizeValue); // Postition And Size
    // Add A Glow To The Moon
    if (sunGlowSwitch) {
        double radius = [sunRadiusValue doubleValue];
        double opacity = [sunOpacityValue doubleValue];

        self.dndImageView.layer.shadowOffset = CGSizeZero;

        if (!colorSunSwitch)
            self.dndImageView.layer.shadowColor = [[UIColor whiteColor] CGColor];
        else if (colorSunSwitch && yellowGlowIfYellowSunSwitch)
            self.dndImageView.layer.shadowColor = [[UIColor colorWithRed:1.00 green:0.93 blue:0.00 alpha:1.00] CGColor];
        else
            self.dndImageView.layer.shadowColor = [[UIColor whiteColor] CGColor];

        if (!customSunGlowSwitch || !customSunShadowRadiusSwitch)
            self.dndImageView.layer.shadowRadius = 5;
        else if (customSunGlowSwitch && customSunShadowRadiusSwitch)
            self.dndImageView.layer.shadowRadius = radius;

        if (!customSunGlowSwitch || !customSunShadowOpacitySwitch)
            self.dndImageView.layer.shadowOpacity = 1;
        else if (customSunGlowSwitch && customSunShadowOpacitySwitch)
            self.dndImageView.layer.shadowOpacity = opacity;

    }
        // Add It To The View
        [self addSubview: self.dndImageView];

    } else {
        [self.dndImageView removeFromSuperview]; // If DND Is Disabled Remove The Moon From The View

    }

}

%end
// Text On The Status Bar
%hook _UIStatusBarStringView

- (void)setTextColor:(id)arg1 {

    if (purpleItemsSwitch && isDNDActive) {
        %orig([UIColor colorWithRed:0.40 green:0.38 blue:0.83 alpha:1.0]);

    } else if (!purpleItemsSwitch || !isDNDActive) {
        %orig;

    }

}

%end
// Status Bar Wifi Icon
%hook _UIStatusBarWifiSignalView

- (id)activeColor {

    if (purpleItemsSwitch && isDNDActive)
        return [UIColor colorWithRed:0.40 green:0.38 blue:0.83 alpha:1.0];
    else
        return %orig;

}

- (id)inactiveColor {

    if (purpleItemsSwitch && isDNDActive)
        return [UIColor colorWithRed:0.40 green:0.38 blue:0.83 alpha:1.0];
    else
        return %orig;

}

%end
// Status Bar Cellular Icon
%hook _UIStatusBarCellularSignalView

- (id)activeColor {

    if (purpleItemsSwitch && isDNDActive)
        return [UIColor colorWithRed:0.40 green:0.38 blue:0.83 alpha:1.0];
    else
        return %orig;

}

- (id)inactiveColor {

    if (purpleItemsSwitch && isDNDActive)
        return [UIColor colorWithRed:0.40 green:0.38 blue:0.83 alpha:1.0];
    else
        return %orig;

}

%end

// Status Bar Images Like DND
%hook _UIStatusBarImageView

- (void)setTintColor:(UIColor *)arg1 {

    if (purpleItemsSwitch && isDNDActive)
        %orig([UIColor colorWithRed:0.40 green:0.38 blue:0.83 alpha:1.0]);
    else
        %orig;

}

%end

// Juice Battery
%hook JCEBatteryView

- (id)statusBarFillColour {

    if (purpleItemsSwitch && isDNDActive)
        return [UIColor colorWithRed:0.40 green:0.38 blue:0.83 alpha:1.0];
    else
        return %orig;

}

- (void)setStatusBarFillColour:(id)arg1 {

    if (purpleItemsSwitch && isDNDActive)
        %orig([UIColor colorWithRed:0.40 green:0.38 blue:0.83 alpha:1.0]);
    else
        %orig;

}

%end

%hook DNDNotificationsService
// Hide The DND Banner If The Switch Is Toggled
- (void)_queue_postOrRemoveNotificationWithUpdatedBehavior:(BOOL)arg1 significantTimeChange:(BOOL)arg2 {

    if (enabled && hideDNDBannerSwitch)
        return;
    else
        %orig;

}

%end
// Check If DND Is Enabled Or Disabled
%hook DNDState

- (BOOL)isActive {

    isDNDActive = %orig;

    [pfs setBool: isDNDActive forKey: @"isDNDActiveBool"];

    return %orig;

}

%end
// Check Of The Ringer Is Muted (iOS 13 Only)
%hook SBRingerControl

- (BOOL)isRingerMuted {

    isRingerSilent = %orig;

    return %orig;

}

%end

%end

    // This is an Alert if the Tweak is pirated (DRM)
%group LuneIntegrityFail

%hook SBIconController

- (void)viewDidAppear:(BOOL)animated {

    %orig; //  Thanks to Nepeta for the DRM
    if (!dpkgInvalid) return;
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Lune"
		message:@"Seriously? Pirating a free Tweak is awful!\nPiracy repo's Tweaks could contain Malware if you didn't know that, so go ahead and get Lune from the official Source https://repo.litten.sh/.\nIf you're seeing this but you got it from the official source then make sure to add https://repo.litten.sh to Cydia or Sileo."
		preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Aww man" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {

			UIApplication *application = [UIApplication sharedApplication];
			[application openURL:[NSURL URLWithString:@"https://repo.litten.sh/"] options:@{} completionHandler:nil];

	}];

		[alertController addAction:cancelAction];

		[self presentViewController:alertController animated:YES completion:nil];

}

%end

%end

%ctor {

    if (![NSProcessInfo processInfo]) return;
    NSString *processName = [NSProcessInfo processInfo].processName;
    bool isSpringboard = [@"SpringBoard" isEqualToString:processName];

    // Someone smarter than Nepeta invented this.
    // https://www.reddit.com/r/jailbreak/comments/4yz5v5/questionremote_messages_not_enabling/d6rlh88/
    bool shouldLoad = NO;
    NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
    NSUInteger count = args.count;
    if (count != 0) {
        NSString *executablePath = args[0];
        if (executablePath) {
            NSString *processName = [executablePath lastPathComponent];
            BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;
            BOOL isFileProvider = [[processName lowercaseString] rangeOfString:@"fileprovider"].location != NSNotFound;
            BOOL skip = [processName isEqualToString:@"AdSheet"]
                        || [processName isEqualToString:@"CoreAuthUI"]
                        || [processName isEqualToString:@"InCallService"]
                        || [processName isEqualToString:@"MessagesNotificationViewService"]
                        || [executablePath rangeOfString:@".appex/"].location != NSNotFound;
            if ((!isFileProvider && isApplication && !skip) || isSpringboard) {
                shouldLoad = YES;
            }
        }
    }

    if (!shouldLoad) return;
  
    // Thanks To Nepeta For The DRM
    dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/sh.litten.lune.list"];

    if (!dpkgInvalid) dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/sh.litten.lune.md5sums"];

    if (dpkgInvalid) {
        %init(LuneIntegrityFail);
        return;
    }

    pfs = [[HBPreferences alloc] initWithIdentifier:@"sh.litten.lunepreferences"];
    // Enabled Switch
    [pfs registerBool:&enabled default:nil forKey:@"Enabled"];
    // Moon Options
    [pfs registerBool:&colorMoonSwitch default:NO forKey:@"colorMoon"];
    [pfs registerBool:&glowSwitch default:NO forKey:@"glow"];
    [pfs registerObject:&xCordinate default:@"150" forKey:@"xcordinates"];
    [pfs registerObject:&yCordinate default:@"215" forKey:@"ycordinates"];
    [pfs registerObject:&moonSize default:@"15" forKey:@"size"];
    [pfs registerObject:&moonIconList default:@"0" forKey:@"moonIcon"];
    [pfs registerBool:&customGlowSwitch default:NO forKey:@"customGlow"];
    [pfs registerBool:&purpleGlowIfPurpleMoonSwitch default:NO forKey:@"purpleGlowIfPurpleMoon"];
    [pfs registerBool:&customShadowRadiusSwitch default:NO forKey:@"customShadowRadius"];
    [pfs registerBool:&customShadowOpacitySwitch default:NO forKey:@"customShadowOpacity"];
    [pfs registerObject:&radiusValue default:@"0" forKey:@"radiusValueSlider"];
    [pfs registerObject:&opacityValue default:@"0" forKey:@"opacityValueSlider"];
    // Sun Options
    [pfs registerBool:&sunIconSwitch default:NO forKey:@"sunIcon"];
    [pfs registerBool:&colorSunSwitch default:NO forKey:@"colorSun"];
    [pfs registerObject:&sunIconList default:@"0" forKey:@"sunIconIMG"];
    [pfs registerObject:&sunXCordinate default:@"150" forKey:@"sunXCordinates"];
    [pfs registerObject:&sunYCordinate default:@"215" forKey:@"sunYCordinates"];
    [pfs registerObject:&sunSize default:@"15" forKey:@"sunSize"];
    [pfs registerBool:&sunGlowSwitch default:NO forKey:@"sunGlow"];
    [pfs registerBool:&customSunGlowSwitch default:NO forKey:@"customSunGlow"];
    [pfs registerBool:&yellowGlowIfYellowSunSwitch default:NO forKey:@"yellowGlowIfYellowSun"];
    [pfs registerBool:&customSunShadowRadiusSwitch default:NO forKey:@"customSunShadowRadius"];
    [pfs registerBool:&customSunShadowOpacitySwitch default:NO forKey:@"customSunShadowOpacity"];
    [pfs registerObject:&sunRadiusValue default:@"0" forKey:@"sunRadiusValueSlider"];
    [pfs registerObject:&sunOpacityValue default:@"0" forKey:@"sunOpacityValueSlider"];
    // Ringer Options
    [pfs registerBool:&ringerIconSwitch default:NO forKey:@"ringerIcon"];
    [pfs registerBool:&preferRingerIconSwitch default:NO forKey:@"preferRingerIcon"];
    [pfs registerObject:&moonIconRingerList default:@"6" forKey:@"moonIconRinger"];
    // Miscellaneous
    [pfs registerBool:&purpleItemsSwitch default:NO forKey:@"purpleItems"];
    [pfs registerBool:&hideDNDBannerSwitch default:NO forKey:@"hideDNDBanner"];
    // DND State
    [pfs registerBool:&isDNDActive default:NO forKey:@"isDNDActiveBool"];

	if (!dpkgInvalid && enabled) {
        BOOL ok = false;
        
        ok = ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/lib/dpkg/info/%@%@%@%@%@%@%@%@%@.lune.md5sums", @"s", @"h", @".", @"l", @"i", @"t", @"t", @"e", @"n"]]
        );

        if (ok && [@"litten" isEqualToString:@"litten"]) {
            %init(Lune);
            return;
        } else {
            dpkgInvalid = YES;
        }
    }
}