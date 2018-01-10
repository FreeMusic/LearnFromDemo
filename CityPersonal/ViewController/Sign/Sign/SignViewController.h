//
//  SignViewController.h
//  CityJinFu
//
//  Created by xxlc on 16/8/16.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SignViewController : UIViewController

@property (nonatomic, copy) NSString *presentTag;

@property (nonatomic, strong) MBProgressHUD *hud;

/**
 *  提示框
 */
- (void)dialogWithTitle:(NSString *)dialogWithTitle message:(NSString *)message nsTag:(NSInteger)tag;

@end
