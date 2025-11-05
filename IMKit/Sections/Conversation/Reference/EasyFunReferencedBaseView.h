//
//  EasyFunReferencedBaseView.h
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/11/5.
//

#import <UIKit/UIKit.h>

@class RCBaseLabel;

/// 引用视图名称内容与边距
#define easyfun_referenced_content_margin 6
/// 最长的昵称内容
#define easyfun_referenced_name_max_width 100

NS_ASSUME_NONNULL_BEGIN
/// 引用基础视图
@interface EasyFunReferencedBaseView : UIView
/// 被引用消息发送者名称
@property (nonatomic, strong) RCBaseLabel *nameLabel;
/// UI 初始化
- (void)setUpUI;
/// 更新用户名称文本
- (void)updateNameLabelText:(NSString *)nameText;

@end

NS_ASSUME_NONNULL_END
