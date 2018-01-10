//
//  ScanIDCell.h
//  CityJinFu
//
//  Created by mic on 2017/7/27.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanIDCell : UITableViewCell

@property (nonatomic, strong) UIImageView *idCardImg;//身份证照片
@property (nonatomic, strong) UIImageView *iconImgView;//扫描身份证图标
@property (nonatomic, strong) UILabel *scanLabel;//扫描身份证标签
@property (nonatomic, strong) UIView *backView;

@end
