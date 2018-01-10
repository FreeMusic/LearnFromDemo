//
//  ItemView.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/11.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemView : UIView

@property (nonatomic, strong) UIButton *button;

- (instancetype)initWithFrame:(CGRect)frame normalImage:(NSString *)normalImage selectImage:(NSString *)selectImage title:(NSString *)title;

@end
