//
//  InvestTypeCell.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/23.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestTypeCell : UITableViewCell


@property (nonatomic, strong) UILabel *rangeFirstLabel; //范围前置条件label

@property (nonatomic, strong) UILabel *rangeLastLabel; //范围后置条件label

@property (nonatomic, strong) UILabel *titleLabel; //类型

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSInteger)indexPath;


@end
