//
//  TopUpView.h
//  CityJinFu
//
//  Created by mic on 2017/7/20.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankListModel.h"

@interface TopUpView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger index;//被选中银行卡的下标

- (void)viewWithModel:(NSArray *)array andIndex:(NSInteger)index;

@end
