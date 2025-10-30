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
//    [self addSubview:self.imageView];
//    [self addSubview:self.textLabel];
//    
//    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [NSLayoutConstraint activateConstraints:@[
//        //
//        [self.imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
//        [self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor],
//        [self.imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
//        [self.imageView.widthAnchor constraintEqualToConstant:EasyFunReferencedGameImageWidth],
//        [self.imageView.heightAnchor constraintEqualToConstant:EasyFunReferencedGameImageHeight],
//        //
//        [self.textLabel.leadingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor constant:4],
//        [self.textLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
//        [self.textLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
//    ]];
}

/// 图片引用视图
- (RCloudImageView *)imageView {
    if (!_imageView) {
        _imageView = [[RCloudImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 2;
        _imageView.layer.masksToBounds = YES;
        _imageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _imageView;
}

///
- (RCBaseLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[RCBaseLabel alloc] initWithFrame:CGRectZero];
        _textLabel.numberOfLines = 1;
        [_textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        _textLabel.font = [[RCKitConfig defaultConfig].font fontOfFourthLevel];
    }
    return _textLabel;
}

@end
