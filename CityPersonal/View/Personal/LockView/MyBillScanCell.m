//
//  MyBillScanCell.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "MyBillScanCell.h"

@implementation MyBillScanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        UILabel *totalScanLabel = [[UILabel alloc] init];
//        totalScanLabel.text = @"本月收支总览";
//        totalScanLabel.font = [UIFont systemFontOfSize:28*m6Scale];
//        totalScanLabel.textColor = [UIColor lightGrayColor];
//        [self.contentView addSubview:totalScanLabel];
//        [totalScanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView.mas_top).offset(30 * m6Scale);
//            make.left.equalTo(self.contentView.mas_left).offset(40 * m6Scale);
//        }];
        
        self.headImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        self.headImg.clipsToBounds = YES;
        self.headImg.layer.cornerRadius = 55 * m6Scale;
        self.headImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.headImg];
        [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(20 * m6Scale);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(110 * m6Scale, 110 * m6Scale));
        }];
        
        self.phoneNum = [UILabel new];
//        self.phoneNum.text = @"18856665646";
        self.phoneNum.textColor = [UIColor grayColor];
        self.phoneNum.font = [UIFont systemFontOfSize:28 * m6Scale];
        self.phoneNum.hidden = YES;
        [self.contentView addSubview:self.phoneNum];
        [self.phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.mas_right).offset(20 * m6Scale);
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-10 * m6Scale);
        }];
        
        self.userType = [UILabel new];
        self.userType.text = @"身份：客户";
        self.userType.textColor = [UIColor grayColor];
        self.userType.font = [UIFont systemFontOfSize:28 * m6Scale];
        self.userType.hidden = YES;
        [self.contentView addSubview:self.userType];
        [self.userType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.mas_right).offset(20 * m6Scale);
            make.top.equalTo(self.contentView.mas_centerY).offset(10 * m6Scale);
        }];
        
        
        //分割线
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX).offset(60 * m6Scale);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(1 * m6Scale, 110 * m6Scale));
        }];
        
        //支出图标
        UIImageView *topImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"支出"]];
        topImg.clipsToBounds = YES;
        topImg.backgroundColor = [UIColor clearColor];
        topImg.hidden = YES;
        [self.contentView addSubview:topImg];
        [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineView.mas_right).offset(20 * m6Scale);
            make.centerY.equalTo(self.phoneNum.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(40 * m6Scale, 35 * m6Scale));
        }];
        
        //收入图标
        UIImageView *bottomImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"收入"]];
        bottomImg.clipsToBounds = YES;
        bottomImg.backgroundColor = [UIColor clearColor];
        bottomImg.hidden = YES;
        [self.contentView addSubview:bottomImg];
        [bottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineView.mas_right).offset(23 * m6Scale);
            make.centerY.equalTo(self.userType.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(35 * m6Scale, 30 * m6Scale));
        }];
        
        UILabel *expenses = [[UILabel alloc] init];
        expenses.text = @"支出:";
        expenses.textColor = [UIColor colorWithRed:91 / 255.0 green:91 / 255.0 blue:91 / 255.0 alpha:1];
        expenses.font = [UIFont systemFontOfSize:30*m6Scale];
        [self.contentView addSubview:expenses];
        [expenses mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImg.mas_right).offset(60 * m6Scale);
            make.bottom.equalTo(self.headImg.mas_centerY);
        }];
        
        _expensesLabel = [[UILabel alloc] init];
        _expensesLabel.text = @"0.00元";
        _expensesLabel.textColor = [UIColor colorWithRed:226 / 255.0 green:107 / 255.0 blue:85 / 255.0 alpha:1];
        _expensesLabel.font = [UIFont systemFontOfSize:32*m6Scale];
        _expensesLabel.backgroundColor = [UIColor clearColor];
        _expensesLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_expensesLabel];
        [_expensesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(expenses.mas_left).offset(0 * m6Scale);
            make.top.equalTo(self.headImg.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(220 * m6Scale, 50 * m6Scale));
        }];
        
        
        UILabel *clipLabel = [[UILabel alloc] init];
        clipLabel.text = @"收入:";
        clipLabel.textColor = [UIColor colorWithRed:91 / 255.0 green:91 / 255.0 blue:91 / 255.0 alpha:1];
        clipLabel.font = [UIFont systemFontOfSize:30*m6Scale];
        [self.contentView addSubview:clipLabel];
        [clipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(expenses.mas_right).offset(230 * m6Scale);
            make.centerY.equalTo(expenses.mas_centerY);
        }];
        
        _incomeLabel = [[UILabel alloc] init];
        _incomeLabel.text = @"0.00元";
        _incomeLabel.textColor = [UIColor colorWithRed:226 / 255.0 green:107 / 255.0 blue:85 / 255.0 alpha:1];
        _incomeLabel.font = [UIFont systemFontOfSize:32*m6Scale];
        _incomeLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_incomeLabel];
        [_incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(clipLabel.mas_left).offset(0 * m6Scale);
            make.centerY.equalTo(self.expensesLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(220 * m6Scale, 50 * m6Scale));

        }];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
