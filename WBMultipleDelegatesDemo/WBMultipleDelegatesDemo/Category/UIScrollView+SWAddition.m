//
//  UIScrollView+SWAddition.m
//  SinaWeather
//
//  Created by wenbo on 2021/9/30.
//  Copyright © 2021 tianqitong.sina.cn. All rights reserved.
//

#import "UIScrollView+SWAddition.h"

@implementation UIScrollView (SWAddition)

- (SWScrollDirection)sw_scrollDirection {
    SWScrollDirection direction;
    
    if ([self.panGestureRecognizer translationInView:self.superview].y > 0.0f) {
        direction = SWScrollDirectionUp;
    } else if ([self.panGestureRecognizer translationInView:self.superview].y < 0.0f) {
        direction = SWScrollDirectionDown;
    } else if ([self.panGestureRecognizer translationInView:self].x < 0.0f) {
        direction = SWScrollDirectionLeft;
    } else if ([self.panGestureRecognizer translationInView:self].x > 0.0f) {
        direction = SWScrollDirectionRight;
    } else {
        direction = SWScrollDirectionWTF;
    }
    
    return direction;
}

@end
