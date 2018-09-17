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

%group iOS10
%hook SBDashBoardIdleTimerEventPublisher

- (BOOL)isEnabled {
    BOOL charging = [[%c(SBUIController) sharedInstance] isBatteryCharging];
    BOOL infite = ((chargeMode && charging && chargingDuration == 0) || (!chargeMode && duration == 0));
    return (enabled && infite) ? NO : %orig;
}

%end
%end

%group iOS11
%hook SBDashBoardIdleTimerProvider

- (BOOL)isIdleTimerEnabled {
    BOOL charging = [[%c(SBUIController) sharedInstance] isBatteryCharging];
    BOOL infite = ((chargeMode && charging && chargingDuration == 0) || (!chargeMode && duration == 0));
    return (enabled && infite) ? NO : %orig;    
}

%end
%end


%ctor {
    reloadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &updateSettings, CFSTR("se.nosskirneh.customlockscreenduration/preferencesChanged"), NULL, 0);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &updateSettings, CFSTR("se.nosskirneh.customlockscreenduration.FSchanged"), NULL, 0);

    %init;
    if (%c(SBDashBoardIdleTimerEventPublisher))
        %init(iOS10);
    else if (%c(SBDashBoardIdleTimerProvider))
        %init(iOS11)
}
