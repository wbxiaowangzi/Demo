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
    
    NSString *urlStr = @"https://raw.githubusercontent.com/wbxiaowangzi/Demo/master/Demo/Items/JSPatch/ScriptFiles/jsscript.txt";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (location != nil){
            NSData *data = [NSData dataWithContentsOfFile:location.path];
            NSString *script = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [JPEngine evaluateScript:script];
        }
    }];
    [task resume];
}



@end
