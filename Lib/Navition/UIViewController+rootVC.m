//
//  UIViewController+rootVC.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "UIViewController+rootVC.h"

@implementation UIViewController (rootVC)

- (void)dismissToRootViewController {
    
    
    UIViewController *vc = self;
    
    while (vc.presentingViewController) {
        
        vc = vc.presentingViewController;
    }
    
    [vc dismissViewControllerAnimated:YES completion:nil];
}



@end
