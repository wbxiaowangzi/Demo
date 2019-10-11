//
//  CppBridge.c
//  Demo
//
//  Created by WangBo on 2019/9/6.
//  Copyright © 2019 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "CppBridge.h"
#import "LintCode.h"

@implementation CppBridge:NSObject

+ (int)digitCounts:(int)a with:(int)b{
    
    return digitCounts(a, b);
}

@end


