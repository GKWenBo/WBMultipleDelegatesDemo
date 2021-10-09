//
//  SWAutoTrackScrollViewClass.h
//  Test
//
//  Created by wenbo on 2021/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWAutoTrackScrollViewClass : NSObject

+ (void)proxyWithDelegate:(id<UIScrollViewDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
