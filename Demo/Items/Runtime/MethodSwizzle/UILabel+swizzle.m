//
//  UILabel+swizzle.m
//  LiMingTang
//
//  Created by WangBo on 2019/7/15.
//  Copyright © 2019 影子. All rights reserved.
//

#import "UILabel+swizzle.h"
#import <objc/runtime.h>

@implementation UILabel (swizzle)

+ (void) initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj = [[self alloc]init];
        [obj swizzleMethod];
    });
}

- (void) swizzleMethod{
    Method setText = class_getInstanceMethod([UILabel class], @selector(setText:));
    Method customSetText = class_getInstanceMethod([UILabel class], @selector(setTextHooked:));
    method_exchangeImplementations(customSetText, setText);
    
    Method setAttributedText = class_getInstanceMethod([UILabel class], @selector(setAttributedText:));
    Method customSetAttributedText = class_getInstanceMethod([UILabel class], @selector(setAttributedHookedText:));
    method_exchangeImplementations(customSetAttributedText,setAttributedText);
}

- (void) setTextHooked:(NSString *)string{
    if (string.length > 2){
        NSMutableString *str = [[NSMutableString alloc] initWithString:string];
        NSString *newStr = [str stringByReplacingOccurrencesOfString:@"太阳穴" withString:@"夫妻宫"];
        [self performSelector:@selector(setTextHooked:) withObject:newStr];
        return;
    }
    [self performSelector:@selector(setTextHooked:) withObject:string];
}

- (void) setAttributedHookedText:(NSAttributedString *)attributedText{
    if (attributedText.string.length > 2){
        NSMutableString *str = [[NSMutableString alloc] initWithString:attributedText.string];
        NSString *newStr = [str stringByReplacingOccurrencesOfString:@"太阳穴" withString:@"夫妻宫"];
        NSRange range = NSMakeRange(0, newStr.length-1);
        NSDictionary<NSAttributedStringKey, id>  *dic = [attributedText attributesAtIndex:0 effectiveRange:&range];
        NSAttributedString *tempStr = [[NSAttributedString alloc] initWithString:newStr attributes:dic];
        [self performSelector:@selector(setAttributedHookedText:) withObject:tempStr];
        return;
    }
    [self performSelector:@selector(setAttributedHookedText:) withObject:attributedText];
}

@end
