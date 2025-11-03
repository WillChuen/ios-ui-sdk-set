//
//  RCBaseButton.m
//  RongIMKit
//
//  Created by zgh on 2023/2/1.
//  Copyright © 2023 RongCloud. All rights reserved.
//

#import "RCBaseButton.h"

@implementation RCBaseButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _hitTestEdgeInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero)) {
        return [super pointInside:point withEvent:event];
    }
    CGRect expandedBounds = UIEdgeInsetsInsetRect(self.bounds, self.hitTestEdgeInsets);
    return CGRectContainsPoint(expandedBounds, point);
}
@end
