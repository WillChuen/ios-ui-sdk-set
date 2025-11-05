//
//  EasyFunReferencedLinkView.h
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/30.
//

#import <UIKit/UIKit.h>
#import "EasyFunReferencedBaseView.h"

@class RCloudImageView;
@class RCBaseLabel;
@class RCMessageContent;
NS_ASSUME_NONNULL_BEGIN

@interface EasyFunReferencedLinkView : EasyFunReferencedBaseView

/// 图片引用视图
@property (nonatomic, strong) RCloudImageView *imageView;
/// 被引用消息内容文本 label
@property (nonatomic, strong) RCBaseLabel *textLabel;

/// 更新引用消息内容
- (void)updateMessageContent:(RCMessageContent *)content;

@end

NS_ASSUME_NONNULL_END
