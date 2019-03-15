//
//  ShowNavigator.m
//  Pods
//
//  Created by zhangjianfei on 16/9/2.
//

#import "ShowNavigator.h"
#import <UIKit/UIKit.h>
//#import <MNavigator/MNavigator-swift.h>

static NSString *preURL = nil;

@implementation ShowNavigator

+ (NSArray<NSString *> *)titles {
    return @[@[@"页面跳转", @"页面跳转"]];
}

+ (NSArray<ClickBlock> *)selectors {
    ClickBlock block = ^(void) {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@""
                                                                    message:@"输入正确的页面URL"
                                                             preferredStyle:UIAlertControllerStyleAlert];
        [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            if (preURL) {
                textField.text = preURL;
            } else {
                textField.text = @"meida://";
            }
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"跳转" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull a) {
            UITextField *tf = vc.textFields.firstObject;
            preURL = [tf text];
            //[[MNavigator default] openWithUrl:[tf text]];
        }];
        [vc addAction:cancel];
        [vc addAction:ok];
        
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:vc animated:YES completion:nil];
    };
    return @[block];
}

@end
