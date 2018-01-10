//
//  CardTopView.m
//  CityJinFu
//
//  Created by xxlc on 17/6/28.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "CardTopView.h"

@implementation CardTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

/**
 页面布局
 */
- (void)createView{
    [self addSubview:self.backgroundImage];
    [self addSubview:self.cardImage];
    //创建手机号
    self.phoneNumberLabel = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:nil addSubView:self];
    //创建积分
    self.jifenLabel = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:nil addSubView:self];
    //创建会员等级
    self.vipLevelLabel = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:nil addSubView:self];
    [self.phoneNumberLabel sizeToFit];
    [self.jifenLabel sizeToFit];
    [self.vipLevelLabel sizeToFit];

    UIImageView *headImage = [[UIImageView alloc]init];
    headImage.image = [UIImage imageNamed:@"touxiang0.png"];
    [self addSubview:headImage];
    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        
    }];
    [self.cardImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(64);
        make.size.mas_equalTo(CGSizeMake(593*m6Scale, 241*m6Scale));
    }];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cardImage).offset(30*m6Scale);
        make.left.mas_equalTo(self.cardImage).offset(42*m6Scale);
        make.size.mas_equalTo(CGSizeMake(66*m6Scale, 66*m6Scale));
    }];
    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headImage.mas_centerY);
        make.left.mas_equalTo(headImage.mas_right).offset(5*m6Scale);
    }];
    [self.jifenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cardImage.mas_right).mas_offset(-30*m6Scale);
        make.centerY.mas_equalTo(headImage.mas_centerY);
    }];
    
    //底部四个按钮视图
    UIView *bottomView = [self CreateBottomView];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(146*m6Scale);
    }];
    
    [self.vipLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottomView.mas_top).mas_offset(-40*m6Scale);
        make.left.mas_equalTo(headImage.mas_left);
    }];
}

/**
 四个按钮视图
 */
- (UIView *)CreateBottomView{
    NSArray *titleArray = @[@"每日惊喜",@"生日享礼",@"升级礼包",@"更多权益"];
    NSArray *imageArray = @[@"jinxi0",@"shengri0",@"liwu0",@"gengduo0"];
    UIView *bottomView = [[UIView alloc]init];
    for (int i = 0; i<4; i++) {
        UIView *item = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/4*i, 0, kScreenWidth/4, 146*m6Scale)];
        item.tag = i;
        [bottomView addSubview:item];
        //点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fourButtonClick:)];
        [item addGestureRecognizer:tap];
        //按钮图片
        UIImageView *topImage = [[UIImageView alloc]init];
        topImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i]]];
        [item addSubview:topImage];
        [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(item.mas_centerX);
            make.top.mas_equalTo (item.mas_top).mas_offset(10*m6Scale);
            make.size.mas_equalTo(CGSizeMake(60*m6Scale, 60*m6Scale));
        }];
        //按钮文字
        UILabel *title = [[UILabel alloc]init];
        title.font = [UIFont systemFontOfSize:30*m6Scale];
        title.text = titleArray[i];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor whiteColor];
        [item addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(item.mas_centerX);
            make.bottom.mas_equalTo(item.mas_bottom).mas_offset(-28*m6Scale);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth/4, 20*m6Scale));
        }];
    }
    
    return bottomView;
}
- (void)fourButtonClick:(UIGestureRecognizer *)tap{
    NSLog(@"tag===%ld", [tap view].tag);
}
/**
 model set方法

 @param clubModel <#clubModel description#>
 */
- (void)setClubModel:(VipClubModel *)clubModel{
    self.phoneNumberLabel.text = @"11023456741";
    self.jifenLabel.text =@"1000积分";
    self.vipLevelLabel.text =[NSString stringWithFormat:@"会员等级：V0"];
    self.cardImage.image = [UIImage imageNamed:@"ka0.png"];
    self.backgroundImage.image = [UIImage imageNamed:@"beijing0"];
}
/**
 懒加载

 */
- (UIImageView *)cardImage{
    if (!_cardImage) {
        _cardImage = [UIImageView new];
    }
    return _cardImage;
}
- (UIImageView *)backgroundImage{
    if (!_backgroundImage) {
        _backgroundImage = [UIImageView new];
    }
    return _backgroundImage;
}
@end
