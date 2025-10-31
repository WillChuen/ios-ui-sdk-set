//
//  EasyFunReferencedGameView.m
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/30.
//

#import "EasyFunReferencedGameView.h"
#import "RCloudImageView.h"
#import "RCKitUtility.h"
#import "RCBaseLabel.h"
#import "RCKitConfig.h"
#import <Masonry/Masonry.h>

#define EasyFunReferencedGameImageWidth 24
#define EasyFunReferencedGameImageHeight 24

@implementation EasyFunReferencedGameView
///
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

/// 设置UI
- (void)setUpUI {
    //
    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];
    //
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.imageView.mas_trailing).offset(4);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

/// 更新引用消息内容
- (void)updateMessageContent:(RCMessageContent *)content {
    NSDictionary * customConfig = [[RCKitConfig defaultConfig].custom getMessageCustomConfig:content];
    NSString * name = customConfig[@"name"];
    NSString * iconUrl = customConfig[@"iconUrl"];
    self.textLabel.text = name;
    [self.imageView setImageURL:[NSURL URLWithString:iconUrl]];
}

/// 图片引用视图
- (RCloudImageView *)imageView {
    if (!_imageView) {
        _imageView = [[RCloudImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 2;
        _imageView.layer.masksToBounds = YES;
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

/// 文本引用视图
- (RCBaseLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[RCBaseLabel alloc] initWithFrame:CGRectZero];
        _textLabel.numberOfLines = 1;
        [_textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        _textLabel.font = [[RCKitConfig defaultConfig].font fontOfFourthLevel];
        _textLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _textLabel;
}

@end
