//
//  ItemTypeSecondCell.m
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ItemTypeSecondCell.h"

@interface ItemTypeSecondCell ()
@property (nonatomic, strong) UILabel *sumLabel;//项目总额
@property (nonatomic, strong) UILabel *typeLabel;//还款方式
@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UILabel *activityLabel;//活动
@property (nonatomic, strong) NSArray *LabelArray;//四个数据
@property (nonatomic, strong)  UILabel *yuanLabel;//元
@property (nonatomic, strong) UILabel *cycleLabel;//天
@property (nonatomic, assign) NSInteger fTag;//防止复用
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isbool;


@end
@implementation ItemTypeSecondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = backGroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _yuanLabel = [UILabel new];
        _cycleLabel = [UILabel new];
        _sumLabel = [UILabel new];
        _timeLabel = [UILabel new];
        _activityLabel = [[UILabel alloc]init];
        _typeLabel = [UILabel new];
        _isbool = YES;
        NSArray *array = @[@"项目总额",@"还款方式",@"标的期限",@"活动福利"];
        for (int i = 0; i < 4; i++) {
            UILabel *label = [self title:array[i]];
            label.font = [UIFont systemFontOfSize:32*m6Scale];
            label.textColor = [UIColor lightGrayColor];
            CGFloat row = i / 2;
            CGFloat clip = i % 2;
            label.frame = CGRectMake(40 * m6Scale + clip * kScreenWidth / 2, 40 * m6Scale + row * 130 * m6Scale, kScreenWidth / 2, 40 * m6Scale);
        }
        //竖线
        UIView *line1 = [[UIView alloc] init];
        line1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.contentView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(304*m6Scale);
        }];
        //横线
        UIView *line2 = [[UIView alloc] init];
        line2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.contentView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(kScreenWidth);
        }];
        //项目总金额
        _sumLabel.font = [UIFont systemFontOfSize:35*m6Scale];
        _sumLabel.text = @"0";
        [self.contentView addSubview:_sumLabel];
        [_sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_equalTo(40 * m6Scale);
            make.top.mas_equalTo(self.contentView.mas_top).mas_equalTo(90 * m6Scale);
        }];
        //元
        _yuanLabel.font = [UIFont systemFontOfSize:25*m6Scale];
        _yuanLabel.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1.0];
        [self.contentView addSubview:_yuanLabel];
        _yuanLabel.text = @"元";
        [_yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_sumLabel.mas_right).mas_equalTo(0);
            make.bottom.mas_equalTo(_sumLabel.mas_bottom).mas_equalTo(-5*m6Scale);
        }];
        
        //还款方式
        _typeLabel.font = [UIFont systemFontOfSize:35*m6Scale];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_typeLabel];
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-40*m6Scale);
            make.width.mas_equalTo(kScreenWidth/2-80*m6Scale);
            make.top.mas_equalTo(self.contentView.mas_top).mas_equalTo(90 * m6Scale);
        }];
        //标的期限
        _timeLabel.font = [UIFont systemFontOfSize:35*m6Scale];
        _timeLabel.text = @"0";
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_equalTo(40 * m6Scale);
            make.top.mas_equalTo(self.contentView.mas_top).mas_equalTo(220 * m6Scale);
        }];
        //标的期限单位
        _cycleLabel.font = [UIFont systemFontOfSize:25*m6Scale];
        _cycleLabel.text = @"天";
        _cycleLabel.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1.0];
        [self.contentView addSubview:_cycleLabel];
        [_cycleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_timeLabel.mas_right).mas_equalTo(0);
            make.bottom.mas_equalTo(_timeLabel.mas_bottom).mas_equalTo(-5*m6Scale);
        }];
        
        //活动福利
        _activityLabel.font = [UIFont systemFontOfSize:35*m6Scale];
        _activityLabel.textAlignment = NSTextAlignmentLeft;
        _activityLabel.text = @"无";
        [self.contentView addSubview:_activityLabel];
        [_activityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).mas_equalTo(-40 * m6Scale);
            make.width.mas_equalTo(kScreenWidth/2-80*m6Scale);
            make.top.mas_equalTo(self.contentView.mas_top).mas_equalTo(220 * m6Scale);
        }];
    }
    return self;
}
/**
 *  布局
 */
- (void)creatView{
    
    //四个数据
    for (int j = 0; j < 4; j ++) {
        UILabel *label = self.LabelArray[j];
        label.textColor = [UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1.0];
        CGFloat row = j / 2;
        CGFloat clip = j % 2;
        if (j == 0 || j == 2) {

        } else {
            label.frame = CGRectMake(40 * m6Scale + clip *  kScreenWidth /2, 90*m6Scale + row * 130 * m6Scale, kScreenWidth/2, 40*m6Scale);
        }
        [self.contentView addSubview:label];
    }
    
}
/**
 * 项目详情
 */
- (void)updateCellWithTimeLabelText:(NSString *)timeLableText andSumLableText:(NSString *)sumLableText andItemRepayMethod:(NSString *)itemRepayMethod andItemAddRate:(NSString *)itemAddRate andPassword:(NSString *)password andItemCycleUnit:(NSString *)itemCycleUnit andtag:(NSInteger)tag
{
    _fTag = tag;
  
    //对百分号进行处理
    NSMutableAttributedString *attActivity = [Factory attributedString:_activityLabel.text andRangL:[_activityLabel.text rangeOfString:@"%"] andlabel:_activityLabel andtag:1];
    _activityLabel.attributedText = attActivity;
    
    _LabelArray = @[_sumLabel,_typeLabel,_timeLabel,_activityLabel];
    if (tag == 123) {
        [self creatView];//创建布局
        
    }else{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self creatView];//创建布局
        });
    }
}
/**
 *  UIlabel
 */
- (UILabel *)title:(NSString *)title{
    NSLog(@"%ld",(long)_fTag);
    
    _label = [UILabel new];
    _label.text = title;
    _label.font = [UIFont systemFontOfSize:35*m6Scale];
    [self.contentView addSubview:_label];
    
    return _label;
}
- (void)cellForModel:(ItemDetailsModel *)model{
    if (model) {
        _sumLabel.text = [NSString stringWithFormat:@"%@", model.itemAccount];//项目总额
        //还款方式
        NSString *type = nil;
        switch (model.itemRepayMethod.integerValue) {
            case 1:
                //一次性还款
                type = @"一次性还款";
                break;
            case 2:
                //等额本息
                type = @"等额本息";
                break;
            case 3:
                //先息后本
                type = @"先息后本";
                break;
            case 4:
                //每日付息
                type = @"每日付息";
                break;
                
            default:
                type = @"一次性还款";
                break;
        }
        _typeLabel.text = type;//还款方式
        //标的期限(首先确定时间单位)
        NSString *dataUnit = nil;
        switch (model.itemCycleUnit.integerValue) {
            case 1:
                dataUnit = @"天";
                break;
            case 2:
                dataUnit = @"月";
                break;
            case 3:
                dataUnit = @"季";
                break;
            case 4:
                dataUnit = @"年";
                break;
                
            default:
                break;
        }
        _timeLabel.text = [NSString stringWithFormat:@"%@", model.itemCycle];//时间
        _cycleLabel.text = dataUnit;//时间单位
        //活动福利
        if (model.activityWelfare == nil) {
            _activityLabel.text = @"无";
        }else{
            _activityLabel.text = model.activityWelfare;
        }
    }
}

@end
