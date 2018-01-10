//
//  AutoBidSettingViewController.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoBidSettingViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, copy) NSString *isOpen;//自动投标按钮是否开启
@property (nonatomic, strong) UITextField *investTextField; //投资金额
@property (nonatomic, copy) NSString *dataStr;//期限
@property (nonatomic, copy) NSString *incomeStr;//预期收益
@property (nonatomic, copy) NSString *lockDateStr; //锁定投标期限
@property (nonatomic, strong) UILabel *moneyType;//金额类型
@property (nonatomic, copy) NSString *interestStr;//加息利率
@property (nonatomic, copy) NSString *investmoney;//投资金额
@property (nonatomic, copy) NSString *investType;//投资金额类型
@property (nonatomic, copy) NSString *autoId;//标的ID
@property (nonatomic, copy) NSString *itemStatus;//项目的状态
 

@end
