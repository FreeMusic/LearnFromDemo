//
//  InvestEndCell.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/23.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestEndCell : UITableViewCell


@property (nonatomic, strong) UILabel *titleLabel; //标题label

@property (nonatomic, strong) UILabel *messageLabel; //信息label

@property (nonatomic, strong) UIButton *clickButton;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSInteger)indexPath;


@end
