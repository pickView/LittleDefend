//
//  NSMutableDictionary+defend.m
//  CrashProtected
//
//  Created by allenChou on 2019/11/5.
//  Copyright © 2019 allenChou. All rights reserved.
//

#import "NSMutableDictionary+defend.h"
#import <objc/runtime.h>
#import "NSObject+Runtime.h"
#import "BZCommonAlertView.h"

@implementation NSMutableDictionary (defend)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = objc_getClass("__NSDictionaryM");
        
        [cls swizzleInstanceMethodWithOriginSel:@selector(setObject:forKey:) swizzledSel:@selector(bz_setObject:forKey:)];
        // 语法糖调用的方法
        [cls swizzleInstanceMethodWithOriginSel:@selector(setObject:forKeyedSubscript:) swizzledSel:@selector(bz_setObject:forKeyedSubscript:)];
        
        [cls swizzleInstanceMethodWithOriginSel:@selector(removeObjectForKey:) swizzledSel:@selector(bz_removeObjectForKey:)];


    });
}
- (void)bz_setObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if (anObject == nil) {
        [BZCommonAlertView showAlterWillDismiss:@"object is nil"];
        return;
    }else if (aKey == nil){
        [BZCommonAlertView showAlterWillDismiss:@"key is nil"];
        return;
    }
    else {
        
        [self bz_setObject:anObject forKey:aKey];
    }
}
- (void)bz_setObject:(id)anObject forKeyedSubscript:(id<NSCopying>)aKey{
    if (anObject == nil) {
        [BZCommonAlertView showAlterWillDismiss:@"object is nil"];
        return;
    }else if (aKey == nil){
        [BZCommonAlertView showAlterWillDismiss:@"key is nil"];
        return;
    }
    else {
        
        [self bz_setObject:anObject forKeyedSubscript:aKey];
    }
}
- (void)bz_removeObjectForKey:(id)aKey {
    if (aKey == nil) {
        [BZCommonAlertView showAlterWillDismiss:@"key is nil"];
        return;
    }else {
        [self bz_removeObjectForKey:aKey];
    }
}
@end
