//
//  SubmitBtn.m
//  CityJinFu
//
//  Created by xxlc on 16/8/28.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "SubmitBtn.h"

@implementation SubmitBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:44*m6Scale];
        self.backgroundColor = ButtonColor;
        self.layer.cornerRadius = 5;
    }
    return self;
}


@end
