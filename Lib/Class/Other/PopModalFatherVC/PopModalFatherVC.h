//
//  PopModalFatherVC.h
//  CityJinFu
//
//  Created by mic on 2017/11/23.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

//返回按钮的颜色
typedef enum : NSUInteger {
    BackColor_white,
    BackColor_black,
} BackColor;

@interface PopModalFatherVC : UIViewController

@property (nonatomic, assign) BackColor color;

- (void)onClickLeftItem;

@end
