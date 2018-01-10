//
//  MenuTableViewCell.h
//  PopMenuTableView
//
//  Created by 孔繁武 on 16/8/2.
//  Copyright © 2016年 孔繁武. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuModel.h"

@interface MenuTableViewCell : UITableViewCell

@property (nonatomic,strong) MenuModel * menuModel;
@property (nonatomic,strong) UILabel * textLab;
@property (nonatomic, strong) UIImageView *signImg;

@end