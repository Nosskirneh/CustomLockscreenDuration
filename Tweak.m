long long duration;

static void loadPrefs() {
    Boolean exists = false;
    CFPreferencesAppSynchronize(CFSTR("se.nosskirneh.customlockduration"));
    duration = CFPreferencesGetAppIntegerValue(CFSTR("duration"), CFSTR("se.nosskirneh.customlockduration"), &exists);
    if (!exists) HBLogError(@"Could not save get timer setting from plist!");
}


void updateSettings(CFNotificationCenterRef center,
                    void *observer,
                    CFStringRef name,
                    const void *object,
                    CFDictionaryRef userInfo) {
    loadPrefs();
}


%ctor {
    loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &updateSettings, CFStringRef(@"se.nosskirneh.customlockscreenduration/preferencesChanged"), NULL, 0);
    
}

%hook SBDashBoardBehavior

- (void)setIdleTimerDuration:(long long)arg {
    %orig(duration);
}

%end

%hook SBDashBoardIdleTimerEventPublisher

- (BOOL)isEnabled {
    return (duration == 0) ? NO : %orig;
}

%end
