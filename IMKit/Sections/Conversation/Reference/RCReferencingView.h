//
//  RCReferencingView.h
//  RongIMKit
//
//  Created by 张改红 on 2020/2/27.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCMessageModel.h"
#import "RCBaseButton.h"
#import "RCBaseView.h"
#import "RCBaseLabel.h"
#import "RCloudImageView.h"

@class RCReferencingView;
@class EasyFunReferencedTextView;
@class EasyFunReferencedImageView;
@class EasyFunReferencedSightView;
@class EasyFunReferencedLinkView;
@class EasyFunReferencedGameView;

@protocol RCReferencingViewDelegate <NSObject>
@optional
- (void)didTapReferencingView:(RCMessageModel *)messageModel;

- (void)dismissReferencingView:(RCReferencingView *)referencingView;

- (void)dismissReferencingViewForce:(RCReferencingView *)referencingView;

@end

@interface RCReferencingView : RCBaseView

/// 所有内容
@property (nonatomic, strong) UIView *contentView;

/// 关闭引用 button
@property (nonatomic, strong) RCBaseButton *dismissButton;

/// 被引用消息发送者名称
@property (nonatomic, strong) RCBaseLabel *nameLabel;

/// 文本引用内容
@property (nonatomic, strong) EasyFunReferencedTextView *textReferView;

/// 图片引用内容
@property (nonatomic, strong) EasyFunReferencedImageView *imageReferView;

/// 小视频引用内容
@property (nonatomic, strong) EasyFunReferencedSightView *sightReferView;

/// 链接引用内容
@property (nonatomic, strong) EasyFunReferencedLinkView *linkReferView;

/// 游戏引用内容
@property (nonatomic, strong) EasyFunReferencedGameView *gameReferView;

/// 被引用消息体
@property (nonatomic, strong) RCMessageModel *referModel;

/// 引用代理
@property (nonatomic, weak) id<RCReferencingViewDelegate> delegate;

/// 初始化引用 View
- (instancetype)initWithModel:(RCMessageModel *)model inView:(UIView *)view;

/// 当前 view 的 Y 值
- (void)setOffsetY:(CGFloat)offsetY;

@end
