//
//  UIView+ViewController.m
//  哔哩哔哩动画
//
//  Created by clip on 16/5/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)ViewController {
    
    
    //    if ([self.nextResponder isKindOfClass:[UIViewController class]]) {
    //        return (UIViewController *)self.nextResponder;
    //    }

    UIResponder *next = self.nextResponder;
    while (YES) {
        
        if ([next.nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next.nextResponder;
        } else if (next.nextResponder == nil) {
            return nil;
        }
        
        next = next.nextResponder;
    }
}


@end
