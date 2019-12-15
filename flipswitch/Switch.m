#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import "../Common.h"
#import <notify.h>

@interface CustomLockscreenDurationSwitch : NSObject<FSSwitchDataSource>
@end

@implementation CustomLockscreenDurationSwitch

- (NSString *)titleForSwitchIdentifier:(NSString *)switchIdentifier {
	return @"Custom Lockscreen Duration";
}

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier {
    // Update setting
    NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:kPrefPath];
    
    BOOL enabled = [preferences[@"enabled"] boolValue];
    return (enabled) ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier {
	if (newState == FSSwitchStateIndeterminate)
        return;

    // Save changes
    NSMutableDictionary *preferences = [NSMutableDictionary dictionaryWithContentsOfFile:kPrefPath];
    preferences[@"enabled"] = @(newState);
    [preferences writeToFile:kPrefPath atomically:YES];

    // Notify tweak
    notify_post(kFlipswitchNotification);
}

@end
