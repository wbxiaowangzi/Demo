//
//  CheckAnalysis.h
//  Pods
//
//  Created by zhangjianfei on 16/9/2.
//

@import Foundation;

#import "DebuggerInterface.h"

@interface CheckAnalysis : NSObject<DebugerInterface>

+ (NSArray<NSArray<NSString *> *> *)titles;

+ (NSArray<ClickBlock> *)selectors;

@end

