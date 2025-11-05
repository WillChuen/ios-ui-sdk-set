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
#import <Masonry/Masonry.h>

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
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

///
- (void)updateLableText:(NSString *)contentText {
    self.textLabel.text = contentText;
}

///
- (RCBaseLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[RCBaseLabel alloc] initWithFrame:CGRectZero];
        _textLabel.numberOfLines = 2;
        [_textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        _textLabel.font = [[RCKitConfig defaultConfig].font fontOfFourthLevel];
    }
    return _textLabel;
}

@end
