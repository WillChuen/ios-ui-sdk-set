//
//  EasyFunReferencedContentView.h
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/30.
//

#import <UIKit/UIKit.h>
#import "RCMessageModel.h"
#import "RCBaseImageView.h"
#import "RCBaseLabel.h"
#import "RCAttributedLabel.h"

/// 被引用消息内容显示的 View
@class EasyFunReferencedTextView;
@class EasyFunReferencedImageView;
@class EasyFunReferencedSightView;
@class EasyFunReferencedLinkView;
@class EasyFunReferencedGameView;

NS_ASSUME_NONNULL_BEGIN

/// 被引用消息内容视图的代理
@protocol EasyFunReferencedContentViewDelegate <NSObject>

@optional
/// 点击被引用消息内容视图的回调
- (void)easyFunDidTapReferencedContentView:(RCMessageModel *)message;

@end

/// 被引用消息内容显示的 View
@interface EasyFunReferencedContentView : UIView

/// 代理
@property (nonatomic, weak) id<EasyFunReferencedContentViewDelegate> delegate;
/// 背景内容
@property (nonatomic, strong, nullable) UIView * backgroundContentView;
/// 全部内容
@property (nonatomic, strong, nullable) UIView * contentView;
/// 被引用消息发送者名称
@property (nonatomic, strong, nullable) RCBaseLabel *nameLabel;
/// 显示文本引用的视图
@property (nonatomic, strong, nullable) EasyFunReferencedTextView * textView;
/// 显示图片引用的视图
@property (nonatomic, strong, nullable) EasyFunReferencedImageView * imageView;
/// 显示小视频引用的视图
@property (nonatomic, strong, nullable) EasyFunReferencedSightView * sightView;
/// 显示链接引用的视图
@property (nonatomic, strong, nullable) EasyFunReferencedLinkView * linkView;
/// 显示游戏引用的视图
@property (nonatomic, strong, nullable) EasyFunReferencedGameView * gameView;

/// 设置被引用的消息内容和大小
- (void)setMessage:(RCMessageModel *)message contentSize:(CGSize)contentSize;

/// 在Cell重用的时候调用
- (void)prepareForReuse;

@end

NS_ASSUME_NONNULL_END
