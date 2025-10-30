//
//  EasyFunReferencedLinkView.h
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/30.
//

#import <UIKit/UIKit.h>

@class RCloudImageView;
@class RCBaseLabel;
NS_ASSUME_NONNULL_BEGIN

@interface EasyFunReferencedLinkView : UIView

/// 图片引用视图
@property (nonatomic, strong) RCloudImageView *imageView;
/// 被引用消息内容文本 label
@property (nonatomic, strong) RCBaseLabel *textLabel;

@end

NS_ASSUME_NONNULL_END
