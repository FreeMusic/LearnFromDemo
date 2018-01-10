//
//  RiskPushView.m
//  CityJinFu
//
//  Created by mic on 2017/7/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "RiskPushView.h"
#import "MyViewController.h"
#import "ActivityCenterVC.h"

@implementation RiskPushView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        //白色背景View
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 6*m6Scale;
        backView.layer.masksToBounds = YES;
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(648*m6Scale, 482*m6Scale));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        //风险评测提示标签
        UILabel *titleLabel = [Factory CreateLabelWithTextColor:1 andTextFont:35 andText:@"风险评测提示" addSubView:backView];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = ButtonColor;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(98*m6Scale);
        }];
        //平台结果
        _resultLabel = [Factory CreateLabelWithTextColor:0 andTextFont:35 andText:@"平台默认测试类型结果为稳健型" addSubView:backView];
        _resultLabel.textColor = Colorful(226, 50, 36);
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(40*m6Scale);
        }];
        //最高投资额
        UILabel *amountLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"最高投资金额为：500万元" addSubView:backView];
        
            
        amountLabel.textColor = UIColorFromRGB(0x3e3e3e);
        amountLabel.textAlignment = NSTextAlignmentCenter;
        [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_resultLabel.mas_left);
            make.width.mas_equalTo(648*m6Scale);
            make.top.mas_equalTo(_resultLabel.mas_bottom).offset(34*m6Scale);
        }];
        //提示标签
        UILabel *messageLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"如需提高投资金额请重新测试" addSubView:backView];
        messageLabel.textColor = UIColorFromRGB(0x9e9e9e);
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_resultLabel.mas_left);
            make.width.mas_equalTo(648*m6Scale);
            make.top.mas_equalTo(amountLabel.mas_bottom).offset(34*m6Scale);
        }];
        //生成两个测试标签
        [self getTestButtonAddView:backView];
    }
    
    return self;
}
/**
 *生成两个测试标签
 */
- (void)getTestButtonAddView:(UIView *)backView{
    NSArray *array = @[@"暂不测试", @"重新测试"];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        [btn setTitle:array[i] forState:0];
        btn.layer.cornerRadius = 8*m6Scale;
        btn.layer.masksToBounds = YES;
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(testButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
        if (i == 0) {
            [btn setTitleColor:UIColorFromRGB(0x9e9d9d) forState:0];
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = UIColorFromRGB(0xb3b3b3).CGColor;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(50*m6Scale);
                make.bottom.mas_equalTo(-30*m6Scale);
                make.size.mas_equalTo(CGSizeMake(264*m6Scale, 92*m6Scale));
            }];
        }else{
            [btn setTitleColor:UIColorFromRGB(0xffffff) forState:0];
            btn.backgroundColor = buttonColor;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-50*m6Scale);
                make.bottom.mas_equalTo(-30*m6Scale);
                make.size.mas_equalTo(CGSizeMake(264*m6Scale, 92*m6Scale));
            }];
        }
    }
}
/**
 *测试按钮的点击事件
 */
- (void)testButtonClick:(UIButton *)sender{
    if (sender.tag == 100) {
        //暂不测试
        self.hidden = YES;
    }else{
        //重新测试
        MyViewController *strVC = (MyViewController *)[self ViewController];
        ActivityCenterVC *activity = [ActivityCenterVC new];
        activity.tag = 3;
        activity.urlName = @"风险评估";
        [strVC.navigationController pushViewController:activity animated:YES];
        self.hidden = YES;
    }
}

- (void)changeStringBytext:(NSString *)text changeStr:(NSString *)string{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    //设置某个范围内的字体大小
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:26*m6Scale] range:[text rangeOfString:string]];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x3e3e3e) range:[text rangeOfString:string]];
    _resultLabel.attributedText = str;
}

@end
