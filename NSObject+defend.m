//
//  NSObject+BZProtect.m
//  CrashProtected
//
//  Created by allenChou on 2019/11/4.
//  Copyright © 2019 allenChou. All rights reserved.
//

#import "NSObject+defend.h"
#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@implementation NSObject (defend)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(forwardingTargetForSelector:) swizzledSel:@selector(bz_forwardingTargetForSelector:)];
    });
}
// 替换未声明未实现函数
- (id)bz_forwardingTargetForSelector:(SEL)aSelector {
    if ([self isMethodOverride:[self class] selector:@selector(forwardInvocation:)] ||
        ![NSObject isMainBundleClass:[self class]])
    {
        return [self bz_forwardingTargetForSelector:aSelector];
    }

    
    Class protector = [NSObject addMethodToSubClass:aSelector];

    if (!self.baymax) {
        self.baymax = [protector new];
    }
    return self.baymax;
}

- (BOOL)isMethodOverride:(Class)cls selector:(SEL)sel {
    IMP clsIMP = class_getMethodImplementation(cls, sel);
    IMP superClsIMP = class_getMethodImplementation([cls superclass], sel);
    
    return clsIMP != superClsIMP;
}
+ (BOOL)isMainBundleClass:(Class)cls {
    return cls && [[NSBundle bundleForClass:cls] isEqual:[NSBundle mainBundle]];
}

// MARK: Getter & Setter
- (void)setBaymax:(id)baymax {
    objc_setAssociatedObject(self, @selector(baymax), baymax, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)baymax {
    return objc_getAssociatedObject(self, _cmd);
}
@end
  
