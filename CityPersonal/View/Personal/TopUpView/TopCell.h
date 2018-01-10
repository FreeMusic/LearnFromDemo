//
//  TopCell.h
//  CityJinFu
//
//  Created by mic on 2017/7/20.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankListModel.h"

@interface TopCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView;//银行卡图标
@property (nonatomic, strong) UILabel *bankLabel;//银行卡名称标签
@property (nonatomic, strong) UILabel *contentLabel;//银行卡内容标签
@property (nonatomic, strong) UIImageView *imgView;//银行卡是否选中图标
//index用来标志哪个银行卡被选中(充值)
- (void)cellForModel:(BankListModel *)model andIndex:(NSInteger)index andIndexPath:(NSIndexPath *)indexPath;
//更换选中银行卡的下标(充值)
- (void)cellForIndex:(NSInteger)index andAllIndex:(NSInteger)all;
//提现
- (void)cellForWithDrawalModel:(BankListModel *)model andIndex:(NSInteger)index andIndexPath:(NSIndexPath *)indexPath;

@end
