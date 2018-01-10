//
//  EquityHeaderCell.h
//  CityJinFu
//
//  Created by mic on 2017/7/6.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquityHeaderCell : UITableViewCell

@property (nonatomic, strong) UIImageView *userImgView;//头像图标
@property (nonatomic, strong) UILabel *mobileLabel;//电话标签
@property (nonatomic, strong) UILabel *moneyLabel;//累计财气值
@property (nonatomic, strong) NSMutableArray *vipArr;//不同等级需要年化门槛 的数组

- (void)setVipArrWithDictionary:(NSDictionary *)dictionary andGrade:(NSString *)grade userName:(NSString *)userName yearAmount:(NSString *)yearAmount;

@end
