//
//  DetailView.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/24.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailView : UIView


@property (nonatomic, copy) NSArray *dataArr;


@property (nonatomic, strong) UITableView *detailTableView;

@property (nonatomic, copy) NSString *viewTag;

@end
