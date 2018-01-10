//
//  NoticeListsCell.h
//  CityJinFu
//
//  Created by mic on 2017/6/27.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeTrendsModel.h"

@interface NoticeListsCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *timeLabel;//时间标签
@property (nonatomic, strong) UIImageView *backImgView;//大图片
@property (nonatomic, strong) UILabel *contentLabel;//内容展示
@property (nonatomic, strong) NoticeTrendsModel *model;

@end
