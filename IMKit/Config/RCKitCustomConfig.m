//
//  RCKitCustomConfig.m
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/28.
//

#import "RCKitCustomConfig.h"

@implementation RCKitCustomConfig

/// 获取业务配置
- (NSDictionary * _Nullable)getMessageCustomConfig:(RCMessageContent *)messageContent {
    if (self.factory && [self.factory respondsToSelector:@selector(getMessageCustomConfig:)]) {
        return [self.factory getMessageCustomConfig:messageContent];
    }
    return nil;
}
@end
