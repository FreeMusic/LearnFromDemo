//
//  CodeView.h
//  CityJinFu
//
//  Created by xxlc on 17/5/23.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeView : UIView
@property (nonatomic, strong) UIButton *saveBtn;//保存到手机
@property (nonatomic, strong) UILabel *titleLab;//标题
@property (nonatomic, strong) UIImageView *codeImage;//二维码图片
@property (nonatomic, strong) UIView *backView;//背景
@property (nonatomic, strong) UIImage *img;//需要保存到本地的图片


@end
