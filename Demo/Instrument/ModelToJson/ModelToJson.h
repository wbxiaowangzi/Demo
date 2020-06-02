//
//  ModelToJson.h
//  Demo
//
//  Created by WangBo on 2020/6/2.
//  Copyright © 2020 wangbo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModelToJson : NSObject

- (NSDictionary *)dicFromObject: (NSObject *) object;
- (NSArray *)arrayWithObject:(id)object;
- (NSDictionary *)dicWithObject:(id)object;
@end

NS_ASSUME_NONNULL_END
