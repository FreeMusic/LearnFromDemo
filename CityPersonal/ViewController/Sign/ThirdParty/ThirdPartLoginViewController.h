//
//  ThirdPartLoginViewController.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/11/4.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalFatherVC.h"

@interface ThirdPartLoginViewController : ModalFatherVC

@property (nonatomic, copy) NSString *loginType; //登录类型

@property (nonatomic, copy) NSString *openId; //第三方唯一标识

@property (nonatomic, copy) NSString *presentTag;

@end
