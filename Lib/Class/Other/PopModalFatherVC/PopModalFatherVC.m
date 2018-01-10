//
//  PopModalFatherVC.m
//  CityJinFu
//
//  Created by mic on 2017/11/23.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PopModalFatherVC.h"

@interface PopModalFatherVC ()

@end

@implementation PopModalFatherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backGroundColor;
}

-(void)setColor:(BackColor)color{
    //左边按钮
    UIButton *leftButton;
    if (color == BackColor_white) {
        leftButton = [Factory addBlackLeftbottonToVC:self];//左边的按钮
    }else{
        leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    }
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickLeftItem{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
