//
//  GYZSheetCell.m
//  GYZCustomActionSheet
//
//  Created by GYZ on 16/6/20.
//  Copyright © 2016年 GYZ. All rights reserved.
//

#import "GYZSheetCell.h"
#import "GYZCommon.h"
#import "Masonry.h"

@implementation GYZSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.myLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-25, 0, kScreenWidth/2, 135 * m6Scale)];//字体的位置
        _myLabel.backgroundColor = [UIColor whiteColor];
        _myLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
       
        _myLabel.font = [UIFont systemFontOfSize:34*m6Scale];
        [self.contentView addSubview:self.myLabel];
        
        self.myImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.myImageView];
        [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.myLabel.mas_left).mas_equalTo(-5);
            make.size.mas_equalTo(CGSizeMake(31*m6Scale, 35*m6Scale));
            make.centerY.mas_equalTo(self.myLabel.mas_centerY);
        }];
        
        self.tableDivLine = [[UIView alloc]initWithFrame:CGRectMake(0, MaxY(self.myLabel)-1, kScreenWidth, kLineHeight)];
        self.tableDivLine.backgroundColor = kGrayLineColor;
        [self.contentView addSubview: self.tableDivLine];
    }
    return self;
}

@end
