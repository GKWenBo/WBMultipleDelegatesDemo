//
//  UIScrollView+SWAddition.h
//  SinaWeather
//
//  Created by wenbo on 2021/9/30.
//  Copyright © 2021 tianqitong.sina.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SWScrollDirection) {
    SWScrollDirectionUp,
    SWScrollDirectionDown,
    SWScrollDirectionLeft,
    SWScrollDirectionRight,
    SWScrollDirectionWTF
};

@interface UIScrollView (SWAddition)

/// 滑动方向
@property (nonatomic, assign, readonly) SWScrollDirection sw_scrollDirection;

@end

NS_ASSUME_NONNULL_END
