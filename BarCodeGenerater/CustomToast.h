//
//  CustomToast.h
//  card
//
//  Created by 武淅 段 on 15/12/22.
//  Copyright © 2015年 Papaya Mobile Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface CustomToast : NSObject


+ (void) showHudToastWithString : (NSString *)toast;
@end
