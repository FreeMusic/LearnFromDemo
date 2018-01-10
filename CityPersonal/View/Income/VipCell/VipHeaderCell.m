//
//  VipHeaderCell.m
//  CityJinFu
//
//  Created by mic on 2017/6/30.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "VipHeaderCell.h"
#import "VipVC.h"
#import "VipEquityVC.h"
#import "PushView.h"

@interface VipHeaderCell ()

@property (nonatomic, strong) PushView *pushView;//弹屏

@end

@implementation VipHeaderCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = NO;
        //大背景图
        _backView = [[UIImageView alloc] init];
        [self.contentView addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (kStatusBarHeight > 20) {
                make.size.mas_equalTo(CGSizeMake(kScreenWidth, 495*m6Scale+50));
            }else{
                make.size.mas_equalTo(CGSizeMake(kScreenWidth, 495*m6Scale));
            }
            make.left.top.mas_equalTo(0);
        }];
        //会员卡按钮
        _cardBtn = [UIButton buttonWithType:0];
        _cardBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@""]];
        [_cardBtn addTarget:self action:@selector(TapClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cardBtn];
        [_cardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(593*m6Scale, 216*m6Scale));
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            if (kStatusBarHeight > 20) {
                make.top.mas_equalTo(128*m6Scale+50);
            }else{
                make.top.mas_equalTo(128*m6Scale);
            }
        }];
        //用户头像
        _userImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touxiang0"]];
        [_cardBtn addSubview:_userImg];
        [_userImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(42*m6Scale);
            make.top.mas_equalTo(30*m6Scale);
            make.size.mas_equalTo(CGSizeMake(66*m6Scale, 66*m6Scale));
        }];
        //用户手机号码
        _mobileLabel = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:@"188****5555" addSubView:_cardBtn];
        [_mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_userImg.mas_right).offset(15*m6Scale);
            make.top.mas_equalTo(50*m6Scale);
        }];
        //会员积分
        _integralLabel = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:@"100积分" addSubView:_cardBtn];
        [_integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-42*m6Scale);
            make.top.mas_equalTo(50*m6Scale);
        }];
        //会员等级
        _vipLabel = [Factory CreateLabelWithTextColor:1 andTextFont:35 andText:@"会员等级：V0" addSubView:_cardBtn];
        [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(42*m6Scale);
            make.bottom.mas_equalTo(-40*m6Scale);
        }];
        //四个按钮和标签的创建
        [self CreateFourButton];
    }
    
    return self;
}
/**
 *四个按钮和标签的创建
 */
- (void)CreateFourButton{
    NSArray *textArr = @[@"关注有礼", @"生日享礼", @"升级礼包", @"更多权益"];
    NSArray *imgArr = @[@"jinxi0", @"shengri0", @"liwu0", @"gengduo0"];
    CGFloat width = kScreenWidth/4;
    for (int i = 0; i < textArr.count; i++) {
        //图标
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgArr[i]]];
        imgView.tag = 200+i;
        [self.contentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60*m6Scale, 60*m6Scale));
            make.left.mas_equalTo((width-60*m6Scale)/2+width*i);
            make.top.mas_equalTo(_cardBtn.mas_bottom).offset(18*m6Scale);
        }];
        //标签
        UILabel *label = [Factory CreateLabelWithTextColor:0.7 andTextFont:28 andText:textArr[i] addSubView:self.contentView];
        label.tag = 300+i;
        label.textAlignment = NSTextAlignmentCenter;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(width*i);
            make.bottom.mas_equalTo(-20*m6Scale);
            make.width.mas_equalTo(width);
        }];
        //透明按钮
        _btn =  [UIButton buttonWithType:0];
        _btn.tag = 100+i;
        [_btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(width*i);
            make.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(width, 146*m6Scale));
        }];
    }
}
/**
 *跳转至会员权益
 */
- (void)TapClick{
    VipVC *strVC = (VipVC *)[self ViewController];
    VipEquityVC *tempVC = [VipEquityVC new];
    tempVC.money = strVC.userMoney;//用户的财气值
    tempVC.userName = strVC.userName;//用户名称
    tempVC.vipGrade = strVC.vipGrade;//会员等级
    
    [strVC.navigationController pushViewController:tempVC animated:YES];
}
- (void)buttonClick:(UIButton *)sender{
    //发送通知 让弹屏出现
    NSNotification *notification = [[NSNotification alloc] initWithName:@"MakePushView" object:nil userInfo:@{@"sender":[NSString stringWithFormat:@"%ld", sender.tag]}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
/**
 *生成set方法(会员首页数据)
 */
- (void)setModel:(VipClubModel *)model{
    if (model.userName == nil) {
        _mobileLabel.text = @"";//会员名称
    }else{
        _mobileLabel.text = [NSString stringWithFormat:@"%@", model.userName];//会员名称
    }
    _integralLabel.text = [NSString stringWithFormat:@"%1.f积分", [model.usable floatValue]];//会员可用积分
    _vipLabel.text = [NSString stringWithFormat:@"会员等级：V%d", [model.memberGrade intValue]];//会员等级
    //根据会员等级确定大背景图  和会员背景图
    switch (model.memberGrade.integerValue) {
        case 0:
            [self setStatusByGrade:0];
            break;
        case 1:
            [self setStatusByGrade:1];
            break;
        case 2:
            [self setStatusByGrade:1];
            break;
        case 3:
            [self setStatusByGrade:1];
            break;
        case 4:
            [self setStatusByGrade:4];
            break;
        case 5:
            [self setStatusByGrade:4];
            break;
        case 6:
            [self setStatusByGrade:6];
            break;
            
        default:
            [self setStatusByGrade:0];
            break;
    }
}
/**
 *确定大背景图  和会员背景图 用户头像
 */
- (void)setStatusByGrade:(NSInteger)grade{
    //大背景图
    if (grade == 0) {
        _backView.backgroundColor = UIColorFromRGB(0x444852);
    }else if (grade < 4){
        _backView.backgroundColor = UIColorFromRGB(0x4c4439);
    }else if (grade < 6){
        _backView.backgroundColor = UIColorFromRGB(0xeab400);
    }else{
        _backView.backgroundColor = UIColorFromRGB(0x525285);
    }
    //会员卡背景图
    [_cardBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ka%ld", grade]] forState:0];
    NSArray *imgArr;
    UIColor *color;
    if (grade == 0) {
        imgArr = @[@"jinxi0", @"shengri0", @"liwu0", @"gengduo0"];
        color = UIColorFromRGB(0x7a8195);
    }else if (grade == 1){
        imgArr = @[@"vip3_jingxi", @"shengri1", @"libao1", @"gengduo1"];
        color = UIColorFromRGB(0x9b9185);
    }else if(grade == 4){
        imgArr = @[@"jinxi4", @"shengri4", @"libao4", @"gengduo4"];
        color = UIColorFromRGB(0xffe9a1);
    }else{
        imgArr = @[@"jinxi4", @"shengri4", @"libao4", @"gengduo4"];
        color = UIColorFromRGB(0x8b8bbb);
    }
    
    for (int i = 0; i < 4; i++) {
        //图标
        UIImageView *imgView = (UIImageView *)[self.contentView viewWithTag:200+i];
        imgView.image = [UIImage imageNamed:imgArr[i]];
        //标题颜色
        UILabel *label = (UILabel *)[self.contentView viewWithTag:300+i];
        label.textColor = color;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
