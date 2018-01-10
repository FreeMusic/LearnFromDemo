//
//  HomeTopView.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/23.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "HomeTopView.h"

@interface HomeTopView ()

@property (nonatomic, strong) UILabel *totalInvestNumLabel; //累计投资金额

@property (nonatomic, strong) UILabel *totalRegisterUserLabel; //累计注册用户

@end

@implementation HomeTopView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 定义需要毛玻璃化的图片
        
        UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
        // 添加毛玻璃
        [self addSubview:effe];
        
        [effe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.height.mas_equalTo(@(110*m6Scale));
        }];
        
        UILabel *investLabel = [[UILabel alloc] init];
        investLabel.text = @"累计金额";
        investLabel.textColor = [UIColor whiteColor];
        investLabel.font = [UIFont systemFontOfSize:24 * m6Scale];
        [self addSubview:investLabel];
        
        [investLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.mas_centerX).offset(- kScreenWidth / 4);
            make.bottom.equalTo(self.mas_bottom).offset(- 10 * m6Scale);
        }];
        
        self.totalInvestNumLabel = [[UILabel alloc] init];
        self.totalInvestNumLabel.textColor = [UIColor whiteColor];
        self.totalInvestNumLabel.adjustsFontSizeToFitWidth = YES;
        self.totalInvestNumLabel.font = [UIFont systemFontOfSize:40 * m6Scale];
        self.totalInvestNumLabel.textAlignment = NSTextAlignmentCenter;
        //self.totalInvestNumLabel.text = @"3000000000元";
        
        [self addSubview:self.totalInvestNumLabel];
        
        [self.totalInvestNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(investLabel.mas_centerX);
            make.width.mas_equalTo(@(kScreenWidth / 2));
            make.top.equalTo(self.mas_top).offset(10 * m6Scale);
        }];
        //中间的虚线
        UIImageView *imageview = [UIImageView new];
        imageview.image = [UIImage imageNamed:@"xian"];
        [self addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-5*m6Scale);
            make.size.mas_equalTo(CGSizeMake(1, 80*m6Scale));
        }];
        
        UILabel *registerLabel = [[UILabel alloc] init];
        registerLabel.text = @"注册人数";
        registerLabel.textColor = [UIColor whiteColor];
        registerLabel.font = [UIFont systemFontOfSize:24 * m6Scale];
        [self addSubview:registerLabel];
        
        [registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.mas_bottom).offset(- 10 * m6Scale);
            make.centerX.equalTo(self.mas_centerX).offset( kScreenWidth / 4);
            
        }];
        
        self.totalRegisterUserLabel = [[UILabel alloc] init];
        self.totalRegisterUserLabel.textColor = [UIColor whiteColor];
        self.totalRegisterUserLabel.adjustsFontSizeToFitWidth = YES;
        self.totalRegisterUserLabel.textAlignment = NSTextAlignmentCenter;
        self.totalRegisterUserLabel.text = @"6000人";
        self.totalRegisterUserLabel.font = [UIFont systemFontOfSize:40 * m6Scale];
        
        [self addSubview:self.totalRegisterUserLabel];
        
        [self.totalRegisterUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(kScreenWidth / 2));
            make.centerX.equalTo(registerLabel.mas_centerX);
            make.top.equalTo(self.mas_top).offset(10 * m6Scale);
        }];
        
    }
    return self;
    
}

- (void)viewForTotalInvestStr:(NSString *)account TotalRegisterUserStr:(NSString *)userNum{
    self.totalInvestNumLabel.text = [NSString stringWithFormat:@"%@元", account];//注册资金
    NSMutableAttributedString *money = [self MutableString:self.totalInvestNumLabel.text andLeftRange:NSMakeRange(self.totalInvestNumLabel.text.length-1, 1) leftFont:25];
    [self String:money andChangeColorString:self.totalInvestNumLabel.text andLabel:self.totalInvestNumLabel];
    self.totalRegisterUserLabel.text = [NSString stringWithFormat:@"%@人", userNum];//注册人数
    NSMutableAttributedString *person = [self MutableString:self.totalRegisterUserLabel.text andLeftRange:NSMakeRange(self.totalRegisterUserLabel.text.length-1, 1) leftFont:25];
    [self String:person andChangeColorString:self.totalRegisterUserLabel.text andLabel:self.totalRegisterUserLabel];
}
/**
 同一个label改变字体大小(可自定义改变字体大小)
 */
- (NSMutableAttributedString *)MutableString:(NSString *)string andLeftRange:(NSRange)leftrange leftFont:(CGFloat)leftFont{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    //设置某个范围内的字体大小
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:40*m6Scale] range:NSMakeRange(0, string.length)];
    //设置某个范围内的字体大小
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:leftFont*m6Scale] range:leftrange];
    
    return str;
}
/**
 中间字体颜色的改变(万全)
 */
- (void)String:(NSMutableAttributedString *)string andChangeColorString:(NSString *)str andLabel:(UILabel *)label{
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(str.length-1, 1)];
    label.attributedText = string;
}

@end
