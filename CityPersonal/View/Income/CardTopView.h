//
//  CardTopView.h
//  CityJinFu
//
//  Created by xxlc on 17/6/28.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipClubModel.h"
@interface CardTopView : UIView
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *cardImage;
@property (nonatomic, strong) UILabel *phoneNumberLabel;
@property (nonatomic, strong) UILabel *vipLevelLabel;
@property (nonatomic, strong) UILabel *jifenLabel;
@property (nonatomic, strong) VipClubModel *clubModel;

@end
