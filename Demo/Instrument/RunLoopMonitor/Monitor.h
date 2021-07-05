//
//  Monitor.h
//  Demo
//
//  Created by WangBo on 2021/3/4.
//  Copyright © 2021 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 卡顿监控工具类
 */
@interface Monitor : NSObject

/** 单例 */
+ (instancetype)shareInstance;

/** 开始卡顿监测 */
- (void)startMonitor;

@end

NS_ASSUME_NONNULL_END
