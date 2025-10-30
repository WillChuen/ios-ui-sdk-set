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

@protocol RCReferencingViewDelegate <NSObject>
@optional
- (void)didTapReferencingView:(RCMessageModel *)messageModel;

- (void)dismissReferencingView:(RCReferencingView *)referencingView;

@end

@interface RCReferencingView : RCBaseView

/// 关闭引用 button
@property (nonatomic, strong) RCBaseButton *dismissButton;

/// 被引用消息发送者名称
@property (nonatomic, strong) RCBaseLabel *nameLabel;

/// 被引用消息内容文本 label
@property (nonatomic, strong) RCBaseLabel *textLabel;

/// 当被引用的是图片消息时显示的 imageView
//@property (nonatomic, strong) RCloudImageView *imageView;

/// 当被引用的是小视频消息时显示的 sightView
//@property (nonatomic, strong) UIImageView * sightView;

/// 当前是否正在显示图片
//@property (nonatomic, assign) BOOL isReferencingImage;

/// 被引用消息体
@property (nonatomic, strong) RCMessageModel *referModel;

/// 引用代理
@property (nonatomic, weak) id<RCReferencingViewDelegate> delegate;

/// 初始化引用 View
- (instancetype)initWithModel:(RCMessageModel *)model inView:(UIView *)view;

/// 当前 view 的 Y 值
- (void)setOffsetY:(CGFloat)offsetY;

@end
