//
//  NewAutoCell.m
//  CityJinFu
//
//  Created by hanling on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "NewAutoCell.h"

@implementation NewAutoCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //保留金额
        self.moneyType = [[UILabel alloc] initWithFrame:CGRectMake(0, 15 * m6Scale, kScreenWidth/3, 60 * m6Scale)];
        self.moneyType.textAlignment = NSTextAlignmentCenter;
        self.moneyType.font = [UIFont systemFontOfSize:28 * m6Scale];
        self.moneyLab.backgroundColor = [UIColor clearColor];
        self.moneyType.text = @"保留金额";
        [self.contentView addSubview:self.moneyType];
        //锁定期限
        self.dueTime = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3, 15 * m6Scale, kScreenWidth/3, 60 * m6Scale)];
        self.dueTime.textAlignment = NSTextAlignmentCenter;
        self.dueTime.font = [UIFont systemFontOfSize:28 * m6Scale];
        self.dueTime.backgroundColor = [UIColor clearColor];
        self.dueTime.text = @"锁定期限";
        [self.contentView addSubview:self.dueTime];
        //锁定时间
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * 2/3, 15 * m6Scale, kScreenWidth/3, 60 * m6Scale)];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.font = [UIFont systemFontOfSize:28 * m6Scale];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.text = @"锁定时间";
        [self.contentView addSubview:self.timeLabel];

        //开关
        self.mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth * 0.8, 40 * m6Scale, 40 * m6Scale, 30 * m6Scale)];
        self.mySwitch.onTintColor = [UIColor greenColor];
        [self.contentView addSubview:self.mySwitch];
        //账户金额
        self.moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 70 * m6Scale, kScreenWidth/3, 80 * m6Scale)];
        self.moneyLab.textAlignment = NSTextAlignmentCenter;
        self.moneyLab.font = [UIFont systemFontOfSize:40 * m6Scale];
        self.moneyLab.backgroundColor = [UIColor clearColor];
        self.moneyLab.text = @"50000元";
        self.moneyLab.textColor = [UIColor colorWithRed:223 / 255.0 green:94 / 255.0 blue:69 / 255.0 alpha:1];
        [self.contentView addSubview:self.moneyLab];
        //锁定期限
        self.dueTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3, 70 * m6Scale, kScreenWidth/3, 80 * m6Scale)];
        self.dueTimeLab.textAlignment = NSTextAlignmentCenter;
        self.dueTimeLab.font = [UIFont systemFontOfSize:38 * m6Scale];
        self.dueTimeLab.backgroundColor = [UIColor clearColor];
        self.dueTimeLab.text = @"180天";
        self.dueTimeLab.textColor = [UIColor colorWithRed:223 / 255.0 green:94 / 255.0 blue:69 / 255.0 alpha:1];
        [self.contentView addSubview:self.dueTimeLab];
        //锁定剩余天数
        self.describeLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3*2, 80 * m6Scale, kScreenWidth/3, 60 * m6Scale)];
        self.describeLab.textAlignment = NSTextAlignmentCenter;
        self.describeLab.font = [UIFont systemFontOfSize:38 * m6Scale];
        self.describeLab.backgroundColor = [UIColor clearColor];
        self.describeLab.text = @"预计剩余60天";
        self.describeLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.describeLab];
        
    }
    return self;
}

/**
 *  自动投标记录
 */
- (void)newAutoListModel:(AutoListModel *)model andIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%@",model.itemAmount);
    if (model.itemAmount == nil) {
        _moneyLab.text = @"0元";
    }else if(model.itemAmount.integerValue == 99999999){
        _moneyLab.text = @"不限";//投资金额
    }else
    {
        _moneyLab.text = [NSString stringWithFormat:@"%@元",model.itemAmount];//投资金额
    }
    _dueTimeLab.text = [NSString stringWithFormat:@"%@天",model.itemLockCycle];//锁定天数
    if (model.itemAmountType.integerValue == 1) {
        _moneyType.text = @"投资金额";
    }else{
        _moneyType.text = @"保留金额";
    }  
    if (model.itemLockStatus.intValue == 0) {
        NSLog(@"999+++++%@",model.ID);
        NSUserDefaults *user = HCJFNSUser;
        [user setValue:model.ID.stringValue forKey:@"zyyLockId"];
        [user synchronize];
        if (model.itemStatus.intValue == 0) {
            self.signImg.hidden = YES;
            self.mySwitch.hidden = NO;
            self.mySwitch.on = NO;
            self.dueTimeLab.textColor = [UIColor lightGrayColor];
            self.dueTimeLab.text = @"无";
            self.describeLab.hidden = YES;
            self.timeLabel.hidden = YES;
            
        }else{
            self.signImg.hidden = YES;
            self.mySwitch.hidden = NO;
            self.mySwitch.on = YES;
            self.dueTimeLab.textColor = [UIColor lightGrayColor];
            self.dueTimeLab.text = @"无";
            self.describeLab.hidden = YES;
            self.timeLabel.hidden = YES;
        }
    }else{
        NSLog(@"999+++++%@",model.ID);
        self.signImg.hidden = YES;
        self.mySwitch.hidden = NO;
        self.mySwitch.on = YES;
        self.dueTimeLab.textColor = [UIColor lightGrayColor];
        if (model.itemLockCycle.intValue / 360 == 1) {
            self.dueTimeLab.text = [NSString stringWithFormat:@"%d年",model.itemLockCycle.intValue / 360];
        }else{
            self.dueTimeLab.text = [NSString stringWithFormat:@"%d个月",model.itemLockCycle.intValue / 30];
        }
        self.describeLab.hidden = NO;
        self.mySwitch.hidden = YES;
//        //图片
//        self.signImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.85, 50 * m6Scale, 30 * m6Scale, 45 * m6Scale)];
//        self.signImg.image = [UIImage imageNamed:@"investLock"];
        self.describeLab.text = [Factory stdTimeyyyyMMddFromNumer:model.addtime andtag:53];//投资时间;
        [self.contentView addSubview:self.signImg];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
