//
//  RCBaseCollectionViewCell.m
//  RongIMKit
//
//  Created by zgh on 2023/2/1.
//  Copyright © 2023 RongCloud. All rights reserved.
//

#import "RCBaseCollectionViewCell.h"
#import "RCSemanticContext.h"

@implementation RCBaseCollectionViewCell

///
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self updateRTLUI];
        [self openTester];
    }
    return self;
}

///
- (instancetype)init {
    self = [super init];
    if(self){
        [self updateRTLUI];
    }
    return self;
}

///
- (void)updateRTLUI {
    if ([RCSemanticContext isRTL]) {
        self.contentView.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    }else{
        self.contentView.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
    }
}

/// 打开测试
- (void)openTester {
    self.contentView.backgroundColor = [self randomColor];
}

/// 随机获取颜色
- (UIColor *)randomColor {
    CGFloat red = arc4random_uniform(256) / 255.0;
    CGFloat green = arc4random_uniform(256) / 255.0;
    CGFloat blue = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
