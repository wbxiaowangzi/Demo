//
//  YMCircleToViewController.m
//  YMTransitionDemo
//
//  Created by Max on 2019/1/21.
//  Copyright © 2019年 Max. All rights reserved.
//

#import "YMCircleToViewController.h"

@interface YMCircleToViewController ()
@property (nonatomic, strong) UIButton *presentBtn;
@end

@implementation YMCircleToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.presentBtn];
    // Do any additional setup after loading the view.
}

- (UIButton *)presentBtn {
    if (nil == _presentBtn) {
        _presentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_presentBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
        [_presentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_presentBtn addTarget:self action:@selector(event_present) forControlEvents:UIControlEventTouchUpInside];
        _presentBtn.frame = CGRectMake(100, 150, 80, 50);
    }
    return _presentBtn;
}

- (void)event_present {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
