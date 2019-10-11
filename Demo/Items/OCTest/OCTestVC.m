//
//  OCTestVC.m
//  Demo
//
//  Created by WangBo on 2019/8/29.
//  Copyright © 2019 wangbo. All rights reserved.
//

#import "OCTestVC.h"
#import "CppBridge.h"

@interface OCTestVC ()

@end

@implementation OCTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self creatABarrierQueue];
    [self test3];
    int aaaaaa = [CppBridge digitCounts:1 with:1];
    NSLog(@"%d",aaaaaa);

}
///以下代码的效果跟在主队列中调用 dispatch_sync 执行任务一样，会卡死主线程
- (void)creatABarrierQueue{
    dispatch_queue_t serialQueue = dispatch_queue_create("serial_queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        NSLog(@"deal task 1,thread = %@",[NSThread currentThread]);
        dispatch_sync(serialQueue, ^{
            NSLog(@"deal task 2");
        });
        NSLog(@"deal task 3");
        NSLog(@"current RunLoop : %@",[NSRunLoop currentRunLoop]);
    });
    
}


-(void)test2{
    NSLog(@"执行任务0 current thread : %@",[NSThread currentThread]);

    dispatch_queue_t queue1 = dispatch_queue_create("serial1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("serial2", DISPATCH_QUEUE_SERIAL);

    dispatch_async(queue1, ^{
        NSLog(@"执行任务1 current thread : %@",[NSThread currentThread]);
        
        dispatch_sync(queue2, ^{
            NSLog(@"执行任务2 current thread : %@",[NSThread currentThread]);
        });
        NSLog(@"执行任务3 current thread : %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue2, ^{
        NSLog(@"执行任务4 current thread : %@",[NSThread currentThread]);
        dispatch_async(queue2, ^{
            NSLog(@"执行任务5 current thread : %@",[NSThread currentThread]);
        });
        dispatch_async(queue2, ^{
            NSLog(@"执行任务6 current thread : %@",[NSThread currentThread]);
        });
    });

}

- (void)test3{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        //[[NSRunLoop currentRunLoop] addPort:[[NSPort alloc]init] forMode:NSDefaultRunLoopMode];
        NSLog(@"1");
        [self performSelector:@selector(test4) withObject:nil afterDelay:.0];
        NSLog(@"3");
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc]init] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];

    });
    
//    [[NSThread currentThread] start];
    
}

- (void)test4{
    NSLog(@"2  current thread :%@",[NSThread currentThread]);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    dispatch_queue_t queue = dispatch_queue_create("lalal", DISPATCH_CURRENT_QUEUE_LABEL);
    dispatch_async(queue, ^{
        [self performSelector:@selector(test4) withObject:nil afterDelay:.0];
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc]init] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
    
}


-(void)testWith:(int)age name:(NSString *)name{
    NSString * test = @"[super viewDidLoad];7890()()-()()()()()()())))()(90909090090900990uiopuiop[]uiop[][] tihsi 9()_-0()_=-=-=-=-=-=-0-0-0-0-=0--0-=00-=this a a lalala [][][][][][][][][][][][][][][][]90909090090*(09090009*9090900*9900090090*09090909009090090909098090900008*7&&&&&&&&&&()()()())-";
}
- (void)testFunction:(NSString *)name age:(int)age{
    NSLog(@"%s",__func__);
    [self isKindOfClass:[NSObject class]];
    [self isMemberOfClass:[NSObject class]];
}

- (void)anotherFunction:(NSString *)name age:(int)age{
    NSLog(@"tihs another func %c",_cmd);
}
- (void)function:(NSString*)name age:(int)age{
    NSLog(@"this is a log");//ca cb cc cd ce cf ... cz 
}
@end

