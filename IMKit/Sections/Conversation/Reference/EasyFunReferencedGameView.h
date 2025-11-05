//
//  EasyFunReferencedGameView.h
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/30.
//

#import <UIKit/UIKit.h>
#import "EasyFunReferencedBaseView.h"

/// 引用游戏消息视图高度
#define EasyFunReferencedGameImageSize 24
/// 引用游戏消息视图内距离
#define EasyFunReferencedGameViewMaigin 4

// 24
@class RCloudImageView;
@class RCBaseLabel;
@class RCMessageContent;

NS_ASSUME_NONNULL_BEGIN

@interface EasyFunReferencedGameView : EasyFunReferencedBaseView

/// 图片引用视图
@property (nonatomic, strong) RCloudImageView *imageView;
/// 被引用消息内容文本 label
@property (nonatomic, strong) RCBaseLabel *textLabel;

/// 更新引用消息内容
- (void)updateMessageContent:(RCMessageContent *)content;

@end

NS_ASSUME_NONNULL_END
