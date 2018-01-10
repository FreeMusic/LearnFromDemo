//
//  InvestPayCell.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXJButton.h"

@interface InvestPayCell : UITableViewCell

@property (nonatomic, strong) UILabel *payLabel; //充值金额
@property (nonatomic, strong) GXJButton *makeSureButton;//确认投资

@end
