//
//  SWRightBottomADView.h
//  Test
//
//  Created by wenbo on 2021/9/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWRightBottomADView : UIView

@property (nonatomic, assign, readonly) BOOL isAnimating;
@property (nonatomic, assign, readonly) BOOL isShow;

@property (nonatomic, assign) BOOL showCloseButton;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, copy) void (^closeBlock)(void);
@property (nonatomic, copy) void (^tapBlock)(void);

- (void)showAnimation;
- (void)hideAnimation;

@end

NS_ASSUME_NONNULL_END
