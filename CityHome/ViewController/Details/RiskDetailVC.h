//
//  RiskDetailVC.h
//  CityJinFu
//
//  Created by mic on 16/10/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskDetailVC : UIViewController
@property (nonatomic, strong) NSString *titleStr;//项目标题
@property (nonatomic, strong) NSString *moneyStr;//金额数
@property (nonatomic, strong) NSString *recordTime;//投资日期
@property (nonatomic, strong) NSString *interest;//利率
@property (nonatomic, strong) NSString *qixian;//期限
@property (nonatomic, strong) NSString *hopeIncome;//预期收益
@property (nonatomic, strong) NSString *feedBack;//回款日
@property (nonatomic, strong) NSString *investOrder;//金额数

@end
