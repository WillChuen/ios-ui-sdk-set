//
//  RCKitCustomConfig.h
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 自定义业务配置类
@interface RCKitCustomConfig : NSObject

/// 扩展面板相册标题
@property (nonatomic, copy) NSString *extensionPanelAlbumTitle;
/// 扩展面板拍照标题
@property (nonatomic, copy) NSString *extensionPanelCameraTitle;

@end

NS_ASSUME_NONNULL_END
