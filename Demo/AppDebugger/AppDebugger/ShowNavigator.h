//
//  ShowNavigator.h
//  Pods
//
//  Created by zhangjianfei on 16/9/2.
//

@import Foundation;

#import "DebuggerInterface.h"
#import <UIKit/UIKit.h>

@interface ShowNavigator : NSObject<DebugerInterface>

+ (NSArray<NSArray<NSString *> *> *)titles;

+ (NSArray<ClickBlock> *)selectors;

@end

