//
//  MyAddressView.m
//  CityJinFu
//
//  Created by mic on 2017/6/4.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyAddressView.h"
#import "MyAddressVC.h"
#import "OrderDetailsVC.h"
#import "TopUpVC.h"

@implementation MyAddressView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutAllSubviews];
        //contentView
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        //[self failure];
        [self suceess];
    }
    return self;
}
/**
 *投资失败
 */
- (void)failure{
    //标题标签
    _titleLable = [Factory CreateLabelWithTextColor:0.1 andTextFont:28 andText:@"余额不足" addSubView:_contentView];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10*m6Scale);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    //确认标签
    _sureLabel = [Factory CreateLabelWithTextColor:0.4 andTextFont:26 andText:@"账户余额XX,还差XX元起投,点击前往" addSubView:_contentView];
    [_sureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLable.mas_bottom).offset(10*m6Scale);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    //前往充值
    _btn = [Factory addCenterButtonWithTitle:@"前往充值" andTitleColor:1 andButtonbackGroundColorRed:234 Green:89 Blue:38 andCornerRadius:35 addSubView:_contentView];
    [_btn addTarget:self action:@selector(ReChange) forControlEvents:UIControlEventTouchUpInside];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*m6Scale);
        make.right.mas_equalTo(-20*m6Scale);
        make.top.mas_equalTo(_sureLabel.mas_bottom).offset(20*m6Scale);
        make.height.mas_equalTo(70*m6Scale);
    }];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(70*m6Scale);
        make.bottom.mas_equalTo(_btn.mas_bottom).offset(20*m6Scale);
    }];
}
/**
 *前往充值
 */
- (void)ReChange{
    NSLog(@"前往充值");
    _contentView.hidden = YES;
    _bgView.hidden = YES;
    MyAddressVC *strVC = (MyAddressVC *)[self ViewController];
    TopUpVC *tempVC = [[TopUpVC alloc] init];
    [strVC.navigationController pushViewController:tempVC animated:YES];
}
/**
 *投资成功
 */
- (void)suceess{
    //标题标签
    _titleLable = [Factory CreateLabelWithTextColor:0.1 andTextFont:28 andText:@"投资成功" addSubView:_contentView];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10*m6Scale);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    //确认标签
    _sureLabel = [Factory CreateLabelWithTextColor:0.4 andTextFont:26 andText:@"请确认" addSubView:_contentView];
    [_sureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLable.mas_bottom).offset(10*m6Scale);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    //地址标签
    _addressLabel = [Factory CreateLabelWithTextColor:0.4 andTextFont:26 andText:@"地址：浙江省杭州市下城区财富中心建国北路2357号" addSubView:_contentView];
    _addressLabel.numberOfLines = 0;
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70*m6Scale);
        make.top.mas_equalTo(_sureLabel.mas_bottom).offset(10*m6Scale);
        make.width.mas_equalTo(kScreenWidth - 280*m6Scale);
    }];
    //姓名标签
    _nameLabel = [Factory CreateLabelWithTextColor:0.4 andTextFont:26 andText:@"姓名：小茗同学" addSubView:_contentView];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70*m6Scale);
        make.top.mas_equalTo(_addressLabel.mas_bottom).offset(6*m6Scale);
        make.width.mas_equalTo(kScreenWidth - 280*m6Scale);
    }];
    //电话标签
    _phoneLabel = [Factory CreateLabelWithTextColor:0.4 andTextFont:26 andText:@"电话：11111111111" addSubView:_contentView];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70*m6Scale);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(6*m6Scale);
        make.width.mas_equalTo(kScreenWidth - 280*m6Scale);
    }];
    //修改和确定按钮
    for (int i = 0; i < 2; i++) {
        if (i) {
            _btn =  [Factory addCenterButtonWithTitle:@"确定" andTitleColor:0.4 andButtonbackGroundColorRed:214 Green:213 Blue:207 andCornerRadius:30 addSubView:_contentView];
            [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-40*m6Scale);
                make.size.mas_equalTo(CGSizeMake(220*m6Scale, 60*m6Scale));
                make.top.mas_equalTo(_phoneLabel.mas_bottom).offset(25*m6Scale);
            }];
        }else{
            _btn =  [Factory addCenterButtonWithTitle:@"修改" andTitleColor:1 andButtonbackGroundColorRed:252 Green:186 Blue:54 andCornerRadius:30 addSubView:_contentView];
            [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(40*m6Scale);
                make.size.mas_equalTo(CGSizeMake(220*m6Scale, 60*m6Scale));
                make.top.mas_equalTo(_phoneLabel.mas_bottom).offset(25*m6Scale);
            }];
        }
        _btn.tag = 200+i;
        [_btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(70*m6Scale);
        make.bottom.mas_equalTo(_btn.mas_bottom).offset(20*m6Scale);
    }];
}
/**
 *按钮点击事件
 */
- (void)buttonClick:(UIButton *)sender{
    if (sender.tag == 200) {
        //修改按钮
        _contentView.hidden = YES;
        _bgView.hidden = YES;
        //发送通知 让控制器中的数据回到未输入状态
        NSNotification *notification = [[NSNotification alloc] initWithName:@"sxy_Refesh" object:nil userInfo:@{@"sxy_Refesh":@"2"}];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else{
        //确定按钮
        MyAddressVC *strVC = (MyAddressVC *)[self ViewController];
        OrderDetailsVC *tempVC = [[OrderDetailsVC alloc] init];
        [strVC.navigationController pushViewController:tempVC animated:YES];
    }
}
- (void)layoutAllSubviews{
    /*创建灰色背景*/
    _bgView = [[UIView alloc] initWithFrame:self.frame];
    _bgView.alpha = 0.3;
    _bgView.backgroundColor = [UIColor blackColor];
    [self addSubview:_bgView];
    
    
    /*添加手势事件,移除View*/
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView:)];
    [_bgView addGestureRecognizer:tapGesture];
}
#pragma mark - 手势点击事件,移除View
- (void)dismissContactView:(UITapGestureRecognizer *)tapGesture{
    
    [self dismissContactView];
}
/**
 *用户在支付成功之后，跳转到我的地址界面，弹出收货人姓名、联系方式等信息
 */
- (void)ViewForAddress:(NSString *)address name:(NSString *)name mobile:(NSString *)mobile{
    _addressLabel.text = [NSString stringWithFormat:@"地址：%@", address];//收货地址
    _nameLabel.text = [NSString stringWithFormat:@"姓名：%@", name];//联系人
    _phoneLabel.text = [NSString stringWithFormat:@"电话：%@", mobile];//联系方式
}
-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
}

// 这里加载在了window上
-(void)showView
{
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [window addSubview:self];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sxy_Refesh" object:nil];
}

@end
