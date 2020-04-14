//
//  CppBridge.h
//  Demo
//
//  Created by WangBo on 2019/9/6.
//  Copyright © 2019 wangbo. All rights reserved.
//

#include <stdio.h>
#import <Foundation/Foundation.h>


@interface CppBridge : NSObject
+ (int)digitCounts:(int)a with:(int)b;
@end
