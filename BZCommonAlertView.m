//
//  BZCommonAlertView.m
//  Project
//
//  Created by sins on 16/7/11.
//  Copyright © 2018 益萃网络科技（中国）有限公司. All rights reserved.
//

#import "BZCommonAlertView.h"

@interface BZCommonAlertView ()
@end

@implementation BZCommonAlertView


+ (void)showAlterWillDismiss:(NSString *)alterText {

    CGSize size = [UIApplication sharedApplication].keyWindow.bounds.size;
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:15.]};

    CGSize contentSize = [alterText boundingRectWithSize:CGSizeMake(size.width - 180, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attrs
                                            context:nil].size;

    UIView *alterView =
        [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];

    alterView.backgroundColor = [UIColor clearColor];

    alterView.alpha = 0.;

    UIView *showBGView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width - 160, 40 + contentSize.height)];

    showBGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.];

    showBGView.layer.cornerRadius = 5.;

    showBGView.layer.masksToBounds = YES;

    showBGView.center = [UIApplication sharedApplication].keyWindow.center;

    UILabel *showView = [[UILabel alloc]
        initWithFrame:CGRectMake(10, 0, showBGView.frame.size.width - 20, 40 + contentSize.height)];

    showView.textColor = [UIColor whiteColor];

    showView.font = [UIFont systemFontOfSize:15.];

    showView.text = alterText;

    showView.textAlignment = NSTextAlignmentCenter;

    showView.numberOfLines = 0.;

    [showBGView addSubview:showView];

    [alterView addSubview:showBGView];

    [[UIApplication sharedApplication].keyWindow addSubview:alterView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:alterView];

    [UIView animateWithDuration:0.5
        animations:^{

            alterView.alpha = 1.;

        }
        completion:^(BOOL finished) {

            CGFloat time = (0.5 + (alterText.length / 10) * 0.2);
            time         = time > 2 ? 2 : time;

            dispatch_after(
                dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{

                    [UIView animateWithDuration:0.5
                        animations:^{

                            alterView.alpha = 0.;

                        }
                        completion:^(BOOL finished) { [alterView removeFromSuperview]; }];
                });
        }];
}
@end

