//
//  WBMultipleDelegates.h
//  WBMultipleDelegatesDemo
//
//  Created by wenbo on 2021/10/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBMultipleDelegates : NSObject

+ (instancetype)weakDelegates;
+ (instancetype)strongDelegates;

@property(nonatomic, strong, readonly) NSPointerArray *delegates;
@property(nonatomic, weak) NSObject *parentObject;

- (void)addDelegate:(id)delegate;
- (BOOL)removeDelegate:(id)delegate;
- (void)removeAllDelegates;
- (BOOL)containsDelegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
