//
//  EasyFunReferencedSightView.m
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/30.
//

#import "EasyFunReferencedSightView.h"
#import "RCloudImageView.h"
#import "RCKitCommonDefine.h"
#import "RCBaseLabel.h"
#import <Masonry/Masonry.h>

///
@implementation EasyFunReferencedSightView
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
    [self addSubview:self.nameLabel];
    [self addSubview:self.coverImageView];
    [self addSubview:self.iconImageView];
    //
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_lessThanOrEqualTo(easyfun_referenced_name_max_width);
        make.leading.mas_equalTo(self.mas_leading);
    }];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(easyfun_referenced_content_margin);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(23);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.coverImageView.mas_centerX);
        make.centerY.mas_equalTo(self.coverImageView.mas_centerY);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
}

/// 更新视图内容
- (void)updateSightMessage:(RCSightMessage *)sightMessage {
    // 封面图
    self.coverImageView.image = sightMessage.thumbnailImage;
    self.iconImageView.image = RCResourceImage(@"easy_fun_burn_video_picture");
}

/// 封面图片视图
- (RCloudImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[RCloudImageView alloc] initWithFrame:(CGRectZero)];
        _coverImageView.layer.cornerRadius = 2;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}

/// 图标图片视图
- (RCloudImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[RCloudImageView alloc] initWithFrame:(CGRectZero)];
    }
    return _iconImageView;
}

@end
