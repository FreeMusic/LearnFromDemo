//
//  ActivityRuleVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/1.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "ActivityRuleVC.h"

@interface ActivityRuleVC ()

@end

@implementation ActivityRuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"活动规则"]];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(750*m6Scale, 703*m6Scale));
        make.left.top.mas_equalTo(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
