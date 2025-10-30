//
//  EasyFunReferencedTextView.m
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/30.
//

#import "EasyFunReferencedTextView.h"
#import "RCKitUtility.h"
#import "RCBaseLabel.h"
#import "RCKitConfig.h"

@implementation EasyFunReferencedTextView

///
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

///
- (void)setUpUI {
    [self addSubview:self.textLabel];
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.textLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.textLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.textLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.textLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

///
- (RCBaseLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[RCBaseLabel alloc] initWithFrame:CGRectZero];
        _textLabel.numberOfLines = 1;
        [_textLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
        _textLabel.font = [[RCKitConfig defaultConfig].font fontOfFourthLevel];
    }
    return _textLabel;
}

@end
