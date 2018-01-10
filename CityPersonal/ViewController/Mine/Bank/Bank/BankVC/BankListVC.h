//
//  BankListVC.h
//  CityJinFu
//
//  Created by mic on 2017/7/21.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "TemplateVC.h"

@interface BankListVC : UIViewController

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger index;//被选中的银行卡下标
@property (nonatomic, strong) NSString *userName;//用户名称
@property (nonatomic, assign) NSInteger bankIndex;//返回该页面

@end
