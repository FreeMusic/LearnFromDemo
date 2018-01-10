//
//  MyBillScanCell.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBillScanCell : UITableViewCell

@property (nonatomic, strong) UILabel *expensesLabel; //支出label
@property (nonatomic, strong) UILabel *incomeLabel; //收入label
@property (nonatomic, strong) UIImageView *headImg; //用户头像
@property (nonatomic, strong) UILabel *phoneNum; //账号
@property (nonatomic, strong) UILabel *userType; //身份类型



@end
