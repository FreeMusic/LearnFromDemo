//
//  InstantFillCell.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstantFillCell : UITableViewCell

@property (nonatomic, strong) UILabel *accountLabel;//投资金额标签
@property (nonatomic, strong) UIButton *btn;//加减按钮
@property (nonatomic, strong) UIButton *autoBtn;//自动填入按钮
@property (nonatomic, strong) UITextField *textFiled;//输入框

@end
