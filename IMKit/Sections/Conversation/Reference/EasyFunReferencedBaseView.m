//
//  EasyFunReferencedBaseView.m
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/11/5.
//

#import "EasyFunReferencedBaseView.h"
#import "RCBaseLabel.h"
#import "RCKitUtility.h"
#import "RCKitCommonDefine.h"

@implementation EasyFunReferencedBaseView

/// UI 初始化
- (void)setUpUI { }

/// 更新用户名称文本
- (void)updateNameLabelText:(NSString *)nameText {
    self.nameLabel.text = nameText;
}

/// 被引用消息发送者名称
- (RCBaseLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[RCBaseLabel alloc] init];
        _nameLabel.textColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x111f2c) darkColor:RCMASKCOLOR(0xffffff, 0.4)];
        _nameLabel.font = [UIFont systemFontOfSize:12];
    }
    return _nameLabel;
}
@end
