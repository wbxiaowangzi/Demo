//
//  YMSwipeToViewController.m
//  YMTransitionDemo
//
//  Created by Max on 2019/1/17.
//  Copyright © 2019年 Max. All rights reserved.
//

#import "YMSwipeToViewController.h"
#import "YMSwipeTransitionManager.h"

@interface YMSwipeToViewController ()

@end

@implementation YMSwipeToViewController

- (void)dealloc {
    NSLog(@"YMSwipeToViewController 释放了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(gesture_dismiss:)];
    gesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:gesture];
}

- (void)gesture_dismiss:(UIScreenEdgePanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan && [self.transitioningDelegate isKindOfClass:[YMSwipeTransitionManager class]]) {
        YMSwipeTransitionManager *delegate = self.transitioningDelegate;
        delegate.gestureRecognizer = sender;
        delegate.targetEdge = UIRectEdgeLeft;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)event_dismiss:(id)sender {
    YMSwipeTransitionManager *delegate = self.transitioningDelegate;
    delegate.gestureRecognizer = nil;
    delegate.targetEdge = UIRectEdgeLeft;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
