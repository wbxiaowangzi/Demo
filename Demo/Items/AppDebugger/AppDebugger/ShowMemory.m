//
//  ShowMemory.m
//  Pods
//
//  Created by zhangjianfei on 16/9/2.
//

#import "ShowMemory.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#import "ChartConsole.h"

@implementation ShowMemory {
    NSTimer *_timer;
}

+ (NSArray<NSArray<NSString *> *> *)titles {
    return @[@[@"查看使用内存", @"关闭内存查看"]];
}

+ (NSArray<ClickBlock> *)selectors {
    ClickBlock block = ^(void) {
        [[ShowMemory shared] checkMemory];
    };
    return @[block];
}

+ (instancetype)shared {
    static id sharedMemory;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMemory = [self new];
    });
    
    return sharedMemory;
}

+ (double)usedMemory {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);

    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return taskInfo.resident_size/1024.0/1024.0;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)checkMemory {
    if ([[ChartConsole sharedConsole] isShowing]) {
        [self stopTimer];
    } else {
        [self addTimer];
    }
}

- (void)addTimer {
    [self stopTimer];
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateMemory) userInfo:nil repeats:YES];
    [_timer fire];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
    [[ChartConsole sharedConsole] hide];
}

- (void)updateMemory {
    double used = [ShowMemory usedMemory];
    [[ChartConsole sharedConsole] updateValue: used];
}

@end
