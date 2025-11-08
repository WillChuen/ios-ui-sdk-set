//
//  RCKitCustomConfig.m
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/28.
//

#import "RCKitCustomConfig.h"
#import "RCKitUtility.h"
#import "RCMessageModel.h"

@implementation RCKitCustomConfig

/// 获取业务配置
- (NSDictionary * _Nullable)getMessageCustomConfig:(RCMessageContent *)messageContent {
    if (self.factory && [self.factory respondsToSelector:@selector(getMessageCustomConfig:)]) {
        return [self.factory getMessageCustomConfig:messageContent];
    }
    return nil;
}

/// 将毫秒转换成几小时前、几天前等字符串
- (NSString * _Nullable)stringFromTimeInterval:(long long)sentTime {
    NSString * timeText;
    if (self.factory && [self.factory respondsToSelector:@selector(stringFromTimeInterval:)]) {
        timeText = [self.factory stringFromTimeInterval:sentTime/1000];
    }
    if (!timeText || timeText.length == 0) {
        timeText = [RCKitUtility convertMessageTime:sentTime / 1000];
    }
    return timeText;
}

/// 二次组装用户昵称
- (NSMutableAttributedString * _Nullable)assembleUserName:(NSString *)originName
                                                    font:(UIFont *)font
                                                textColor:(UIColor *)textColor
                                             messageModel:(RCMessageModel * _Nullable)messageModel {
    // 原始昵称为空，返回空字符串
    if (!originName || originName.length == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    // 没有自定义组装逻辑，返回默认昵称
    if (messageModel == nil) {
        return [[NSMutableAttributedString alloc] initWithString:originName attributes:@{
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: textColor
        }];
    }
    // 有自定义组装逻辑，调用自定义逻辑
    if (self.factory && [self.factory respondsToSelector:@selector(assembleUserName:font:textColor:messageModel:)]) {
        NSMutableAttributedString * customName = [self.factory assembleUserName:originName font:font textColor:textColor messageModel:messageModel];
        if (customName) {
            return customName;
        }
    }
    // 自定义逻辑没有返回值，返回默认昵称
    return [[NSMutableAttributedString alloc] initWithString:originName attributes:@{
        NSFontAttributeName: font,
        NSForegroundColorAttributeName: textColor
    }];
}

@end
