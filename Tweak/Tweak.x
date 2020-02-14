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

    if (isDNDActive) {
        // Get The Values From The Sliders
        double xCordinateValue = [xCordinate doubleValue];
        double yCordinateValue = [yCordinate doubleValue];
        double moonSizeValue = [moonSize doubleValue];
        // Set The Image, Mode And Postition
        dndImageView = [[UIImageView alloc] init];
        dndImageView.image = [UIImage imageWithContentsOfFile: @"Library/Lune/dnd.png"];
        dndImageView.contentMode = UIViewContentModeScaleAspectFit;
        dndImageView.frame = CGRectMake(xCordinateValue, yCordinateValue, moonSizeValue, moonSizeValue);
        // Add It To The View
        [self addSubview: dndImageView];

    } else {
        [dndImageView removeFromSuperview]; // If DND Is Disabled Remove The Moon From The View

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

-(BOOL)isActive {

    isDNDActive = %orig;

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
    // Custom Options
    [pfs registerObject:&xCordinate default:@"5" forKey:@"xcordinates"];
    [pfs registerObject:&yCordinate default:@"215" forKey:@"ycordinates"];
    [pfs registerObject:&moonSize default:@"20" forKey:@"size"];

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