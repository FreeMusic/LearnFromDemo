//
//  BillStatisticsCell.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillStatisticsCell : UITableViewCell

@property (nonatomic, strong) UILabel *weekLabel; //周几label
@property (nonatomic, strong) UILabel *dateLabel; //日期label
@property (nonatomic, strong) UIImageView *typeImageView; //投资类型图片
@property (nonatomic, strong) UILabel *billCountLabel; //账单数值label
@property (nonatomic, strong) UILabel *projectTypeLabel; //项目类型以及期数label
@end
