//
//  RCBaseButton.h
//  RongIMKit
//
//  Created by zgh on 2023/2/1.
//  Copyright © 2023 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// - Since: 5.4.0
@interface RCBaseButton : UIButton

/// 扩展点击区域的边距（负值表示向外扩展）
/// 例如：UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10) 表示向外扩展10个点
/// - Since: 5.4.0
@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

@end

NS_ASSUME_NONNULL_END

