//
//  BidCardVC.h
//  CityJinFu
//
//  Created by mic on 2017/7/18.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "TemplateVC.h"

@interface BidCardVC : UIViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *bankNum;//银行卡号（带空格）
@property (nonatomic, strong) NSString *cardNum;//不带空格
@property (nonatomic, strong) NSString *bankName;//银行名称
@property (nonatomic, strong) NSString *bankCode;//银行编码
@property (nonatomic, strong) NSString *subBankCode;//支行联号

@end
