//
//  EasyFunReferencedSightView.h
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/30.
//

#import <UIKit/UIKit.h>

@class RCSightMessage;
@class RCloudImageView;
NS_ASSUME_NONNULL_BEGIN

/// 视屏引用视图
@interface EasyFunReferencedSightView : UIView

/// 视屏封面
@property (nonatomic, strong) RCloudImageView *coverImageView;
/// 播放按钮图标
@property (nonatomic, strong) RCloudImageView *iconImageView;

/// 更新小视频消息
- (void)updateSightMessage:(RCSightMessage *)sightMessage;

@end

NS_ASSUME_NONNULL_END
