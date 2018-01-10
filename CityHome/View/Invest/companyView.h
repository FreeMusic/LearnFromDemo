//
//  companyView.h
//  CityJinFu
//
//  Created by mic on 2017/10/20.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopUpCell.h"

@interface companyView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UILabel *centerLabel;

@property (nonatomic, assign) NSInteger selected;//支付公司默认选中的下标

@property (nonatomic, strong) TopUpCell *cell;



@end
