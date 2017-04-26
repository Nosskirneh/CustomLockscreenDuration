#import <SpringBoard/SBUIController.h>

#define prefPath [NSString stringWithFormat:@"%@/Library/Preferences/%@", NSHomeDirectory(),@"se.nosskirneh.customlockduration.plist"]

BOOL enabled;
long long duration;
BOOL chargeMode;
long long chargingDuration;

static void reloadPrefs() {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:prefPath]];
    enabled = [[defaults objectForKey:@"enabled"] boolValue];
    duration = [[defaults objectForKey:@"duration"] integerValue];
    chargeMode = [[defaults objectForKey:@"chargeMode"] boolValue];
    chargingDuration = [[defaults objectForKey:@"chargingDuration"] integerValue];
}

void updateSettings(CFNotificationCenterRef center,
                    void *observer,
                    CFStringRef name,
                    const void *object,
                    CFDictionaryRef userInfo) {
    reloadPrefs();
}


%ctor {
    reloadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &updateSettings, CFStringRef(@"se.nosskirneh.customlockscreenduration/preferencesChanged"), NULL, 0);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) updateSettings, CFSTR("se.nosskirneh.customlockscreenduration.FSchanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    
}

%hook SBDashBoardBehavior

- (void)setIdleTimerDuration:(long long)arg {
    if (enabled) {
        BOOL charging = [[%c(SBUIController) sharedInstance] isBatteryCharging];
        %orig((chargeMode && charging) ? chargingDuration : duration);
        return;
    }
    
    %orig(arg);
}

%end

%hook SBDashBoardIdleTimerEventPublisher

- (BOOL)isEnabled {
    BOOL charging = [[%c(SBUIController) sharedInstance] isBatteryCharging];
    BOOL infite = ((chargeMode && charging && chargingDuration == 0) || (!chargeMode && duration == 0));
    return (enabled && infite) ? NO : %orig;
}

%end
