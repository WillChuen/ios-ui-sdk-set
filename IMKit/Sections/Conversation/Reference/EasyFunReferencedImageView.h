//
//  EasyFunReferencedImageView.h
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/30.
//

#import <UIKit/UIKit.h>

@class RCloudImageView;
@class RCImageMessage;
@class RCRichContentMessage;
NS_ASSUME_NONNULL_BEGIN

@interface EasyFunReferencedImageView : UIView
/// 图片引用视图
@property (nonatomic, strong) RCloudImageView *imageView;
/// 更新图片消息
- (void)updateImageMessage:(RCImageMessage *)message;
/// 更新富文本消息
- (void)updateRichContentMessage:(RCRichContentMessage *)message;

@end

NS_ASSUME_NONNULL_END
