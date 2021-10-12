//
//  SWRightBottomADView.m
//  Test
//
//  Created by wenbo on 2021/9/30.
//

#import "SWRightBottomADView.h"
//#import "UIScrollView+SWAddition.h"
#import "UIView+Sizes.h"

static CGFloat const kSWRightBottomADShowDuration = 0.3f;
static CGFloat const kSWRightBottomADDismissDuration = 0.3f;
static CGFloat const kImageViewHeight = 60;
static CGFloat const kButtonImageMargin = 5;

@interface SWRightBottomADView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL isShow;

@end

@implementation SWRightBottomADView

- (void)dealloc {
//    [self removeObserver];
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
    [_closeButton setImage:[UIImage imageNamed:@"AD_offbutton"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton sizeToFit];
    [self addSubview:_closeButton];
    
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeLeft;
    [self setupImage:[UIImage imageNamed:@"素材"]];
    [self addSubview:_imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
     
    if (!self.imageView.image) return;
    
    CGSize imageSize = _imageView.size;
    CGSize buttonSize = _closeButton.size;
    
    self.width = imageSize.width;
    self.height = imageSize.height + buttonSize.height + kButtonImageMargin;
    
    self.closeButton.top = 0;
    self.closeButton.right = self.width - 12;
    
    self.imageView.top = self.closeButton.bottom + kButtonImageMargin;
    self.imageView.left = 0;
}

- (CGSize)sizeThatFits:(CGSize)size {
    if (!self.imageView.image) {
        return CGSizeZero;
    }
    CGFloat w = self.imageView.width;
    CGFloat h = self.imageView.height + self.closeButton.height + kButtonImageMargin;
    return CGSizeMake(w, h);
}

// MARK: - private method
- (void)setupImage:(UIImage *)image {
    if (!image) return;
    
    CGFloat imageW = image.size.width / image.size.height * kImageViewHeight;
    // TODO: - 宽度限制
    self.imageView.size = CGSizeMake(imageW, kImageViewHeight);
    
    self.imageView.image = image;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

// MARK: - Animation
- (void)showAnimation {
    if (self.isShow || self.isAnimating) return;
    
    self.isAnimating = YES;
    
    [UIView animateWithDuration:kSWRightBottomADShowDuration
                     animations:^{
        self.closeButton.alpha = 1.f;
        self.imageView.alpha = 1.f;
        
        self.left = self.superview.width - self.width;
    }
                     completion:^(BOOL finished) {
        self.isShow = YES;
        self.isAnimating = NO;
    }];
}

- (void)hideAnimation {
    if (!self.isShow || self.isAnimating) return;
    
    self.isAnimating = YES;
    
    self.closeButton.alpha = 1.f;
    self.imageView.alpha = 1.f;
    [UIView animateWithDuration:kSWRightBottomADDismissDuration
                     animations:^{
        self.closeButton.alpha = 0.f;
        self.imageView.alpha = .4f;
        
        self.left = self.superview.width - self.width * .5;
    }
                     completion:^(BOOL finished) {
        self.isShow = NO;
        self.isAnimating = NO;
    }];
}

- (void)delayShowAnimation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showAnimation) object:nil];
    [self performSelector:@selector(showAnimation) withObject:nil afterDelay:2];
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
    
    self.closeButton.hidden = !showCloseButton;
}

// MARK: - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetYLimit = 500;
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"offsetY = %f", offsetY);
    if (offsetY > offsetYLimit) {
        [self performSelector:@selector(hideAnimation)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self delayShowAnimation];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self delayShowAnimation];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self delayShowAnimation];
    }
}

@end
