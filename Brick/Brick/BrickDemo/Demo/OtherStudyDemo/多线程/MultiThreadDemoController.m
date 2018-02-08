//
//  MultiThreadDemoController.m
//  Brick
//
//  Created by 靳小飞 on 2018/2/8.
//  Copyright © 2018年 jinxiaofei. All rights reserved.
//

#import "MultiThreadDemoController.h"
#import "MyTestOperation.h"

@interface MultiThreadDemoController ()
@property (nonatomic, assign) NSInteger tickets;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSObject *syncLockObj;
@end

@implementation MultiThreadDemoController

/**
 *  1 NSThread 抽象成都低，可直接操作线程，但需要自己管理线程的生命周期
 *
 *  2 NSOperation cocoa框架下的多线程，基于GCD的封装，更面向对象，实现多线程需要实现其子类 NSInvocationOperation 和 NSBlockOperation，自动管理线程生命周期，由于封装了gcd，自己用的时候就不会死锁了
 1.创建任务：先将需要执行的操作封装到一个NSOperation对象中。
 2.创建队列：创建NSOperationQueue对象。
 3.将任务加入到队列中：然后将NSOperation对象添加到NSOperationQueue中。
 之后呢，系统就会自动将NSOperationQueue中的NSOperation取出来，在新线程中执行操作。(或者不用queue，自己调用operation start)
 
 NSOperationQueue的作用
 NSOperation可以调用start方法来执行任务，但默认是同步执行；
 如果将NSOperation添加到NSOperationQueue（操作队列）中，系统会自动异步执行NSOperation中的操作。
 这里值得一提的是和GCD中的并发队列、串行队列略有不同的是：NSOperationQueue可以分为两种队列：
 1. 主队列（mainQueue）;
        凡是添加到主队列中的任务（NSOperation），都会放到主线程中执行
 2. 其他队列: 其中其他队列同时包含了串行、并发功能。下边是主队列、其他队列的基本创建方法和特点。
        添加到其他队列这种队列中的任务（NSOperation），就会自动放到子线程中执行,同时包含了：串行、并发功能
 
 *  3 Grand Center Dispatch 基于c语言 ，更底层，更高效，简单易用，自动管理线程生命周期（创建线程、调度任务、销毁线程）
        多层嵌套时容易造成死锁，经验sync尽量少用，用的时候尤其注意死锁问题
 dispatch_sync:在当前线程执行
 dispatch_async:开辟子线程执行
 dispatch_get_main_queue:主线程主队列，同步
 dispatch_get_global_queue:全局并非队列
 dispatch_queue_create:创建队列（同步&并发）
 dispatch_resume | dispatch_suspend:这些函数对已经执行的处理没有影响。挂起后，追加到Dispatch Queue中但尚未执行的处理在此之后停止执行。而恢复则使这些处理能够继续执行。
 *  4 使用NSOperation的情况：各个操作之间有依赖关系、操作需要取消暂停、并发管理、控制操作之间优先级，限制同时能执行的线程数量.让线程在某时刻停止/继续等。
      使用GCD的情况：一般的需求很简单的多线程操作，用GCD都可以了，简单高效。
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self nsthreadAuto];
    
    [self startSaleTicket];
}

#pragma mark -
#pragma mark - NSThread
- (void)nsthread
{
    //动态实例化:
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(nsoperationFunc1) object:nil];
    thread.threadPriority = 1;// 设置线程的优先级(0.0 - 1.0，1.0最高级)
    [thread start];
}
- (void)nsthreadAuto
{
    //创建线程后自动启动线程
    [NSThread detachNewThreadSelector:@selector(nsoperationFunc1) toTarget:self withObject:nil];
    
    //隐式创建并启动线程
    [self performSelectorInBackground:@selector(nsoperationFunc1) withObject:nil];
}
- (void)nsthreadMore
{
    // NSThread类
        //+ (void)sleepUntilDate:(NSDate *)date;
        //+ (void)sleepForTimeInterval:(NSTimeInterval)ti
    // - (void)exit; // 强制退出线程
    //在指定线程上执行操作
    [self performSelector:@selector(nsoperationFunc1) onThread:[NSThread new] withObject:nil waitUntilDone:YES];
    //在主线程上执行操作
    [self performSelectorOnMainThread:@selector(nsoperationFunc1) withObject:nil waitUntilDone:YES];
    //在当前线程执行操作
    [self performSelector:@selector(nsoperationFunc1) withObject:nil];
    //线程同步：(NSLock/锁)
}
- (void)startSaleTicket
{
    self.lock = [[NSLock alloc]init];
    self.syncLockObj = [NSObject new];
    self.tickets = 100;
    
    [self performSelectorInBackground:@selector(saleTicket) withObject:nil];
    [self performSelectorInBackground:@selector(saleTicket) withObject:nil];
    [self performSelectorInBackground:@selector(saleTicket) withObject:nil];
}
- (void)saleTicket
{
    [self.lock lock];
    if (self.tickets == 0) {
        NSLog(@"ticket sale over");
        [self.lock unlock];
        return;
    }
    
    [NSThread sleepForTimeInterval:0.3];
    self.tickets --;
    NSThread *t = [NSThread currentThread];
    NSLog(@"saled one ticket -- %@", t);
    [self.lock unlock];
    
    [self saleTicket];
    
    //锁
    //锁 more： http://www.cocoachina.com/ios/20160129/15170.html
    @synchronized (self.syncLockObj) {
        //lock operation
    }
    
    //lock 性能
//    OSSPinLock(不推荐了) > pthread_mutex_t > dispatch_semaphore_t > nslock > @syhchronized
//    atomic效率也不错，但只作用yusetter方法，对集合类型属性的内部值处理则无用
    
    //demo 见最后

}
#pragma mark -
#pragma mark - gcd
- (void)mainThreadMainQueueSync
{
    //一般发生死锁条件 a执行依赖b执行完毕，而b执行友依赖a执行完毕，发生相互等待，则造成死锁, 多数发生在sync或同步队列情况下
    NSLog(@"before");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"mainThreadMainQueueSync --- %@", [NSThread currentThread]);//死锁
    });
    NSLog(@"after");
}
- (void)mainThreadMainQueueAsync
{
    NSLog(@"before");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"mainThreadMainQueueAsync --- %@", [NSThread currentThread]);//不死锁
    });
    NSLog(@"after");
}
- (void)mainThreadGlobalQueueSync
{
    NSLog(@"before");
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"mainThreadMainQueueAsync --- %@", [NSThread currentThread]);//不死锁
    });
    NSLog(@"after");
}
- (void)mainThreadGlobalQueueAsync
{
    NSLog(@"before");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"mainThreadGlobalQueueAsync --- %@", [NSThread currentThread]);//不死锁
    });
    NSLog(@"after");
}
- (void)backMainThread
{
    //主线程串行队列由系统默认生成的，所以无法调用dispatch_resume()和dispatch_suspend()来控制执行继续或中断。
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"sub thread work");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"back main thread");
        });
    });
}
- (void)globalQueue
{
    //程序默认的队列级别，一般不要修改,DISPATCH_QUEUE_PRIORITY_DEFAULT == 0
    //注意priority只是指定获取cpu处理的权重，而不指定顺序
    dispatch_queue_t globalQueue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //HIGH
    dispatch_queue_t globalQueue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    //LOW
    dispatch_queue_t globalQueue3 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    //BACKGROUND
    dispatch_queue_t globalQueue4 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
}
- (void)customQueue
{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.dullgrass.serialQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"%s",dispatch_queue_get_label(serialQueue)) ;
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.dullgrass.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"%s",dispatch_queue_get_label(concurrentQueue)) ;
}
#pragma mark - custom serial queue
- (void)serialQueueMainThread
{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.dullgrass.serialQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"before");
    dispatch_sync(serialQueue, ^{
        NSLog(@"task 1 --- %@", [NSThread currentThread]);
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"task 2 --- %@", [NSThread currentThread]);
    });
    NSLog(@"after");
}
- (void)serialQueueMainThread_qiantao
{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.dullgrass.serialQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"before");
    dispatch_sync(serialQueue, ^{
        NSLog(@"task 1 --- %@", [NSThread currentThread]);
        dispatch_sync(serialQueue, ^{
            NSLog(@"task 2 --- %@", [NSThread currentThread]);//lock
        });
    });
    NSLog(@"after");
}
- (void)serialQueueMainThread_qiantao1
{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.dullgrass.serialQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"before");
    dispatch_sync(serialQueue, ^{
        NSLog(@"task 1 --- %@", [NSThread currentThread]);
        dispatch_async(serialQueue, ^{
            NSLog(@"task 2 --- %@", [NSThread currentThread]);
        });
    });
    NSLog(@"after");
}
- (void)serialQueueMainThread_qiantao2
{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.dullgrass.serialQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"before");
    dispatch_async(serialQueue, ^{
        NSLog(@"task 1 --- %@", [NSThread currentThread]);
        dispatch_sync(serialQueue, ^{
            NSLog(@"task 2 --- %@", [NSThread currentThread]);//lock
        });    });
    NSLog(@"after");
}
- (void)serialQueueMainThread_qiantao3
{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.dullgrass.serialQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"before");
    dispatch_async(serialQueue, ^{
        NSLog(@"task 1 --- %@", [NSThread currentThread]);
        dispatch_async(serialQueue, ^{
            NSLog(@"task 2 --- %@", [NSThread currentThread]);
        });    });
    NSLog(@"after");
}
#pragma mark - custom concurrent queue
- (void)concurrentQueueMainThread
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.dullgrass.serialQueue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"before");
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"task 1 --- %@", [NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"task 2 --- %@", [NSThread currentThread]);
    });
    NSLog(@"after");
}
- (void)concurrentQueueMainThread_qiantao
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.dullgrass.serialQueue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"before");
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"task 1 --- %@", [NSThread currentThread]);
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"task 2 --- %@", [NSThread currentThread]);
        });
    });
    NSLog(@"after");
}
- (void)concurrentQueueMainThread_qiantao1
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.dullgrass.serialQueue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"before");
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"task 1 --- %@", [NSThread currentThread]);
        dispatch_async(concurrentQueue, ^{
            NSLog(@"task 2 --- %@", [NSThread currentThread]);
        });
    });
    NSLog(@"after");
}
- (void)concurrentQueueMainThread_qiantao2
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.dullgrass.serialQueue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"before");
    dispatch_async(concurrentQueue, ^{
        NSLog(@"task 1 --- %@", [NSThread currentThread]);
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"task 2 --- %@", [NSThread currentThread]);
        });    });
    NSLog(@"after");
}
- (void)concurrentQueueMainThread_qiantao3
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.dullgrass.serialQueue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"before");
    dispatch_async(concurrentQueue, ^{
        NSLog(@"task 1 --- %@", [NSThread currentThread]);
        dispatch_async(concurrentQueue, ^{
            NSLog(@"task 2 --- %@", [NSThread currentThread]);
        });    });
    NSLog(@"after");
}
#pragma mark - Group queue
- (void)groupQueue
{
    dispatch_queue_t conCurrentGlobalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_group_t groupQueue = dispatch_group_create();
    NSLog(@"current task");
    dispatch_group_async(groupQueue, conCurrentGlobalQueue, ^{
        NSLog(@"并行任务1");
    });
    dispatch_group_async(groupQueue, conCurrentGlobalQueue, ^{
        NSLog(@"并行任务2");
    });
    dispatch_group_notify(groupQueue, mainQueue, ^{
        NSLog(@"groupQueue中的任务 都执行完成,回到主线程更新UI");
    });
    NSLog(@"next task");
}
- (void)groupWait
{
    /*
     dispatch_time(dispatch_time_t when, int64_t delta);
     参数注释：
     第一个参数一般是DISPATCH_TIME_NOW，表示从现在开始
     第二个参数是延时的具体时间
     延时1秒可以写成如下几种：
     NSEC_PER_SEC----每秒有多少纳秒
     dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
     USEC_PER_SEC----每秒有多少毫秒（注意是指在纳秒的基础上）
     dispatch_time(DISPATCH_TIME_NOW, 1000*USEC_PER_SEC); //SEC---毫秒
     NSEC_PER_USEC----每毫秒有多少纳秒。
     dispatch_time(DISPATCH_TIME_NOW, USEC_PER_SEC*NSEC_PER_USEC);SEC---纳秒
     */
    dispatch_group_t groupQueue = dispatch_group_create();
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_queue_t conCurrentGlobalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"current task");
    dispatch_group_async(groupQueue, conCurrentGlobalQueue, ^{
        
        long isExecuteOver = dispatch_group_wait(groupQueue, delayTime);
        if (isExecuteOver) {
            NSLog(@"wait over");
        } else {
            NSLog(@"not over");
        }
        NSLog(@"并行任务1");
    });
    dispatch_group_async(groupQueue, conCurrentGlobalQueue, ^{
        NSLog(@"并行任务2");
    });
}
- (void)dispatchAfter
{
    //dispatch_after只是延时提交block，并不是延时后立即执行，并不能做到精确控制，需要精确控制的朋友慎用哦
    dispatch_time_t delayTime3 = dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC);
    dispatch_time_t delayTime2 = dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    NSLog(@"current task");
    dispatch_after(delayTime3, mainQueue, ^{
        NSLog(@"3秒之后添加到队列");
    });
    dispatch_after(delayTime2, mainQueue, ^{
        NSLog(@"2秒之后添加到队列");
    });
    NSLog(@"next task");
    
}
- (void)dispatchApply
{
    //在给定的队列上多次执行某一任务，在主线程直接调用会阻塞主线程去执行block中的任务。
    //把一项任务提交到队列中多次执行，队列可以是串行也可以是并行，dispatch_apply不会立刻返回，在执行完block中的任务后才会返回，是同步执行的函数
    //为了不阻塞主线程，一般把dispatch_apply放在异步队列中调用，然后执行完成后通知主线程
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    NSLog(@"current task");
    dispatch_async(globalQueue, ^{
        dispatch_queue_t applyQueue = dispatch_get_global_queue(0, 0);
        //第一个参数，3--block执行的次数
        //第二个参数，applyQueue--block任务提交到的队列
        //第三个参数，block--需要重复执行的任务
        dispatch_apply(3, applyQueue, ^(size_t index) {
            NSLog(@"current index %@",@(index));
            sleep(1);
        });
        NSLog(@"dispatch_apply 执行完成");
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            NSLog(@"回到主线程更新UI");
        });
    });
    NSLog(@"next task");
}
+ (instancetype)dispatchOnce
{
    //保证在app运行期间，block中的代码只执行一次 经典使用场景－－－单例
    /*
     //在ARC下，非GCD，实现单例功能
     + (ShareManager *)sharedManager
     {
         @synchronized(self) {
             if (!sharedManager) {
                sharedManager = [[self alloc] init];
             }
         }
        return sharedManager;
     }
     */
    static MultiThreadDemoController *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)dispatchBarrierAsync
{
    //是在并行队列中，等待在dispatch_barrier_async之前加入的队列全部执行完成之后（这些任务是并发执行的）再执行dispatch_barrier_async中的任务，dispatch_barrier_async中的任务执行完成之后，再去执行在dispatch_barrier_async之后加入到队列中的任务（这些任务是并发执行的）
    dispatch_queue_t conCurrentQueue = dispatch_queue_create("com.dullgrass.conCurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"dispatch 1");
    });
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"dispatch 2");
    });
    dispatch_barrier_async(conCurrentQueue, ^{
        NSLog(@"dispatch barrier --- %@", [NSThread currentThread]);
    });
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"dispatch 3");
    });
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"dispatch 4");
    });
}
- (void)dispatchBarrierSync
{
    dispatch_queue_t conCurrentQueue = dispatch_queue_create("com.dullgrass.conCurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"dispatch 1");
    });
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"dispatch 2");
    });
    dispatch_barrier_sync(conCurrentQueue, ^{
        NSLog(@"dispatch barrier --- %@", [NSThread currentThread]);
    });
    dispatch_suspend(conCurrentQueue);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_resume(conCurrentQueue);
    });
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"dispatch 3");
    });
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"dispatch 4");
    });
}
- (void)dispatchSuspendAndResume
{
    dispatch_queue_t conCurrentQueue = dispatch_queue_create("com.dullgrass.conCurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"dispatch 1");
    });
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"dispatch 2");
    });
    dispatch_barrier_sync(conCurrentQueue, ^{
        NSLog(@"dispatch barrier --- %@", [NSThread currentThread]);
    });
    dispatch_suspend(conCurrentQueue);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_resume(conCurrentQueue);
    });
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"dispatch 3");
    });
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"dispatch 4");
    });
}
#pragma mark -
#pragma mark - nsoperation
- (void)nsoperationFunc1
{
    NSLog(@"task -- %@", [NSThread currentThread]);
}
- (void)invocationOperation
{
    NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(nsoperationFunc1) object:nil];
    [op start];
}
- (void)blockOperation
{
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        [self nsoperationFunc1];
    }];
    [op start];
}
- (void)blockOperation_addExecution
{
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        [self nsoperationFunc1];//main thread
    }];
    //添加异步操作
    [op addExecutionBlock:^{
        [self nsoperationFunc1];
    }];
    [op start];
}
- (void)customOperation
{
    MyTestOperation *op = [[MyTestOperation alloc]init];
    [op start];
}
- (void)operationQueue
{
    //1
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        [self nsoperationFunc1];
    }];
//    NSOperationQueue *queue = [NSOperationQueue mainQueue]; //在主线程
    NSOperationQueue *queue = [[NSOperationQueue alloc]init]; //在子线程
    [queue addOperation:op];
    
    //2
    [queue addOperationWithBlock:^{
        NSLog(@"task1 -- %@", [NSThread currentThread]);
    }];
}
- (void)operationAddAppley
{
//    NSOperation可以添加操作依赖：保证操作的执行顺序！
    NSInvocationOperation *inO = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(nsoperationFunc1) object:nil];
    NSBlockOperation *block1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"block1======%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *block2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"block2======%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *block3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"block3======%@", [NSThread currentThread]);
    }];
    
    /**
     四个操作都是耗时操作，并且要求按顺序执行，操作2是UI操作
     添加操作依赖的注意点
     1.一定要在将操作添加到操作队列中之前添加操作依赖
     2.不要添加循环依赖
     优点：对于不同操作队列中的操作，操作依赖依然有效
     提示:任务添加的顺序并不能够决定执行顺序，执行的顺序取决于依赖。使用Operation的目的就是为了让开发人员不再关心线程
     */
    
    // 1.一定要在将操作添加到操作队列中之前添加操作依赖
    [block2 addDependency:block1];
    [block3 addDependency:block2];
    [inO addDependency:block3];
    // 2.不要添加循环依赖 解开注释即循环依赖了
    //    [block1 addDependency:block3];
    
    [[[NSOperationQueue alloc] init] addOperation:block1];
    [[[NSOperationQueue alloc] init] addOperation:block2];
    [[[NSOperationQueue alloc] init] addOperation:block3];
    
    [[NSOperationQueue mainQueue] addOperation:inO];
}
- (void)operationMore
{
    /**
     遇到并发编程，什么时候选择 GCD， 什么时候选择NSOperation
     1.简单的开启线程/回到主线程，选择GCD：效率更高，简单
     2.需要管理操作(考虑到用户交互！)使用NSOperation
     */
    /**
     NSOperation高级操作
     一般开发的时候，会将操作队列(queue)设置成一个全局的变量（属性）
     */
    
    NSBlockOperation *block1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"---------");
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperationWithBlock:^{
        [self nsoperationFunc1];
    }];
    
    [queue addOperation:block1];
    
    /*
     暂停和恢复的适用场合：如在tableview界面，开线程下载远程的网络界面，对UI会有影响，使用户体验变差。那么这种情况，就可以设置在用户操作UI（如滚动屏幕）的时候，暂停队列（不是取消队列），停止滚动的时候，恢复队列。
     */
    
    // 1.暂停操作  开始滚动的时候
    [queue setSuspended:YES];
    
    // 2.恢复操作  滑动结束的时候
    [queue setSuspended:NO];
    
    // 3.取消所有操作  接收到内存警告
    [queue cancelAllOperations];
    
    // 3.1补充：取消单个操作调用该NSOperation的cancel方法
    [block1 cancel];
    
    // 4.设置线程最大并发数，开启合适的线程数量 实例化操作队列的时候
    [queue setMaxConcurrentOperationCount:6];
}

#pragma mark -
#pragma mark - lock
- (void)pthreadLockDemo {
    /*
     __block pthread_mutex_t mutex;
     pthread_mutex_init(&mutex, NULL);
     
     //线程1
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     pthread_mutex_lock(&mutex);
     //lock operation
     sleep(5);
     pthread_mutex_unlock(&mutex);
     });
     
     //线程2
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     sleep(1);
     pthread_mutex_lock(&mutex);
     //lock operation
     pthread_mutex_unlock(&mutex);
     });
     */
    
    /*
     __block pthread_mutex_t theLock;
     //pthread_mutex_init(&theLock, NULL);
     pthread_mutexattr_t attr;
     pthread_mutexattr_init(&attr);
     pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE); //设置支持递归
     pthread_mutex_init(&lock, &attr);
     pthread_mutexattr_destroy(&attr);
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     static void (^RecursiveMethod)(int);
     RecursiveMethod = ^(int value) {
     pthread_mutex_lock(&theLock);
     if (value > 0) {
     NSLog(@"value = %d", value);
     sleep(1);
     RecursiveMethod(value - 1);
     }
     pthread_mutex_unlock(&theLock);
     };
     RecursiveMethod(5);
     });
     */
}
- (void)gcdLockDemo {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //lock operation
        sleep(5);
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //lock operation
        dispatch_semaphore_signal(semaphore);
    });
}

@end
