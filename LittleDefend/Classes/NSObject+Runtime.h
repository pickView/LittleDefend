//
//  NSObject+Runtime.h
//  CrashProtected
//
//  Created by allenChou on 2019/11/4.
//  Copyright © 2019 allenChou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Runtime)
+ (void)swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel;

+ (Class)addMethodToSubClass:(SEL)aSelector;
@end

NS_ASSUME_NONNULL_END
