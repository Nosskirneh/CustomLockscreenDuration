#import <Preferences/PSListController.h>

@interface CLDPrefsRootListController : PSListController

@end


@implementation CLDPrefsRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)sourceCode {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Nosskirneh/CustomLockscreenDuration"]];
}

- (void)donate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/nosskirneh"]];
}

- (void)sendEmail {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:andreaskhenriksson@gmail.com@gmail.com?subject=CustomLockscreenDuration"]];
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
