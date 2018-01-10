//
//  ItemTypeView.h
//  CityJinFu
//
//  Created by mic on 2017/10/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTypeView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) void(^SelectType)(NSString *type, NSString *minDate, NSString *maxDate,NSString *minRate, NSString *maxRate, NSString *date, NSString *rate);

@end
