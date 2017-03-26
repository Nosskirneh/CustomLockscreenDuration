#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import <notify.h>

NSMutableDictionary *preferences;
#define prefPath  [NSString stringWithFormat:@"%@/Library/Preferences/%@", NSHomeDirectory(),@"se.nosskirneh.customlockduration.plist"]

@interface CustomLockscreenDurationSwitch : NSObject <FSSwitchDataSource>
@end

@implementation CustomLockscreenDurationSwitch

- (NSString *)titleForSwitchIdentifier:(NSString *)switchIdentifier {
	return @"Custom Lockscreen Duration";
}

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier {
    // Update setting
    preferences = [NSMutableDictionary dictionaryWithContentsOfFile:[prefPath stringByExpandingTildeInPath]];
    
    BOOL enabled = [[preferences objectForKey:@"enabled"] boolValue];
    return (enabled) ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier {
	if (newState == FSSwitchStateIndeterminate) {
        return;
    }

    // Save changes
    preferences = [NSMutableDictionary dictionaryWithContentsOfFile:[prefPath stringByExpandingTildeInPath]];
    [preferences setObject:[NSNumber numberWithBool:newState] forKey:@"enabled"];
    [preferences writeToFile:prefPath atomically:YES];

    // Notify tweak
    notify_post("se.nosskirneh.customlockscreenduration.FSchanged");
}

@end
