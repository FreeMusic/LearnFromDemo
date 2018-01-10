//
//  InvestCountCell.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/23.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestCountCell : UITableViewCell

@property (nonatomic, strong) UILabel *investTypeLabel; //投资类型

@property (nonatomic, strong) UITextField *investTextField; //投资金额

/**
 投资金额
 */
- (void)inverstMoney:(NSString *)money andTag:(NSString *)tag andIndex:(NSInteger)index;

@end
