//
//  RCKitCustomConfig.m
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/28.
//

#import "RCKitCustomConfig.h"
#import "RCKitUtility.h"

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

@end
