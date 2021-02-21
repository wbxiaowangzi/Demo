//
//  NSObject+runtime.m
//  Demo
//
//  Created by WangBo on 2021/1/7.
//  Copyright © 2021 wangbo. All rights reserved.
//

#import "NSObject+runtime.h"
#import <objc/runtime.h>

static NSString *nameKey = @"nameKey";

@implementation NSObject (runtime)

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [self init]) {
        //获取类的属性以及属性对应的类型
        NSMutableArray *keys = [NSMutableArray array];
        NSMutableArray *attributes = [NSMutableArray array];
        
        unsigned int outCount;
        //class_copyPropertyList 该方法返回的数组不包含父类声明的任何属性
        objc_property_t * properties = class_copyPropertyList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            //通过property_getName函数获得属性的名字
            NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            [keys addObject:propertyName];
            
            //通过property_getAttributes函数可以获得属性的名字和@encode编码 ---这里其实没有用到
            NSString *propertyAttrybute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            [attributes addObject:propertyAttrybute];
        }
        free(properties);
        
        for (NSString *key in keys) {
            if ([dict valueForKey:key] == nil) continue;
            [self setValue:[dict valueForKey:key] forKey:key];
        }
    }
    return self;
}

//设置关联对象set、get方法
- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, &nameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, &nameKey);
}

@end


@implementation BaseModel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        unsigned int outCount;
        //class_copyIvarList该方法返回的数组不包含父类声明的实例变量
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            [self setValue:[coder decodeObjectForKey:key] forKey:key];
        }
        free(ivars);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [coder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivars);
}

@end
