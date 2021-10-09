//
//  SWRightBottomADView.m
//  Test
//
//  Created by wenbo on 2021/9/30.
//

#import "SWRightBottomADView.h"
#import "UIScrollView+SWAddition.h"

static CGFloat const SWRightBottomADShowDuration = 0.3f;
static CGFloat const SWRightBottomADDismissDuration = 0.3f;

@interface SWRightBottomADView ()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL isShow;

@end

@implementation SWRightBottomADView

- (void)dealloc {
    [self removeObserver];
}

// MARK: - Init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    self.clipsToBounds = YES;
    self.isShow = YES;
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.backgroundColor = [UIColor yellowColor];
    [_closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
    
    _imageView = [UIImageView new];
    _imageView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect closeButtonFrame = CGRectZero;
    CGRect imageViewFrame = CGRectZero;
    if (_showCloseButton) {
        closeButtonFrame = CGRectMake((CGRectGetWidth(self.bounds) - 40) / 2, 0, 40, 40);
        imageViewFrame = CGRectMake(0,  CGRectGetMaxY(closeButtonFrame) + 10, CGRectGetWidth(self.bounds), 200);
    } else {
        closeButtonFrame = CGRectMake((CGRectGetWidth(self.bounds) - 40) / 2, 0, 40, 0);
        imageViewFrame = CGRectMake(0,  CGRectGetMaxY(closeButtonFrame), CGRectGetWidth(self.bounds), 200);
    }
    
    _closeButton.frame = closeButtonFrame;
    _imageView.frame = imageViewFrame;
    
    CGRect frame = self.frame;
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, CGRectGetHeight(closeButtonFrame) + CGRectGetHeight(_imageView.bounds));
    self.frame = frame;
}

// MARK: - private method
- (void)removeObserver {
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (void)addObserver {
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)handleScrollViewScroll:(UIScrollView *)scrollView {
    if (!scrollView.isDragging && !scrollView.isTracking && !scrollView.isDecelerating) return;
    
    if (scrollView.sw_scrollDirection == SWScrollDirectionUp) {
        NSLog(@"up");
        [self showAnimation];
    } else if (scrollView.sw_scrollDirection == SWScrollDirectionDown) {
        NSLog(@"down");
        [self hideAnimation];
    }
}

// MARK: - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _scrollView) {
        [self handleScrollViewScroll:_scrollView];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// MARK: - Animation
- (void)showAnimation {
    if (self.isShow || self.isAnimating) return;
    
    self.isAnimating = YES;
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:SWRightBottomADShowDuration
                     animations:^{
        frame = CGRectMake(CGRectGetWidth(self.superview.bounds) - CGRectGetWidth(self.bounds), frame.origin.y, frame.size.width, frame.size.height);
        self.frame = frame;
    }
                     completion:^(BOOL finished) {
        self.isShow = YES;
        self.isAnimating = NO;
    }];
}

- (void)hideAnimation {
    if (!self.isShow || self.isAnimating) return;
    
    self.isAnimating = YES;
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:SWRightBottomADDismissDuration
                     animations:^{
        frame = CGRectMake(CGRectGetWidth(self.superview.bounds) - CGRectGetWidth(self.bounds) + CGRectGetWidth(self.bounds) * .5, frame.origin.y, frame.size.width, frame.size.height);
        self.frame = frame;
    }
                     completion:^(BOOL finished) {
        self.isShow = NO;
        self.isAnimating = NO;
    }];
}

// MARK: - event response
- (void)closeButtonClicked {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)tapAction {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

// MARK: - setter
- (void)setShowCloseButton:(BOOL)showCloseButton {
    _showCloseButton = showCloseButton;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView) {
        [self removeObserver];
    }
    _scrollView = scrollView;
    
    [self addObserver];
}

// MARK: - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
}

@end
