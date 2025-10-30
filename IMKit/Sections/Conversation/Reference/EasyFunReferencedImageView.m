//
//  EasyFunReferencedImageView.m
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/30.
//

#import "EasyFunReferencedImageView.h"
#import "RCloudImageView.h"
#import "RCImageMessage.h"
#import <Masonry/Masonry.h>

#define EasyFunReferencedImageWidth 40
#define EasyFunReferencedImageHeight 23

@implementation EasyFunReferencedImageView
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
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(EasyFunReferencedImageWidth);
        make.height.mas_equalTo(EasyFunReferencedImageHeight);
    }];
}

/// 更新图片消息
- (void)updateImageMessage:(RCImageMessage *)message {
    // 显示缩略图
    self.imageView.image = message.thumbnailImage;
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

@end
