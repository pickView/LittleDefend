//
//  NSMutableArray+defend.m
//  CrashProtected
//
//  Created by allenChou on 2019/11/4.
//  Copyright © 2019 allenChou. All rights reserved.
//

#import "NSMutableArray+defend.h"
#import <objc/runtime.h>
#import "NSObject+Runtime.h"

@implementation NSMutableArray (defend)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = objc_getClass("__NSArrayM");
        [cls swizzleInstanceMethodWithOriginSel:@selector(addObject:) swizzledSel:@selector(bz_addObject:)];
        [cls swizzleInstanceMethodWithOriginSel:@selector(objectAtIndex:) swizzledSel:@selector(bz_objectAtIndex:)];
        // 语法糖调用的方法
        [cls swizzleInstanceMethodWithOriginSel:@selector(objectAtIndexedSubscript:) swizzledSel:@selector(bz_objectAtIndexedSubscript:)];
        
        [cls swizzleInstanceMethodWithOriginSel:@selector(insertObject:atIndex:) swizzledSel:@selector(bz_insertObject:atIndex:)];
        
        [cls swizzleInstanceMethodWithOriginSel:@selector(removeObjectAtIndex:) swizzledSel:@selector(bz_removeObjectAtIndex:)];
        
        [cls swizzleInstanceMethodWithOriginSel:@selector(replaceObjectAtIndex:withObject:) swizzledSel:@selector(bz_replaceObjectAtIndex:withObject:)];

        [cls swizzleInstanceMethodWithOriginSel:@selector(removeObjectsInArray:) swizzledSel:@selector(bz_removeObjectsInArray:)];
        [cls swizzleInstanceMethodWithOriginSel:@selector(removeObject:) swizzledSel:@selector(bz_removeObject:)];


    });
}

- (void)bz_addObject:(id)anObject {
    if (anObject) {
        [self bz_addObject:anObject];
    } else {
        NSLog(@"添加对象为空");
    }
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

- (void)bz_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (index <= self.count && anObject != nil && [anObject isKindOfClass:[NSNull class]] == NO) {
        [self bz_insertObject:anObject atIndex:index];
    } else {
        NSLog(@"%@", [NSThread callStackSymbols]);
        
    }
}
- (void)bz_removeObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        [self bz_removeObjectAtIndex:index];
    } else {
        NSLog(@"%@", [NSThread callStackSymbols]);
        
    }
}
- (void)bz_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (index < self.count && anObject != nil && [anObject isKindOfClass:[NSNull class]] == NO) {
        [self bz_replaceObjectAtIndex:index withObject:anObject];
    } else {
        NSLog(@"%@", [NSThread callStackSymbols]);
    }
}

- (void)bz_removeObjectsInArray:(NSArray *)array{
    if (array.count == 0) {
        NSLog(@"%@", [NSThread callStackSymbols]);
    }else{
        [self bz_removeObjectsInArray:array];
    }
}
- (void)bz_removeObject:(id)anObject{
    if (anObject != nil && [anObject isKindOfClass:[NSNull class]] == NO) {
        [self bz_removeObject:anObject];
    } else {
        NSLog(@"%@", [NSThread callStackSymbols]);
    }
}
@end
