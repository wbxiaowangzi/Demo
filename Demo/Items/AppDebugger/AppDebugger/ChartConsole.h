//
//  ChartConsole.h
//  Pods
//
//

@import Foundation;
#import <UIKit/UIKit.h>


@interface ChartConsole : NSObject

+ (instancetype)sharedConsole;

- (void)updateValue:(double)value;

- (BOOL)isShowing;

- (void)hide;

@end
