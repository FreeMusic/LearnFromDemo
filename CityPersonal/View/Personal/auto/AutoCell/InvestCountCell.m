//
//  InvestCountCell.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/23.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "InvestCountCell.h"


@interface InvestCountCell ()<APNumberPadDelegate, UITextFieldDelegate>

@end

@implementation InvestCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
    }
    
    return self;
    
}

- (void)createView {
    
    //投资类型
    _investTypeLabel = [[UILabel alloc] init];
    
    _investTypeLabel.text = @"投资总额(元)";
    _investTypeLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:_investTypeLabel];
//    //手势
//    UITapGestureRecognizer * singleRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeInvestTypeAction:)];
//    singleRecognizer.numberOfTapsRequired = 1;
//    [self.investTypeLabel addGestureRecognizer:singleRecognizer];
    [_investTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(42 * m6Scale);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
//    //选择投资类型按钮
//    UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [typeButton addTarget:self action:@selector(changeInvestTypeAction:) forControlEvents:UIControlEventTouchUpInside];
//    [typeButton setImage:[UIImage imageNamed:@"investBid"] forState:UIControlStateNormal];
//    [self.contentView addSubview:typeButton];
//    
//    [typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.centerY.mas_equalTo(self.mas_centerY);
//        make.left.equalTo(_investTypeLabel.mas_right).offset(50 * m6Scale);
//        make.size.mas_equalTo(CGSizeMake(100 * m6Scale, 50 * m6Scale));
//    }];
}

//- (void)changeInvestTypeAction:(id *)button {

    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:@"投资总额" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        self.investTypeLabel.text = @"投资总额";
//        
//    }]];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:@"保留金额" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        self.investTypeLabel.text = @"保留金额";
//    }]];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//    
//    [self.ViewController presentViewController:alert animated:YES completion:nil];
    
//}
/**
 *textFiled的懒加载
 */
- (UITextField *)investTextField{
    if(!_investTextField){
        //投资金额
        _investTextField = [[UITextField alloc] init];
        _investTextField.textAlignment = NSTextAlignmentRight;
        _investTextField.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _investTextField.keyboardType = UIKeyboardTypeNumberPad;
        _investTextField.delegate = self;
        //定制的键盘
        KeyBoard *key = [[KeyBoard alloc]init];
        UIView *clip = [key keyBoardview];
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _investTextField.inputAccessoryView = clip;
        //_investTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入投资金额元或者默认不限" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:30*m6Scale]}];
        _investTextField.text = @"100";
        [self.contentView addSubview:_investTextField];
        
        [_investTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(- 25 * m6Scale);
            make.centerY.mas_equalTo(self.mas_centerY).offset(2 * m6Scale);
            make.size.mas_equalTo(CGSizeMake(450 * m6Scale, 40 * m6Scale));
        }];
    }
    return _investTextField;
}
/**
 投资金额
 */
- (void)inverstMoney:(NSString *)money andTag:(NSString *)tag andIndex:(NSInteger)index{
    if (index) {
        
    }else{
        if (money.integerValue == 0) {
            
        }else{
            NSLog(@"%ld", money.integerValue);
            NSString *account = nil;
            if (money.integerValue > 999) {
                account = [Factory countNumAndChangeformat:money];
            }else{
                account = money;
            }
            _investTextField.text = account;
        }
    }
//    if (money == nil || tag == nil) {
//        _investTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入投资金额元或者默认不限" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:30*m6Scale]}];
//        _investTypeLabel.text = @"投资总额(元)";
//    }else{
//        if (tag.integerValue == 1) {
//            self.investTypeLabel.text = @"投资总额(元)";
//        }else{
//            self.investTypeLabel.text = @"保留金额";
//        }
//        if ([money isEqualToString:@"默认金额不限"]) {
//            _investTextField.textColor = [UIColor lightGrayColor];
//            _investTextField.text = money;
//        }else{
//            _investTextField.text = money;
//        }
//    }
}
/**
 *  键盘消失的点击时间
 */
- (void)doneButton:(UIButton *)button {

    [self endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *text;
    
    if ([string isEqualToString:@""]) {
        //获取到上一次操作的字符串长度
        NSInteger clip = textField.text.length;
        //截取字符串 将最后一个字符删除
        text = [textField.text substringToIndex:clip - 1];
        
    }else {
        
        text = [textField.text stringByAppendingString:string];
    }

    NSDictionary *info = @{
                           @"moneyText" : text
                           
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"zyyAuto" object:self userInfo:info];
    
    return YES;
}


@end
