//
//  NSString+defend.m
//  CrashProtected
//
//  Created by allenChou on 2019/11/5.
//  Copyright © 2019 allenChou. All rights reserved.
//

#import "NSString+defend.h"
#import <objc/runtime.h>
#import "NSObject+Runtime.h"
#import "BZCommonAlertView.h"

@implementation NSString (defend)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = objc_getClass("__NSCFConstantString");
        [cls swizzleInstanceMethodWithOriginSel:@selector(substringFromIndex:) swizzledSel:@selector(bz_substringFromIndex:)];
    });
}
- (NSString *)bz_substringFromIndex:(NSUInteger)from {
    if (self.length<from) {
        [BZCommonAlertView showAlterWillDismiss:@"string Range 超出范围"];
        return nil;
    }else{
        return [self bz_substringFromIndex:from];
    }
}
@end
