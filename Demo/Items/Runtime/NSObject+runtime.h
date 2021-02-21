//
//  NSObject+NSObject_runtime.h
//  Demo
//
//  Created by WangBo on 2021/1/7.
//  Copyright © 2021 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (NSObject_runtime)

@property(nonatomic, copy) NSString *name;

/// 字典转模型
/// @param dictionary 用来初始化的字典
- (instancetype)initWithDict:(NSDictionary *)dictionary;

@end


@interface BaseModel : NSObject<NSCoding>

@end

NS_ASSUME_NONNULL_END

