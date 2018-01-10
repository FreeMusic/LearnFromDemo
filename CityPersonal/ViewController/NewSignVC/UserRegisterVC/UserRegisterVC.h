//
//  UserRegisterVC.h
//  CityJinFu
//
//  Created by mic on 2017/10/11.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalFatherVC.h"

@interface UserRegisterVC : ModalFatherVC

@property (nonatomic, strong) NSString *mobile;//用户的手机号

@property (nonatomic, copy) NSString *openId;

@property (nonatomic, copy) NSString *type;

@end
