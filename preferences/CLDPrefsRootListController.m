#import <Preferences/PSListController.h>
#import "Preferences/PSSpecifier.h"

@interface CLDPrefsRootListController : PSListController
@end

CLDPrefsRootListController *listController;
#define prefPath [NSString stringWithFormat:@"%@/Library/Preferences/%@", NSHomeDirectory(),@"se.nosskirneh.customlockduration.plist"]

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [listController.table reloadData];
    return;
}


@implementation CLDPrefsRootListController

- (id)readPreferenceValue:(PSSpecifier*)specifier {
    NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:prefPath];
   
    if (!preferences[specifier.properties[@"key"]]) {
        return specifier.properties[@"default"];
    }

    return preferences[specifier.properties[@"key"]];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:prefPath]];
    [defaults setObject:value forKey:specifier.properties[@"key"]];
    [defaults writeToFile:prefPath atomically:YES];
    CFStringRef cldpost = (CFStringRef)CFBridgingRetain(specifier.properties[@"PostNotification"]);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), cldpost, NULL, NULL, YES);
}

- (void)loadView {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("se.nosskirneh.customlockscreenduration.FSchanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    [super loadView];

}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

    listController = self;
	return _specifiers;
}

- (void)donate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/nosskirneh"]];
}

- (void)sendEmail {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:andreaskhenriksson@gmail.com@gmail.com?subject=CustomLockscreenDuration"]];
}

- (void)sourceCode {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Nosskirneh/CustomLockscreenDuration"]];
}

- (void)icon {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://emojione.com/"]];
}

@end

@interface PSTableCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier;
@end

@interface CLDHeaderCell : PSTableCell
@end

@implementation CLDHeaderCell {
    UILabel *_headerLabel;
    UILabel *_subheaderLabel;
}

- (id)initWithSpecifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];
    if (self) {
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:24];
        
        _headerLabel = [[UILabel alloc] init];
        [_headerLabel setText:@"CustomLockscreenDuration"];
        [_headerLabel setTextColor:[UIColor blackColor]];
        [_headerLabel setFont:font];
        
        _subheaderLabel = [[UILabel alloc] init];
        [_subheaderLabel setText:@"by Andreas Henriksson"];
        [_subheaderLabel setTextColor:[UIColor grayColor]];
        [_subheaderLabel setFont:[font fontWithSize:17]];
        
        [self addSubview:_headerLabel];
        [self addSubview:_subheaderLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_headerLabel sizeToFit];
    [_subheaderLabel sizeToFit];
    
    CGRect frame = _headerLabel.frame;
    frame.origin.y = 20;
    frame.origin.x = self.frame.size.width / 2 - _headerLabel.frame.size.width / 2;
    _headerLabel.frame = frame;
    
    frame.origin.y += _headerLabel.frame.size.height;
    frame.origin.x = self.frame.size.width / 2 - _subheaderLabel.frame.size.width / 2;
    _subheaderLabel.frame = frame;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width {
    // Return a custom cell height.
    return 80;
}

@end
