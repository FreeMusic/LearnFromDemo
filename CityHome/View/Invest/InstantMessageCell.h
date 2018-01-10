//
//  InstantMessageCell.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailsModel.h"

@interface InstantMessageCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;//标题标签
@property (nonatomic,strong) UILabel *rateLabel;//利率标签
@property (nonatomic,strong) UILabel *styleLabel;//起投金额、还款方式标签
@property (nonatomic,strong) UILabel *dataLable;//项目期限
@property (nonatomic,strong) UILabel *accountLabel;//可投金额
@property (nonatomic,strong) UIView *progress;//进度条
@property (nonatomic,strong) UILabel *progressLabel;//进度标签

- (void)cellForModel:(ItemDetailsModel *)model;

//@property (nonatomic, strong) UIImageView *typeImageView; //项目类型图标
//@property (nonatomic, strong) UILabel *annualizedLabel; //预期年化收益率
//@property (nonatomic, strong) UILabel *projectDateLabel; //项目期限
//@property (nonatomic, strong) UILabel *useSumLabel; //可投金额
////项目的信息
//- (void)messageValue:(NSString *)useSumLabel andpercentLabel:(NSString *)annualized anditemTime:(NSString *)itemTime anditemCycleUnit:(NSString *)itemCycleUnit;

@end
