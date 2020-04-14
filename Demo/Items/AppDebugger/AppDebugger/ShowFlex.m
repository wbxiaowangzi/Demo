//
//  ShowFlex.m
//  Pods
//
//  Created by zhangjianfei on 16/9/2.
//

#import <FLEX/FLEXManager.h>
#import "ShowFlex.h"

@implementation ShowFlex

+ (NSArray<NSArray<NSString *> *> *)titles {
    return @[@[@"FLEX", @"FLEX"]];
}

+ (NSArray<ClickBlock> *)selectors {
    ClickBlock block = ^(void) {
        [[FLEXManager sharedManager] showExplorer];
    };
    return @[block];
}

@end
