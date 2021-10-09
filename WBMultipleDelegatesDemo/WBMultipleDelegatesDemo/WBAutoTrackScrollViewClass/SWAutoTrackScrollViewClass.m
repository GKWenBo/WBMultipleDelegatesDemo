//
//  SWAutoTrackScrollViewClass.m
//  Test
//
//  Created by wenbo on 2021/10/8.
//

#import "SWAutoTrackScrollViewClass.h"
#import <objc/runtime.h>

static NSString *const kSWAutoTrackDelegatePrefix = @"com.wb.autotrack.";

@implementation SWAutoTrackScrollViewClass

+ (void)proxyWithDelegate:(id<UIScrollViewDelegate>)delegate {
    SEL originalSelector = @selector(scrollViewDidScroll:);
    if (![delegate respondsToSelector:originalSelector]) {
        return;
    }
    
    ///  获取 delegate instance 的原始子类
    Class originalClass = object_getClass(delegate);
    NSString *originalClassName = NSStringFromClass(originalClass);
    if ([originalClassName hasPrefix:kSWAutoTrackDelegatePrefix]) {
        return;
    }
    
    NSString *subClassName = [kSWAutoTrackDelegatePrefix stringByAppendingString:NSStringFromClass(originalClass)];
    Class subClass = NSClassFromString(subClassName);
    if (!subClass) {
        /// 动态注册子类
        subClass = objc_allocateClassPair(originalClass, subClassName.UTF8String, 0);
        
        /// 给子类添加方法
        Method method = class_getInstanceMethod(self, originalSelector);
        IMP methodIMP = method_getImplementation(method);
        const char *types = method_getTypeEncoding(method);
        
        if (!class_addMethod(subClass, originalSelector, methodIMP, types)) {
            NSLog(@"cannot copy method to destination selector %@ as it already exists.", NSStringFromSelector(originalSelector));
        }
        
        /// 给子类对象添加 -(void)class 方法, 类似 kvo, 隐藏实现
        Method classMethod = class_getInstanceMethod(self, @selector(wb_class));
        IMP classIMP = method_getImplementation(classMethod);
        const char *classTypes = method_getTypeEncoding(classMethod);
        if (!class_addMethod(subClass, @selector(class), classIMP, classTypes)) {
            NSLog(@"Cannot copy method to destination selector -(void)class as it already exists");
        }
        
        // 子类和原始类的大小必须相同, 不能有更多的成员变量(ivars)或者属性
        // 如果不同, 将导致设置新的子类时, 重新分配内存, 重写对象的 isa 指针
        if (class_getInstanceSize(originalClass) != class_getInstanceSize(subClass)) {
            NSLog(@"Cannot create subclass of Delegate, because the created subclass is not the same size. %@", NSStringFromClass(originalClass));
            NSAssert(NO, @"Classes must be the same size to swizzle isa");
            return;
        }
        
        objc_registerClassPair(subClass);
    }
    
    // isa swizzling
    if (object_setClass(delegate, subClass)) {
        NSLog(@"Successfully created Delegate Proxy automatically");
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
    
    /// 获取原始类，也就是superClass
    Class cls = object_getClass(self);
    NSString *className = [NSStringFromClass(cls) stringByReplacingOccurrencesOfString:kSWAutoTrackDelegatePrefix withString:@""];
    Class originalClass = objc_getClass([className UTF8String]);
    
    
    /// 第二步 调用tableview.delegate 的方法!!! 也就是 superClass 的方法
    SEL originalSelector = @selector(scrollViewDidScroll:);
    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    IMP originalImplementation = method_getImplementation(originalMethod);
    if (originalImplementation) {
        // tableView:didSelectRowAtIndexPath: 方法指针类型
        ((void(*)(id, SEL, UIScrollView *))originalImplementation)(scrollView.delegate, originalSelector, scrollView);
    }
}

- (Class)wb_class {
    Class cls = object_getClass(self);
    NSString *className = [NSStringFromClass(cls) stringByReplacingOccurrencesOfString:kSWAutoTrackDelegatePrefix withString:@""];
    return NSClassFromString(className);
}

@end
