//
//  InvestResultView.m
//  CityJinFu
//
//  Created by mic on 2017/10/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "InvestResultView.h"
#import "ActivityCenterVC.h"

@implementation InvestResultView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
        
        [self addSubview:self.receiveBtn];
        [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(634*m6Scale, 692*m6Scale));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    
    return self;
}
/**
 *  立即领取按钮
 */
- (UIButton *)receiveBtn{
    if(!_receiveBtn){
        _receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"InvestResult_弹窗" ofType:@"png"];
        [_receiveBtn setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        //点击按钮的时候  取消按钮的闪烁
        _receiveBtn.adjustsImageWhenHighlighted = NO;
        [_receiveBtn addTarget:self action:@selector(receiveButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        __weak typeof(self) weakSelf = self;
        UIButton *btn = [UIButton ButtonWithImageName:@"InvestResult_关闭按钮" addSubView:_receiveBtn buttonActionBlock:^(UIButton *button) {
            weakSelf.hidden = YES;
        }];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(60*m6Scale, 60*m6Scale));
        }];
    }
    return _receiveBtn;
}

- (void)receiveButtonClick{
    
    ActivityCenterVC *tempVC = [[ActivityCenterVC alloc] init];
    
    UINavigationController *vc = (UINavigationController *)[self ViewController];
    
    tempVC.strUrl = @"/html/activity/calendarActivity.html";
    tempVC.tag = 2001;
    tempVC.urlName = @"冬日暖心";
    
    [vc pushViewController:tempVC animated:YES];
    
}

@end
