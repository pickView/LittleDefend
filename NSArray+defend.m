//
//  NSArray+defend.m
//  CrashProtected
//
//  Created by allenChou on 2019/11/4.
//  Copyright © 2019 allenChou. All rights reserved.
//

#import "NSArray+defend.h"
#import <objc/runtime.h>
#import "NSObject+Runtime.h"

@implementation NSArray (defend)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = objc_getClass("__NSArrayI");
        [cls swizzleInstanceMethodWithOriginSel:@selector(objectAtIndex:) swizzledSel:@selector(bz_objectAtIndex:)];
        // 语法糖调用的方法
        [cls swizzleInstanceMethodWithOriginSel:@selector(objectAtIndexedSubscript:) swizzledSel:@selector(bz_objectAtIndexedSubscript:)];
    });
}

- (id)bz_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self bz_objectAtIndex:index];
    } else {
        NSLog(@"数组越界");
        return nil;
    }
}
- (id)bz_objectAtIndexedSubscript:(NSUInteger)index {
    if (index < self.count) {
        return [self bz_objectAtIndexedSubscript:index];
    } else {
        NSLog(@"数组越界");
        return nil;
    }
}

@end
