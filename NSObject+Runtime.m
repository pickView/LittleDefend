//
//  NSObject+Runtime.m
//  CrashProtected
//
//  Created by allenChou on 2019/11/4.
//  Copyright © 2019 allenChou. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>

char * const kBZProtectorName = "kBZProtectorName";
id bzProtected(id self, SEL sel) {
    return nil;
}

@implementation NSObject (Runtime)
+ (void)swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Method originAddObserverMethod = class_getInstanceMethod(self, oriSel);
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:self];
}
+ (void)swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                             class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}

+ (Class)addMethodToSubClass:(SEL)aSelector {
    Class baymaxProtector = objc_getClass(kBZProtectorName);
    
    if (!baymaxProtector) {
        baymaxProtector = objc_allocateClassPair([NSObject class], kBZProtectorName, sizeof([NSObject class]));
        objc_registerClassPair(baymaxProtector);
    }
    
    class_addMethod(baymaxProtector, aSelector, (IMP)bzProtected, "@@:");
    return baymaxProtector;
}
@end
