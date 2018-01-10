//
//  TopUpRecordCell.h
//  CityJinFu
//
//  Created by mic on 2017/6/6.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopUpRecordCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconImgView;//图标
@property (nonatomic,strong) UILabel *titleLabel;//标题标签
@property (nonatomic,strong) UILabel *timeLabel;//时间标签
@property (nonatomic,strong) UIView *slider;//进度条

- (void)cellForIndexPath:(NSIndexPath *)indexPath WithTag:(NSString *)tag dic:(NSDictionary *)dic;

@end
