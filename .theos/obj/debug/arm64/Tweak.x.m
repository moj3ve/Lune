#line 1 "Tweak.x"
#import "Lune.h"


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBIconController; @class SBFLockScreenDateView; @class DNDNotificationsService; @class DNDState; 


#line 3 "Tweak.x"
static void (*_logos_orig$Lune$SBFLockScreenDateView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL SBFLockScreenDateView* _LOGOS_SELF_CONST, SEL); static void _logos_method$Lune$SBFLockScreenDateView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBFLockScreenDateView* _LOGOS_SELF_CONST, SEL); static void _logos_method$Lune$SBFLockScreenDateView$setMoon(_LOGOS_SELF_TYPE_NORMAL SBFLockScreenDateView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Lune$DNDNotificationsService$_queue_postOrRemoveNotificationWithUpdatedBehavior$significantTimeChange$)(_LOGOS_SELF_TYPE_NORMAL DNDNotificationsService* _LOGOS_SELF_CONST, SEL, BOOL, BOOL); static void _logos_method$Lune$DNDNotificationsService$_queue_postOrRemoveNotificationWithUpdatedBehavior$significantTimeChange$(_LOGOS_SELF_TYPE_NORMAL DNDNotificationsService* _LOGOS_SELF_CONST, SEL, BOOL, BOOL); static BOOL (*_logos_orig$Lune$DNDState$isActive)(_LOGOS_SELF_TYPE_NORMAL DNDState* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$Lune$DNDState$isActive(_LOGOS_SELF_TYPE_NORMAL DNDState* _LOGOS_SELF_CONST, SEL); 



static void _logos_method$Lune$SBFLockScreenDateView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL SBFLockScreenDateView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	_logos_orig$Lune$SBFLockScreenDateView$layoutSubviews(self, _cmd);
    
    [dndImageView removeFromSuperview];
    
    [self setMoon];

}


static void _logos_method$Lune$SBFLockScreenDateView$setMoon(_LOGOS_SELF_TYPE_NORMAL SBFLockScreenDateView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

    if (isDNDActive) {
        
        double xCordinateValue = [xCordinate doubleValue];
        double yCordinateValue = [yCordinate doubleValue];
        double moonSizeValue = [moonSize doubleValue];
        int moonIconValue = [moonIconList intValue];
        
        dndImageView = [[UIImageView alloc] init];
        dndImageView.image = [UIImage imageWithContentsOfFile: [NSString stringWithFormat: @"/Library/Lune/moonIcon%d.png", moonIconValue]]; 
        dndImageView.contentMode = UIViewContentModeScaleAspectFit;
        dndImageView.frame = CGRectMake(xCordinateValue, yCordinateValue, moonSizeValue, moonSizeValue);
        
        [self addSubview: dndImageView];

    } else {
        [dndImageView removeFromSuperview]; 

    }

}





static void _logos_method$Lune$DNDNotificationsService$_queue_postOrRemoveNotificationWithUpdatedBehavior$significantTimeChange$(_LOGOS_SELF_TYPE_NORMAL DNDNotificationsService* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1, BOOL arg2) {

    if (enabled && hideDNDBannerSwitch) {
        return;

    } else {
        _logos_orig$Lune$DNDNotificationsService$_queue_postOrRemoveNotificationWithUpdatedBehavior$significantTimeChange$(self, _cmd, arg1, arg2);

    }

}





static BOOL _logos_method$Lune$DNDState$isActive(_LOGOS_SELF_TYPE_NORMAL DNDState* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

    isDNDActive = _logos_orig$Lune$DNDState$isActive(self, _cmd);

    return _logos_orig$Lune$DNDState$isActive(self, _cmd);

}





    
static void (*_logos_orig$LuneIntegrityFail$SBIconController$viewDidAppear$)(_LOGOS_SELF_TYPE_NORMAL SBIconController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$LuneIntegrityFail$SBIconController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL SBIconController* _LOGOS_SELF_CONST, SEL, BOOL); 



static void _logos_method$LuneIntegrityFail$SBIconController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL SBIconController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL animated) {

    _logos_orig$LuneIntegrityFail$SBIconController$viewDidAppear$(self, _cmd, animated); 
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





static __attribute__((constructor)) void _logosLocalCtor_d71d90a9(int __unused argc, char __unused **argv, char __unused **envp) {

    if (![NSProcessInfo processInfo]) return;
    NSString *processName = [NSProcessInfo processInfo].processName;
    bool isSpringboard = [@"SpringBoard" isEqualToString:processName];

    
    
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
  
    
    dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/sh.litten.lune.list"];

    if (!dpkgInvalid) dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/sh.litten.lune.md5sums"];

    if (dpkgInvalid) {
        {Class _logos_class$LuneIntegrityFail$SBIconController = objc_getClass("SBIconController"); MSHookMessageEx(_logos_class$LuneIntegrityFail$SBIconController, @selector(viewDidAppear:), (IMP)&_logos_method$LuneIntegrityFail$SBIconController$viewDidAppear$, (IMP*)&_logos_orig$LuneIntegrityFail$SBIconController$viewDidAppear$);}
        return;
    }

    pfs = [[HBPreferences alloc] initWithIdentifier:@"sh.litten.lunepreferences"];
    
    [pfs registerBool:&enabled default:YES forKey:@"Enabled"];
    [pfs registerBool:&hideDNDBannerSwitch default:YES forKey:@"hideDNDBanner"];
    
    [pfs registerObject:&xCordinate default:@"5" forKey:@"xcordinates"];
    [pfs registerObject:&yCordinate default:@"215" forKey:@"ycordinates"];
    [pfs registerObject:&moonSize default:@"20" forKey:@"size"];
    [pfs registerObject:&moonIconList default:@"0" forKey:@"moonIcon"];

	if (!dpkgInvalid && enabled) {
        BOOL ok = false;
        
        ok = ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/lib/dpkg/info/%@%@%@%@%@%@%@%@%@.lune.md5sums", @"s", @"h", @".", @"l", @"i", @"t", @"t", @"e", @"n"]]
        );

        if (ok && [@"litten" isEqualToString:@"litten"]) {
            {Class _logos_class$Lune$SBFLockScreenDateView = objc_getClass("SBFLockScreenDateView"); MSHookMessageEx(_logos_class$Lune$SBFLockScreenDateView, @selector(layoutSubviews), (IMP)&_logos_method$Lune$SBFLockScreenDateView$layoutSubviews, (IMP*)&_logos_orig$Lune$SBFLockScreenDateView$layoutSubviews);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$Lune$SBFLockScreenDateView, @selector(setMoon), (IMP)&_logos_method$Lune$SBFLockScreenDateView$setMoon, _typeEncoding); }Class _logos_class$Lune$DNDNotificationsService = objc_getClass("DNDNotificationsService"); MSHookMessageEx(_logos_class$Lune$DNDNotificationsService, @selector(_queue_postOrRemoveNotificationWithUpdatedBehavior:significantTimeChange:), (IMP)&_logos_method$Lune$DNDNotificationsService$_queue_postOrRemoveNotificationWithUpdatedBehavior$significantTimeChange$, (IMP*)&_logos_orig$Lune$DNDNotificationsService$_queue_postOrRemoveNotificationWithUpdatedBehavior$significantTimeChange$);Class _logos_class$Lune$DNDState = objc_getClass("DNDState"); MSHookMessageEx(_logos_class$Lune$DNDState, @selector(isActive), (IMP)&_logos_method$Lune$DNDState$isActive, (IMP*)&_logos_orig$Lune$DNDState$isActive);}
            return;
        } else {
            dpkgInvalid = YES;
        }
    }
}
