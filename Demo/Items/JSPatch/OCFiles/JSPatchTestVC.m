//
//  JSPatchTestVC.m
//  Demo
//
//  Created by WangBo on 2019/8/22.
//  Copyright © 2019 wangbo. All rights reserved.
//

#import "JSPatchTestVC.h"
#import "JPEngine.h"
#import <Foundation/Foundation.h>

@interface JSPatchTestVC ()

@end

@implementation JSPatchTestVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAndEvaluteSript];
}

- (void)loadAndEvaluteSript{
    NSString *urlStr = @"https://github.com/wbxiaowangzi/Demo/blob/master/Demo/Items/JSPatch/ScriptFiles/jsscript.txt";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *script = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [JPEngine evaluateScript:script];
    }];
    [task resume];
}



@end
