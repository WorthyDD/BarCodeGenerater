//
//  CustomToast.m
//  card
//
//  Created by 武淅 段 on 15/12/22.
//  Copyright © 2015年 Papaya Mobile Inc. All rights reserved.
//

#import "CustomToast.h"

@implementation CustomToast


+ (void)showHudToastWithString:(NSString *)toast
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText = toast;
    hud.mode = MBProgressHUDModeText;
    __weak typeof(hud) weak_hud = hud;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(weak_hud){
            [weak_hud hide:YES];
        }
    });
}
@end
