//
//  VipBottomCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/4.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "VipBottomCell.h"
#import "IntegralShopVC.h"
#import "GoodsRecomondModel.h"

@interface VipBottomCell ()

@property (nonatomic, strong) UIView *backView;//背景View

@end

@implementation VipBottomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //半屏幕宽度
        CGFloat width = kScreenWidth/2;
        //双线
        UIView *lineVertical = [[UIView alloc] init];
        lineVertical.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self.contentView addSubview:lineVertical];
        [lineVertical mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            if (kStatusBarHeight > 20) {
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(-50);
            }else{
                make.bottom.top.mas_equalTo(0);
            }
            make.width.mas_equalTo(1);
        }];
        
        UIView *lineHoral = [[UIView alloc] init];
        lineHoral.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self.contentView addSubview:lineHoral];
        [lineHoral mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-45*m6Scale);
            make.height.mas_equalTo(1);
        }];
        for (int i = 0; i < 4; i++) {
            //空白按钮
            UIButton *btn = [UIButton buttonWithType:0];
            btn.tag = 500+i;
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(width,220*m6Scale));
                make.left.mas_equalTo(width*(i%2));
                if (kStatusBarHeight > 20) {
                    make.top.mas_equalTo((230*m6Scale+25)*(i/2));
                }else{
                    make.top.mas_equalTo(230*m6Scale*(i/2));
                }
            }];
            //图片
            _imgView = [[UIImageView alloc] init];
            _imgView.tag = 100+i;
            _imgView.image = [UIImage imageNamed:@"216x150"];
            [btn addSubview:_imgView];
            [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(216*m6Scale, 150*m6Scale));
                make.centerX.mas_equalTo(btn.mas_centerX);
                make.top.mas_equalTo(3);
            }];
            //上标签
            _timeLabel = [Factory CreateLabelWithTextColor:1 andTextFont:25 andText:@"" addSubView:btn];
            _timeLabel.tag = 200+i;
            
            _timeLabel.textAlignment = NSTextAlignmentCenter;
            _timeLabel.textColor = UIColorFromRGB(0xFF5824);
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(_imgView.mas_bottom).offset(2*m6Scale);
            }];
            //福利标签
            _welfLabel = [Factory CreateLabelWithTextColor:0.7 andTextFont:28 andText:@"" addSubView:btn];
            _welfLabel.tag = 300+i;
            _welfLabel.textColor = UIColorFromRGB(0x6E6E6E);
            [_welfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_timeLabel.mas_bottom).offset(2*m6Scale);
                make.centerX.mas_equalTo(btn.mas_centerX);
            }];
        }
    }
    
    return self;
}
/**
 *按钮点击事件
 */
- (void)buttonClick:(UIButton *)sender{
    //积分商城
    ClipActivityController *strVC = (ClipActivityController *)[self.contentView ViewController];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strVC.navigationController.view animated:YES];
    //兑吧免登陆接口
    [DownLoadData postLogFreeUrl:^(id obj, NSError *error) {
        [hud hideAnimated:YES];
        IntegralShopVC *tempVC = [IntegralShopVC new];
        tempVC.strUrl = obj[@"ret"];
        [strVC.navigationController pushViewController:tempVC animated:YES];
    } userId:[HCJFNSUser stringForKey:@"userId"] redicrect:@""];
}

- (void)cellForArray:(NSMutableArray *)array{
    //推
    NSInteger index = 0;
    NSLog(@"%ld", array.count);
    if (array.count < 4) {
        index = array.count;
        for (long i = index; i < 4; i++) {
            UIButton *btn = (UIButton *)[self.contentView viewWithTag:500+i];
            btn.hidden = YES;
        }
    }else{
        index = 4;
    }
    for (int i = 0; i < index; i++) {
        GoodsRecomondModel *model = array[i];
        //图片
        UIImageView *imgView = (UIImageView *)[self.contentView viewWithTag:100+i];
        //上标签
        UILabel *topLabel = (UILabel *)[self.contentView viewWithTag:200+i];
        topLabel.text = [NSString stringWithFormat:@"%ld积分起", model.goodsIntegral.integerValue];
        //福利标签
        UILabel *wealfLabel = (UILabel *)[self.contentView viewWithTag:300+i];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.goodsImage]] placeholderImage:[UIImage imageNamed:@"216x150"]];
        wealfLabel.text = [NSString stringWithFormat:@"%@", model.goodsName];
    }
}

@end
