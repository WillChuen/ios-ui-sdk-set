//
//  RCKitCustomConfig.h
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/28.
//

#import <Foundation/Foundation.h>

@class RCMessageContent;

NS_ASSUME_NONNULL_BEGIN
/// 自定义配置工厂
@protocol RCKitCustomConfigFactory <NSObject>

@optional
/// 获取业务配置
- (NSDictionary * _Nullable)getMessageCustomConfig:(RCMessageContent *)messageContent;

@end

/// 自定义业务配置类
@interface RCKitCustomConfig : NSObject

/// 扩展面板相册标题
@property (nonatomic, copy) NSString *extensionPanelAlbumTitle;
/// 扩展面板拍照标题
@property (nonatomic, copy) NSString *extensionPanelCameraTitle;
/// 表情面板发送按钮文本
@property (nonatomic, copy) NSString *emojiPanelSendText;

/// 自定义配置工厂
@property (nonatomic, weak) id<RCKitCustomConfigFactory> factory;

/// 获取业务配置
- (NSDictionary * _Nullable)getMessageCustomConfig:(RCMessageContent *)messageContent;

@end

NS_ASSUME_NONNULL_END
