//
//  MyOrderCell.h
//  CityJinFu
//
//  Created by mic on 2017/6/5.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"

@interface MyOrderCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconImgview;//物品图标
@property (nonatomic,strong) UILabel *nameLabel;//物品名称
@property (nonatomic,strong) UILabel *numLabel;//物品数量
@property (nonatomic,strong) UILabel *statusLabel;//交易状态
@property (nonatomic,strong) UILabel *label;//投资金额、锁定期限、锁投时间
@property (nonatomic,strong) UILabel *accountLabel;//投资金额
@property (nonatomic,strong) UILabel *dataLabel;//锁定期限
@property (nonatomic,strong) UILabel *timeLabel;//锁投时间（下单时间）
@property (nonatomic,strong) UIButton *btn;//物流信息、立即支付按钮
@property (nonatomic, strong) UIButton *cancleBtn;//取消订单按钮

- (void)cellForModel:(MyOrderModel*)model;

@end
