//
//  RegisterSecondView.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/10/10.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterSecondView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *sureButton;//下一步按钮
@property (nonatomic, strong) UIImageView *cubeImageView;//立方体
@property (nonatomic, strong) UITextField *passwordTextFiled;//密码
@property (nonatomic, strong) UIImageView *passWordImageView;//密码图片

@property (nonatomic, strong) UIButton *passwordbutton;//密码的显示和隐藏
@property (nonatomic, strong) UIButton *clearPwdTF;

@end
