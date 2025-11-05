//
//  EasyFunReferencedTextView.h
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/30.
//

#import <UIKit/UIKit.h>
#import "EasyFunReferencedBaseView.h"

@class RCBaseLabel;
NS_ASSUME_NONNULL_BEGIN

@interface EasyFunReferencedTextView : EasyFunReferencedBaseView
/// 被引用消息内容文本 label
@property (nonatomic, strong) RCBaseLabel *textLabel;
/// 直接更新文本
- (void)updateLableText:(NSString *)contentText;

@end

NS_ASSUME_NONNULL_END
