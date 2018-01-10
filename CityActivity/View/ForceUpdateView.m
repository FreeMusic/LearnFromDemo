//
//  ForceUpdateView.m
//  CityJinFu
//
//  Created by mic on 2017/10/23.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "ForceUpdateView.h"

@implementation ForceUpdateView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
        
        [self addSubview:self.upDateBtn];
        [self.upDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(500*m6Scale, 890*m6Scale));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
    }
    
    return self;
}
/**
 *  强更图片按钮
 */
- (UIImageView *)upDateBtn{
    if(!_upDateBtn){
        _upDateBtn = [[UIImageView alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upDateApp)];
        
        [_upDateBtn addGestureRecognizer:tap];
        
        _upDateBtn.userInteractionEnabled = YES;
    }
    return _upDateBtn;
}

- (void)upDateApp{
    
    NSLog(@"upDateApp");
    
    //更新
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", STOREAPPID]];
    [[UIApplication sharedApplication] openURL:url];
    
}

@end
