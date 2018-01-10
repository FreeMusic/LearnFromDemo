//
//  FilterView.h
//  CityJinFu
//
//  Created by mic on 2017/8/9.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterView : UIView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) void(^filterSelect)(NSInteger type);

@end
