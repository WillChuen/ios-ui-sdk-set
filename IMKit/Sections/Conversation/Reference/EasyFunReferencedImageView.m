//
//  EasyFunReferencedImageView.m
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/30.
//

#import "EasyFunReferencedImageView.h"
#import "RCBaseLabel.h"
#import "RCloudImageView.h"
#import "RCImageMessage.h"
#import "RCRichContentMessage.h"
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
    [self addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_lessThanOrEqualTo(easyfun_referenced_name_max_width);
        make.leading.mas_equalTo(self.mas_leading);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(easyfun_referenced_content_margin);
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

/// 更新富文本消息
- (void)updateRichContentMessage:(RCRichContentMessage *)message {
    NSURL *imageURL = [NSURL URLWithString:message.imageURL];
    self.imageView.imageURL = imageURL;
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

@end
