//
//  SDCatonMonitor.h
//  Demo
//
//  Created by WangBo on 2020/6/1.
//  Copyright © 2020 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDCatonMonitor : NSObject
+ (instancetype)shareInstance;
- (void)beginMonitoring;
- (void)stopMonitor;
@end

NS_ASSUME_NONNULL_END
