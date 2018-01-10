//
//  TemplateVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/4.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "TemplateVC.h"

@interface TemplateVC ()

@end

@implementation TemplateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = Colorful(220, 220, 219);
    //左边按钮
    UIButton *leftButton = [Factory addBlackLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickLeftItem{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
