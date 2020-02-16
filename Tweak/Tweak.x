#import "Lune.h"

%group Lune

%hook SBFLockScreenDateView
// Using The layoutSubviews Because They're Being Called More Often Than didMoveToWindow
- (void)layoutSubviews {

	%orig;
    // Removing The Moon Before Showing, Workaround To Fix The Moon Not Hiding When DND Mode Is Disabled
    [dndImageView removeFromSuperview];
    // Show The Moon If DND Is Active
    [self setMoon];

}

%new
- (void)setMoon {

    if (enabled && (isDNDActive || (isRingerSilent && ringerIconSwitch))) {
        // Get The Values From The Sliders
        double xCordinateValue = [xCordinate doubleValue];
        double yCordinateValue = [yCordinate doubleValue];
        double moonSizeValue = [moonSize doubleValue];
        int moonIconValue = [moonIconList intValue];
        int moonIconRingerValue = [moonIconRingerList intValue];
        NSString* moonIconPath = [NSString stringWithFormat: @"/Library/Lune/moonIcon%d.png", moonIconValue]; // Setting The Paths Of The Images
        NSString* moonIconRingerPath = [NSString stringWithFormat: @"/Library/Lune/moonIcon%d.png", moonIconRingerValue];
        // Set The Image, Mode And Postition
        dndImageView = [[UIImageView alloc] init];
        if (!colorMoonSwitch) { // If The Moon Should Not Be Colored We Go Straight To The Image Initialisation
            if (ringerIconSwitch) {
                if (isRingerSilent && preferRingerIconSwitch) {
                    dndImageView.image = [UIImage imageWithContentsOfFile: moonIconRingerPath]; 

                } else if (isRingerSilent && !isDNDActive) {
                    dndImageView.image = [UIImage imageWithContentsOfFile: moonIconRingerPath]; 

                } else {
                    dndImageView.image = [UIImage imageWithContentsOfFile: moonIconPath]; 

                }

            } else if (enabled && !ringerIconSwitch) {
                dndImageView.image = [UIImage imageWithContentsOfFile: moonIconPath]; 

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
            dndImageView.tintColor = [UIColor colorWithRed:0.40 green:0.38 blue:0.83 alpha:1.0]; // Setting The Color
            dndImageView.image = moonImage; // And Setting The Image From The UIImageView

        }

        dndImageView.contentMode = UIViewContentModeScaleAspectFit; // Display Mode Of The UIImageView
        dndImageView.frame = CGRectMake(xCordinateValue, yCordinateValue, moonSizeValue, moonSizeValue); // Postition And Size
        // Add It To The View
        [self addSubview: dndImageView];

    } else {
        [dndImageView removeFromSuperview]; // If DND Is Disabled Remove The Moon From The View

    }

}

%end

%hook _UIStatusBarStringView

- (void)setTextColor:(id)arg1 {

    if (colorTimeSwitch && isDNDActive) {
        %orig([UIColor colorWithRed:0.40 green:0.38 blue:0.83 alpha:1.0]);

    } else if (!colorTimeSwitch || !isDNDActive) {
        %orig;

    }

}

%end

%hook DNDNotificationsService
// Hide The DND Banner If The Switch Is Toggled
- (void)_queue_postOrRemoveNotificationWithUpdatedBehavior:(BOOL)arg1 significantTimeChange:(BOOL)arg2 {

    if (enabled && hideDNDBannerSwitch) {
        return;

    } else {
        %orig;

    }

}

%end
// Check If DND Is Enabled Or Disabled
%hook DNDState

- (BOOL)isActive {

    isDNDActive = %orig;

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
    // Enabled and Reminder Options
    [pfs registerBool:&enabled default:YES forKey:@"Enabled"];
    [pfs registerBool:&hideDNDBannerSwitch default:YES forKey:@"hideDNDBanner"];
    [pfs registerBool:&colorTimeSwitch default:NO forKey:@"colorTime"];
    [pfs registerBool:&colorMoonSwitch default:NO forKey:@"colorMoon"];
    // Custom Options
    [pfs registerObject:&xCordinate default:@"150" forKey:@"xcordinates"];
    [pfs registerObject:&yCordinate default:@"215" forKey:@"ycordinates"];
    [pfs registerObject:&moonSize default:@"15" forKey:@"size"];
    [pfs registerObject:&moonIconList default:@"0" forKey:@"moonIcon"];
    [pfs registerBool:&ringerIconSwitch default:NO forKey:@"ringerIcon"];
    [pfs registerBool:&preferRingerIconSwitch default:NO forKey:@"preferRingerIcon"];
    [pfs registerObject:&moonIconRingerList default:@"6" forKey:@"moonIconRinger"];

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