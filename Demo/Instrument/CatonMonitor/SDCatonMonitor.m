//
//  SDCatonMonitor.m
//  Demo
//
//  Created by WangBo on 2020/6/1.
//  Copyright © 2020 wangbo. All rights reserved.
//

#import "SDCatonMonitor.h"
#import <CrashReporter/CrashReporter.h>

@interface SDCatonMonitor() {
    int timeoutCount;
    CFRunLoopObserverRef runLoopObserver;
@public
    dispatch_semaphore_t dispatchSemaphore;
    CFRunLoopActivity runLoopActivity;
}
@property (nonatomic, strong) NSTimer *cpuMonitorTimer;
@end

@implementation SDCatonMonitor
+ (instancetype)shareInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)beginMonitoring {
    self.cpuMonitorTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateCPUInfo) userInfo:nil repeats:YES];
    
    //监控卡顿
    if (runLoopObserver) {
        return;
    }
    
    //Dispatch Semaphore保证同步
    dispatchSemaphore = dispatch_semaphore_create(0);
    
    //创建一个观察者
    CFRunLoopObserverContext context = {0, (__bridge void*)self, NULL, NULL};
    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallBack, &context);
    
    //将观察者添加到主线程runloop的common模式下
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    
    //创建子线程监控
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //开启一个持续的loop用来监控
        while (YES) {
            long waitSuccess = dispatch_semaphore_wait(self->dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC));
            if (waitSuccess != 0) {
                if (!self->runLoopObserver) {
                    self->timeoutCount = 0;
                    self->dispatchSemaphore = 0;
                    self->runLoopActivity = 0;
                    return;
                }
                
                if (self->runLoopActivity == kCFRunLoopBeforeSources || self->runLoopActivity == kCFRunLoopAfterWaiting) {
                    self->timeoutCount += 1;

                    // 获取数据
                    NSData *lagData = [[[PLCrashReporter alloc]
                                        initWithConfiguration:[[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll]] generateLiveReport];
                    // 转换成 PLCrashReport 对象
                    PLCrashReport *lagReport = [[PLCrashReport alloc] initWithData:lagData error:NULL];
                    // 进行字符串格式化处理
                    NSString *lagReportString = [PLCrashReportTextFormatter stringValueForCrashReport:lagReport withTextFormat:PLCrashReportTextFormatiOS];
                    //将字符串上传服务器
                    NSLog(@"--------CATON WARNING-------- \n %@", lagReportString);
                }
            }
            self->timeoutCount = 0;
        }
    });
}

- (void)stopMonitor {
    [self.cpuMonitorTimer invalidate];
    if (!runLoopObserver) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(runLoopObserver);
    runLoopObserver = NULL;
}


- (void)updateCPUInfo {
    thread_act_array_t threads;
    mach_msg_type_number_t threadCount = 0;
    const task_t thisTask = mach_task_self();
    kern_return_t kr = task_threads(thisTask, &threads, &threadCount);
    if (kr != KERN_SUCCESS) {
        return;
    }
    for (int i = 0; i < threadCount; i++) {
        thread_info_data_t threadInfo;
        thread_basic_info_t threadBaseInfo;
        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
        if (thread_info((thread_act_t)threads[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount) == KERN_SUCCESS) {
            threadBaseInfo = (thread_basic_info_t)threadInfo;
            if (!(threadBaseInfo->flags & TH_FLAGS_IDLE)) {
                integer_t cpuUsage = threadBaseInfo->cpu_usage / 10;
                if (cpuUsage > 70) {
                    //cup 消耗大于 70 时打印和记录堆栈
                    NSString *reStr = [NSString stringWithFormat:@"%u", threads[i]];
                    NSLog(@"CPU useage overload thread stack：\n%@",reStr);
                }
            }
        }
    }
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    SDCatonMonitor *lagMonitor = (__bridge SDCatonMonitor*)info;
    lagMonitor->runLoopActivity = activity;
    
    dispatch_semaphore_t semaphore = lagMonitor->dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}
@end
