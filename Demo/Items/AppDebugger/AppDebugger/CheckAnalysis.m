//
//  CheckAnalysis.m
//  Pods
//
//  Created by zhangjianfei on 16/9/2.
//

#import "CheckAnalysis.h"

@implementation CheckAnalysis

+ (NSArray<NSArray<NSString *> *> *)titles {
    return @[@[@"埋点检查", @"埋点检查"]];
}

+ (NSArray<ClickBlock> *)selectors {
    ClickBlock block = ^(void) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AnalysisLogEnable" object:nil];
    };
    return @[block];
}

@end
