
//
//  TopUpRecordCell.m
//  CityJinFu
//
//  Created by mic on 2017/6/6.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "TopUpRecordCell.h"

@implementation TopUpRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = NO;
        //图标
        _iconImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(62*m6Scale, 62*m6Scale));
            make.left.mas_equalTo(50*m6Scale);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        //标题
        _titleLabel = [Factory CreateLabelWithTextColor:0.2 andTextFont:30 andText:@"" addSubView:self.contentView];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_iconImgView.mas_right).offset(20*m6Scale);
            make.top.mas_equalTo(_iconImgView.mas_top);
        }];
        //时间
        _timeLabel = [Factory CreateLabelWithTextColor:0.6 andTextFont:24 andText:@"2017.2.26 13:00:00" addSubView:self.contentView];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(8*m6Scale);
        }];
        //进度条
        _slider = [[UIView alloc] init];
        [self.contentView addSubview:_slider];
    }
    return self;
}

- (void)cellForIndexPath:(NSIndexPath *)indexPath WithTag:(NSString *)tag dic:(NSDictionary *)dic{
    NSLog(@"%@",dic);
    NSInteger status = [NSString stringWithFormat:@"%@", dic[@"status"]].integerValue;//状态 1 成功 0失败 其他为审核中
    switch (indexPath.row) {
        case 0:{
            _slider.backgroundColor = ButtonColor;
            if (tag.integerValue) {
                _titleLabel.text = @"提现申请";
            }else{
                _titleLabel.text = @"充值申请";
            }
            _iconImgView.image = [UIImage imageNamed:@"jingdu@2x_03"];
            [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_iconImgView.mas_bottom);
                make.bottom.mas_equalTo(0);
                make.width.mas_equalTo(2);
                make.left.mas_equalTo(81*m6Scale-1);
            }];
            if ([dic[@"addtime"] isEqual:[NSNull null]]) {
                
            }else{
                NSNumber *time = @([dic[@"addtime"] integerValue]);//将字符串转化为NSNumber类型
                _timeLabel.text = [Factory stdTimeyyyyMMddFromNumer:time andtag:100];//时间
            }
            
            break;
        }
        case 1:{
            [self.contentView sendSubviewToBack:_slider];
            [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.width.mas_equalTo(2);
                make.left.mas_equalTo(81*m6Scale-1);
            }];
            //提现
            if (tag.integerValue) {
                if (status == 1 || status == 0) {
                    [self statusWithTitle:@"提现审核完成" Image:@"jingdu@2x_06" sliderColor:1 time:dic[@"auditTime"]];
                }else{
                    [self statusWithTitle:@"提现审核中" Image:@"jingdu2@2x_06" sliderColor:0 time:dic[@"auditTime"]];
                }
            }else{
                //充值
                if (status == 1 || status == 0) {
                    [self statusWithTitle:@"充值审核完成" Image:@"jingdu@2x_06" sliderColor:1 time:dic[@"auditTime"]];
                }else{
                    [self statusWithTitle:@"充值审核中" Image:@"jingdu2@2x_06" sliderColor:0 time:dic[@"auditTime"]];
                }
            }
        
            break;
        }
        case 2:{
            if (tag.integerValue) {
                //提现
                if (status == 0) {
                    [self statusWithTitle:@"提现失败" Image:@"jingdu3@2x_03" sliderColor:10 time:dic[@"auditTime"]];
                }else if (status == 1){
                    [self statusWithTitle:@"提现成功" Image:@"jingdu@2x_08" sliderColor:1 time:dic[@"auditTime"]];
                }else{
                    [self statusWithTitle:@"处理中" Image:@"jingdu2@2x_08" sliderColor:0 time:dic[@"auditTime"]];
                }
            }else{
                //充值
                if (status == 0) {
                    [self statusWithTitle:@"充值失败" Image:@"jingdu3@2x_03" sliderColor:10 time:dic[@"auditTime"]];
                }else if (status == 1){
                    [self statusWithTitle:@"充值成功" Image:@"jingdu@2x_08" sliderColor:1 time:dic[@"auditTime"]];
                }else{
                    [self statusWithTitle:@"处理中" Image:@"jingdu2@2x_08" sliderColor:0 time:dic[@"auditTime"]];
                }
            }
            [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(_iconImgView.mas_top);
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(2);
                make.left.mas_equalTo(81*m6Scale-1);
            }];
            break;
        }
        default:
            break;
    }
}

- (void)statusWithTitle:(NSString *)title Image:(NSString *)img sliderColor:(NSInteger)color time:(NSString *)timer{
    _titleLabel.text = title;//标题
    _iconImgView.image = [UIImage imageNamed:img];//图标
    if (color == 1) {
        _slider.backgroundColor = ButtonColor;//进度条颜色
    }else if(color == 0){
        _slider.backgroundColor = Colorful(174, 177, 177);
    }else{
        _slider.backgroundColor = Colorful(21, 161, 147);
    }
    NSNumber *time = @([timer integerValue]);//将字符串转化为NSNumber类型
    _timeLabel.text = [Factory stdTimeyyyyMMddFromNumer:time andtag:100];//时间
}
@end
