//
//  LargeRechargeView.m
//  CityJinFu
//
//  Created by mic on 2017/11/24.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "LargeRechargeView.h"

@implementation LargeRechargeView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.54];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LargeAmountRechange_流程@2x" ofType:@"png"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
        
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(606*m6Scale, 583*m6Scale));
        }];
        
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.hidden = YES;
}

@end
