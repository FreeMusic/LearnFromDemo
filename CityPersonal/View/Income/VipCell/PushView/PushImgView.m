//
//  PushImgView.m
//  CityJinFu
//
//  Created by mic on 2017/8/7.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PushImgView.h"
#import "VipVC.h"

@implementation PushImgView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        //弹出图片
        [self addSubview:self.pushImgView];
        //投资按钮
        [self.pushImgView addSubview:self.investBtn];
    }
    
    return self;
}

/**
 *弹出图片
 */
- (UIImageView *)pushImgView{
    if(!_pushImgView){
        _pushImgView = [[UIImageView alloc] init];
        _pushImgView.userInteractionEnabled = YES;
    }
    return _pushImgView;
}
/**
 *按钮
 */
- (UIButton *)investBtn{
    if(!_investBtn){
        _investBtn = [UIButton buttonWithType:0];
        [_investBtn addTarget:self action:@selector(SkipToInvest) forControlEvents:UIControlEventTouchUpInside];
    }
    return _investBtn;
}

/**
 *跳转至投资页面
 */
- (void)SkipToInvest{
    VipVC *ctr = (VipVC *)[self ViewController];
    NSNotification *notification = [[NSNotification alloc] initWithName:@"GoToInvest" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [ctr.navigationController popToRootViewControllerAnimated:NO];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
