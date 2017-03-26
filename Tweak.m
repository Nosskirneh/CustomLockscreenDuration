#define prefPath [NSString stringWithFormat:@"%@/Library/Preferences/%@", NSHomeDirectory(),@"se.nosskirneh.customlockduration.plist"]

long long duration;
BOOL enabled;

static void reloadPrefs() {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:prefPath]];
    enabled = [[defaults objectForKey:@"enabled"] boolValue];
    duration = [[defaults objectForKey:@"duration"] integerValue];
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
    %orig(enabled ? duration : arg);
}

%end

%hook SBDashBoardIdleTimerEventPublisher

- (BOOL)isEnabled {
    return (enabled && duration == 0) ? NO : %orig;
}

%end
