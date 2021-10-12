//
//  UITableView+WBAutoTrack.m
//  WBMultipleDelegatesDemo
//
//  Created by wenbo on 2021/10/9.
//

#import "UITableView+WBAutoTrack.h"
#import "WBSwizzle.h"

#import "SWAutoTrackScrollViewClass.h"

@implementation UITableView (WBAutoTrack)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        swizzleInstanceMethod(self.class, @selector(setDelegate:), @selector(wb_setDelegate:));
//    });
//}
//
//- (void)wb_setDelegate:(id<UITableViewDelegate>)delegate {
//    [self wb_setDelegate:delegate];
//    
//    [SWAutoTrackScrollViewClass proxyWithDelegate:delegate];
//}

@end
