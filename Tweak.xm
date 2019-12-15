#import <SpringBoard/SBUIController.h>
#import "Common.h"


static BOOL enabled;
static long long duration;
static BOOL chargeMode;
static long long chargingDuration;

static void reloadPrefs() {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:kPrefPath]];
    enabled = [defaults[@"enabled"] boolValue];
    duration = [defaults[@"duration"] integerValue];
    chargeMode = [defaults[@"chargeMode"] boolValue];
    chargingDuration = [defaults[@"chargingDuration"] integerValue];
}

void updateSettings(CFNotificationCenterRef center,
                    void *observer,
                    CFStringRef name,
                    const void *object,
                    CFDictionaryRef userInfo) {
    reloadPrefs();
}

%hook BehaviorClass

- (void)setIdleTimerDuration:(long long)arg {
    if (enabled) {
        BOOL charging = [[%c(SBUIController) sharedInstance] isBatteryCharging];
        return %orig((chargeMode && charging) ? chargingDuration : duration);
    }
    
    %orig(arg);
}

%end

%group iOS10
%hook SBDashBoardIdleTimerEventPublisher

- (BOOL)isEnabled {
    BOOL charging = [[%c(SBUIController) sharedInstance] isBatteryCharging];
    BOOL infite = ((chargeMode && charging && chargingDuration == 0) ||
                   (!chargeMode && duration == 0));
    return enabled && infite ? NO : %orig;
}

%end
%end

%group iOS11
%hook SBDashBoardIdleTimerProvider

- (BOOL)isIdleTimerEnabled {
    BOOL charging = [[%c(SBUIController) sharedInstance] isBatteryCharging];
    BOOL infite = ((chargeMode && charging && chargingDuration == 0) ||
                   (!chargeMode && duration == 0));
    return enabled && infite ? NO : %orig;    
}

%end
%end


@interface CSBehavior : NSObject
@end

@interface SBDashBoardBehavior : NSObject
@end

%ctor {
    reloadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &updateSettings, CFSTR(kPrefsChangedNotification), NULL, 0);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &updateSettings, CFSTR(kFlipswitchNotification), NULL, 0);

    Class behaviorClass = %c(CSBehavior) ? : %c(SBDashBoardBehavior);
    %init(BehaviorClass = behaviorClass);
    if (%c(SBDashBoardIdleTimerEventPublisher))
        %init(iOS10);
    else if (%c(SBDashBoardIdleTimerProvider))
        %init(iOS11)
}
