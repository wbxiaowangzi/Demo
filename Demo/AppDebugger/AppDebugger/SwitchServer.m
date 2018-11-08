//
//  SwitchServer.m
//  Pods
//
//  Created by zhangjianfei on 16/9/2.
//

#import "SwitchServer.h"

@implementation SwitchServer

+ (NSArray<NSString *> *)titles {
    
    return @[
             @[@"测试环境", @"测试环境"],
             @[@"预发布环境", @"预发布环境"],
             @[@"生产环境", @"生产环境"],
             ];
}

+ (NSArray<ClickBlock> *)selectors {
    ClickBlock block1 = ^(void) {
        [self showAlert:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AppEnvironment.switchToDevelop" object:nil];
        }];
    };
    ClickBlock block2 = ^(void) {
        [self showAlert:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AppEnvironment.switchToStaging" object:nil];
        }];
    };
    ClickBlock block3 = ^(void) {
        [self showAlert:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AppEnvironment.switchToProduction" object:nil];
        }];
    };
    return @[block1, block2, block3];
}

+ (void)showAlert:(void (^)())action {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示"
                                                                message:@"切换环境将会清除账号信息，并且强制退出应用。重新打开即可生效。"
                                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull a) {
        action();
    }];
    
    [vc addAction:cancel];
    [vc addAction:ok];
    
    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    UIViewController *presented = root.presentedViewController;
    if (presented) {
        [presented presentViewController:vc animated:YES completion:nil];
    } else {
        [root presentViewController:vc animated:YES completion:nil];
    }
}

@end
