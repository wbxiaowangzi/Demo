//
//  DebugerInterface.h
//  Pods
//
//  Created by zhangjianfei on 16/9/2.
//

@import Foundation;

typedef void (^ClickBlock)(void);

@protocol DebugerInterface <NSObject>

+ (NSArray<NSArray<NSString *> *> *)titles;

+ (NSArray<ClickBlock> *)selectors;

@end
