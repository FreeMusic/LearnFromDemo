//
//  SXYNavigationBar.m
//  CityJinFu
//
//  Created by mic on 2017/10/31.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "SXYNavigationBar.h"

@implementation SXYNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //注意导航栏及状态栏高度适配
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 64);
    for (UIView *view in self.subviews) {
        if([NSStringFromClass([view class]) containsString:@"Background"]) {
            view.frame = self.bounds;
        }
        else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
            CGRect frame = view.frame;
            frame.origin.y = 64;
            frame.size.height = self.bounds.size.height - frame.origin.y;
            view.frame = frame;
        }
    }
}

@end
