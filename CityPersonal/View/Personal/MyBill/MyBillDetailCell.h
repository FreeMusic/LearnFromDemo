//
//  MyBillDetailCell.h
//  CityJinFu
//
//  Created by xxlc on 17/5/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBillDetailCell : UITableViewCell
@property (nonatomic, strong) UILabel *titlelab;//标名
@property (nonatomic, strong) UILabel *moneylab;//本金
@property (nonatomic, strong) UILabel *incomlab;//利息
@property (nonatomic, strong) UIImageView *backImgView;//暂无数据提示切图

- (void)cellForModel:(id)model withtype:(NSInteger)type;

@end
