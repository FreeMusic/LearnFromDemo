//
//  CalculatorView.m
//  12345
//
//  Created by hanling on 16/10/13.
//  Copyright © 2016年 hanling. All rights reserved.
//

#import "CalculatorView.h"



@interface CalculatorView ()<UITextFieldDelegate>



@end

@implementation CalculatorView

-(instancetype) initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self createCalculatorView];
    }
    return self;
}

- (void)createCalculatorView {
    
    //取消
    self.cancelImageView = [[UIImageView alloc] init];
    self.cancelImageView.image = [UIImage imageNamed:@"calculatorCancel"];
    self.cancelImageView.userInteractionEnabled = YES;
    [self addSubview:self.cancelImageView];
    
    [self.cancelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.mas_equalTo(CGSizeMake(42 * m6Scale, 41 * m6Scale));
        make.right.equalTo(self.mas_right).offset(-34 * m6Scale);
        make.top.equalTo(self.mas_top).offset(34 * m6Scale);
    }];
    //计算器icon
    UIImageView *calculatorImageView = [[UIImageView alloc] init];
    calculatorImageView.image = [UIImage imageNamed:@"calculator"];
    [self addSubview:calculatorImageView];
    
    [calculatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_centerX).offset(- 80 * m6Scale);
        make.size.mas_equalTo(CGSizeMake(37 * m6Scale, 43 * m6Scale));
        make.centerY.equalTo(self.cancelImageView.mas_centerY);
    }];
    
    UILabel *calcuLabel = [[UILabel alloc] init];
    calcuLabel.text = @"收益计算器";
    calcuLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:36 * m6Scale];
    [self addSubview:calcuLabel];
    
    [calcuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(calculatorImageView.mas_right).offset(27 * m6Scale);
        make.centerY.equalTo(calculatorImageView.mas_centerY);
        
    }];
    
    CALayer *calLayer = [CALayer layer];
    calLayer.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:241 / 255.0 blue:242 / 255.0 alpha:1].CGColor;
    calLayer.frame = CGRectMake(0, 100 * m6Scale, kScreenWidth, 1 * m6Scale);
    [self.layer addSublayer:calLayer];
    
    //输入金额
    self.expectedMoneyTf = [[UITextField alloc] init];
    self.expectedMoneyTf.textColor = [UIColor redColor];
    self.expectedMoneyTf.font = [UIFont systemFontOfSize:48 * m6Scale];
    self.expectedMoneyTf.backgroundColor = [UIColor clearColor];
    self.expectedMoneyTf.tintColor = [UIColor lightGrayColor];
    self.expectedMoneyTf.textAlignment = NSTextAlignmentCenter;
    self.expectedMoneyTf.placeholder = @"输入金额";
    self.expectedMoneyTf.delegate = self;
    self.expectedMoneyTf.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.expectedMoneyTf];
    
    [self.expectedMoneyTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(200 * m6Scale);
        make.left.equalTo(self.mas_left).offset(10 * m6Scale);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - 30 * m6Scale)/2, 70 * m6Scale));
    }];
    
    UILabel *hopeLabel = [[UILabel alloc] init];
    hopeLabel.text = @"预期金额";
    hopeLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:36 * m6Scale];
    [self addSubview:hopeLabel];
    
    [hopeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(122 * m6Scale);
        make.centerX.equalTo(self.expectedMoneyTf.mas_centerX);
    }];
    
    //项目期限
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.textColor = [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1.0];
    self.timeLab.font = [UIFont systemFontOfSize:48 * m6Scale];
    self.timeLab.backgroundColor = [UIColor clearColor];
    self.timeLab.textAlignment = NSTextAlignmentCenter;
    self.timeLab.text = @"30天";
    [self addSubview:self.timeLab];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(200 * m6Scale);
        make.right.equalTo(self.mas_right).offset(-10 * m6Scale);
        make.size.mas_equalTo(CGSizeMake((kScreenWidth - 30 * m6Scale)/2, 90 * m6Scale));
    }];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = @"投资期限";
    dateLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:36 * m6Scale];
    [self addSubview:dateLabel];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(hopeLabel.mas_centerY);
        make.centerX.equalTo(self.timeLab.mas_centerX);
    }];
    
    CALayer *centerLayer = [CALayer layer];
    centerLayer.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:241 / 255.0 blue:242 / 255.0 alpha:1].CGColor;
    centerLayer.frame = CGRectMake(kScreenWidth / 2, 122 * m6Scale, 1 * m6Scale, 127 * m6Scale);
    [self.layer addSublayer:centerLayer];
    
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:241 / 255.0 blue:242 / 255.0 alpha:1].CGColor;
    bottomLayer.frame = CGRectMake(0, 284 * m6Scale, kScreenWidth, 1 * m6Scale);
    [self.layer addSublayer:bottomLayer];
    
    //收益
    self.expectedIncomeLab = [[UILabel alloc] init];
    self.expectedIncomeLab.textColor = [UIColor redColor];
    self.expectedIncomeLab.font = [UIFont systemFontOfSize:36 * m6Scale];
    self.expectedIncomeLab.backgroundColor = [UIColor clearColor];
    self.expectedIncomeLab.textAlignment = NSTextAlignmentRight;
    self.expectedIncomeLab.text = @"0元";
    [self addSubview:self.expectedIncomeLab];
    
    [self.expectedIncomeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(319 * m6Scale);
        make.right.equalTo(self.mas_right).offset(-30 * m6Scale);
        
    }];
    
    UIImageView *incomeImageView = [[UIImageView alloc] init];
    incomeImageView.image = [UIImage imageNamed:@"calIncome"];
    [self addSubview:incomeImageView];
    
    [incomeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.expectedIncomeLab.mas_centerY);
        make.left.equalTo(self.mas_left).offset(33 * m6Scale);
        make.size.mas_equalTo(CGSizeMake(40 * m6Scale, 40 * m6Scale));
    }];
    
    UILabel *hopeIncomeLabel = [[UILabel alloc] init];
    hopeIncomeLabel.text = @"预期收益";
    hopeIncomeLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:36 * m6Scale];
    [self addSubview:hopeIncomeLabel];
    
    [hopeIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(incomeImageView.mas_right).offset(12 * m6Scale);
        make.centerY.equalTo(incomeImageView.mas_centerY);
    }];
    
    CALayer *clipLayer = [CALayer layer];
    clipLayer.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:241 / 255.0 blue:242 / 255.0 alpha:1].CGColor;
    clipLayer.frame = CGRectMake(0, 386 * m6Scale, kScreenWidth, 1 * m6Scale);
    [self.layer addSublayer:clipLayer];
}

/**
 *  文本框的内容是否符合要求
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text;
    
    if ([string isEqualToString:@""] || [string integerValue] || [string isEqualToString:@"."] || [string isEqualToString:@"0"]) {
        
        if ([string isEqualToString:@""]) {
            //获取到上一次操作的字符串长度
            NSInteger clip = textField.text.length;
            //截取字符串 将最后一个字符删除
            text = [textField.text substringToIndex:clip - 1];
            
        }else {
            
            text = [textField.text stringByAppendingString:string];
        }
        
        if (text.length > 7) {
            
            return NO;
            //            根据输入值实时改变label的值
            //            self.hopeIncomeLabel.text = [NSString stringWithFormat:@"预计收益:%@元",text];
        }else {
            
            self.expectedIncomeLab.text = [NSString stringWithFormat:@"0元"];
        }
        NSDictionary *info = @{
                                @"moneyText" : text
                               
                                                          };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moneyTF" object:self userInfo:info];

        return YES;
        
    }else{
        return NO;
    }
}





@end
