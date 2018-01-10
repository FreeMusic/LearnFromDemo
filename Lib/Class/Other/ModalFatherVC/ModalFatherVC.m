//
//  ModalFatherVC.m
//  CityJinFu
//
//  Created by mic on 2017/10/31.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "ModalFatherVC.h"

@interface ModalFatherVC ()

@end

@implementation ModalFatherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //返回按钮
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*m6Scale);
        make.top.mas_equalTo(40*m6Scale+KSafeBarHeight);
        make.size.mas_equalTo(CGSizeMake(88*m6Scale, 88*m6Scale));
    }];
    //标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(65*m6Scale+KSafeBarHeight);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}

/**
 *  返回按钮
 */
- (UIButton *)backButton{
    if(!_backButton){
        _backButton = [UIButton buttonWithType:0];
        
        [_backButton setImage:[UIImage imageNamed:@"fanghui"] forState:0];
        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
/**
 *  返回按钮事件
 */
- (void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/**
 *  标题
 */
- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [Factory CreateLabelWithColor:[UIColor colorWithWhite:0 alpha:1] andTextFont:35 andText:@"" addSubView:self.view];
    }
    return _titleLabel;
}

@end
