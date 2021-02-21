//
//  YMFadeToViewController.m
//  YMTransitionDemo
//
//  Created by Max on 2019/1/24.
//  Copyright © 2019年 Max. All rights reserved.
//

#import "YMFadeToViewController.h"

@interface YMFadeToViewController ()
@property (nonatomic, strong) UIButton *dismissBtn;
@end

@implementation YMFadeToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.dismissBtn];
}

- (void)event_dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)dismissBtn {
    if (nil == _dismissBtn) {
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_dismissBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
        [_dismissBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(event_dismiss) forControlEvents:UIControlEventTouchUpInside];
        _dismissBtn.frame = CGRectMake(100, 150, 80, 50);
    }
    return _dismissBtn;
}

@end
