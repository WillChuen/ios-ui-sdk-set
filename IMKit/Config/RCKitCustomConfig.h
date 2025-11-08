//
//  RCKitCustomConfig.h
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/28.
//

#import <Foundation/Foundation.h>

@class RCMessageContent;
@class RCMessageModel;

NS_ASSUME_NONNULL_BEGIN
/// 自定义配置工厂
@protocol RCKitCustomConfigFactory <NSObject>

@optional
/// 获取业务配置
- (NSDictionary * _Nullable)getMessageCustomConfig:(RCMessageContent *)messageContent;
/// 将秒转换成几小时前、几天前等字符串
- (NSString * _Nullable)stringFromTimeInterval:(NSInteger)seconds;
/// 二次组装用户昵称
- (NSMutableAttributedString * _Nullable)assembleUserName:(NSString *)originName
                                                  font:(UIFont *)font
                                                textColor:(UIColor *)textColor
                                             messageModel:(RCMessageModel * _Nullable)messageModel;
@end

/// 自定义业务配置类
@interface RCKitCustomConfig : NSObject

/// 扩展面板相册标题
@property (nonatomic, copy) NSString *extensionPanelAlbumTitle;
/// 扩展面板拍照标题
@property (nonatomic, copy) NSString *extensionPanelCameraTitle;
/// 表情面板发送按钮文本
@property (nonatomic, copy) NSString *emojiPanelSendText;

/// 相册选择: 相册列表
@property (nonatomic, copy) NSString *photoAlbumTitle;
/// 相册选择: 取消按钮
@property (nonatomic, copy) NSString *photoAlbumCancelTitle;
/// 相册选择: 预览
@property (nonatomic, copy) NSString *photoAlbumPreviewTitle;
/// 相册选择: 发送
@property (nonatomic, copy) NSString *photoAlbumSendTitle;
/// 相册选择: 原图
@property (nonatomic, copy) NSString *photoAlbumOriginalTitle;

/// 相册选择: 取消按钮标题颜色
@property (nonatomic, strong) UIColor *photoAlbumCancelTitleColor;
/// 相册选择: 导航栏的tintColor
@property (nonatomic, strong) UIColor *photoAlbumNavigationTintColor;
/// 相册选择: 发送按钮标题颜色
@property (nonatomic, strong) UIColor *photoAlbumSendTitleColor;


/// 小视频: 轻触拍摄，按住摄像
@property (nonatomic, copy) NSString *sightCaptureHintText;

/// 默认头像
@property (nonatomic, strong, nullable) UIImage *defaultAvatar;
/// 长方形默认占位图
@property (nonatomic, strong, nullable) UIImage *placeholderRectangle;
/// 正方形默认占位图
@property (nonatomic, strong, nullable) UIImage *placeholderSquare;
/// 长方形默认失败图
@property (nonatomic, strong, nullable) UIImage *loadingFailedRectangle;
/// 正方形默认失败图
@property (nonatomic, strong, nullable) UIImage *loadingFailedSquare;
/// 气泡左侧图片
@property (nonatomic, strong, nullable) UIImage *bubbleLeftImage;
/// 气泡右侧图片
@property (nonatomic, strong, nullable) UIImage *bubbleRightImage;
/// 输入框占装扮图片
@property (nonatomic, strong, nullable) UIImage *inputTextViewDecorationImage;

/// 自定义配置工厂
@property (nonatomic, weak) id<RCKitCustomConfigFactory> factory;

/// 获取业务配置
- (NSDictionary * _Nullable)getMessageCustomConfig:(RCMessageContent *)messageContent;

/// 将毫秒转换成几小时前、几天前等字符串
- (NSString * _Nullable)stringFromTimeInterval:(long long)sentTime;

/// 二次组装用户昵称
- (NSMutableAttributedString * _Nullable)assembleUserName:(NSString *)originName
                                                    font:(UIFont *)font
                                                textColor:(UIColor *)textColor
                                                messageModel:(RCMessageModel * _Nullable)messageModel;
@end

NS_ASSUME_NONNULL_END
