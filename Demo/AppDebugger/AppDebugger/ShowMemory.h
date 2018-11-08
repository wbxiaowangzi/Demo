//
//  ShowMemory.h
//  Pods
//
//  Created by zhangjianfei on 16/9/2.
//

@import Foundation;
#import "DebuggerInterface.h"
#import <UIKit/UIKit.h>


@interface ShowMemory : NSObject<DebugerInterface>

+ (NSArray<NSArray<NSString *> *> *)titles;

+ (NSArray<ClickBlock> *)selectors;

- (void)stopTimer;

@end

