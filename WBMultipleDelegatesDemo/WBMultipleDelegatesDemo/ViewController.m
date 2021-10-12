//
//  ViewController.m
//  Test
//
//  Created by wenbo on 2021/9/30.
//

#import "ViewController.h"
#import "SWRightBottomADView.h"
#import "WBMultipleDelegates.h"

#import "UIView+Sizes.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SWRightBottomADView *rightView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WBMultipleDelegates *mutipleDelegate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    SWRightBottomADView *view = [[SWRightBottomADView alloc] initWithFrame:CGRectZero];
    [view sizeToFit];
    view.bottom = self.view.bottom - 100;
    view.left = self.view.width - view.width;
    view.clipsToBounds = YES;
    [self.view addSubview:view];
    self.rightView = view;
    
    _tableView.delegate = (id)self.mutipleDelegate;
}

// MARK: - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.rightView.showCloseButton = !self.rightView.showCloseButton;
}

// MARK: - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
}

// MARK: - getter
- (WBMultipleDelegates *)mutipleDelegate {
    if (!_mutipleDelegate) {
        _mutipleDelegate = [WBMultipleDelegates weakDelegates];
        [_mutipleDelegate addDelegate:self];
        [_mutipleDelegate addDelegate:self.rightView];
    }
    return _mutipleDelegate;
}
@end
