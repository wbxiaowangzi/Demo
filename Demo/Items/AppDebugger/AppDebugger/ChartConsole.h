//
//  ChartConsole.h
//  Pods
//
//  Created by zhangjianfei on 16/9/2.
//

@import Foundation;
#import <UIKit/UIKit.h>


@interface ChartConsole : NSObject

+ (instancetype)sharedConsole;

- (void)updateValue:(double)value;

- (BOOL)isShowing;

- (void)hide;

@end
