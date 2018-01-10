//
//  EquityHeaderCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/6.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "EquityHeaderCell.h"

@interface EquityHeaderCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *total;//进度条总长度
@property (nonatomic, strong) UIView *progress;//进度条有进度的长度
@property (nonatomic, assign) NSInteger grade;//用户当前会员等级
@property (nonatomic, assign) NSInteger money;//用户当前财气值
@property (nonatomic, assign) CGFloat width;//一个宽度 方便计算出财气值进度
@property (nonatomic, strong) UIImageView *backimg;//背景图

@end

@implementation EquityHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _width = (kScreenWidth-376*m6Scale)/2;
        self.selectionStyle = NO;
        //背景图
        _backimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beijing0"]];
        [self.contentView addSubview:_backimg];
        [_backimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
        //用户头像
        _userImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"V0"]];
        [self addSubview:_userImgView];
        [_userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64+20*m6Scale);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(120*m6Scale, 120*m6Scale));
        }];
        //用户手机号码
        _mobileLabel = [Factory CreateLabelWithTextColor:1 andTextFont:26 andText:@"555****5555" addSubView:self];
        [_mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_userImgView.mas_bottom).offset(32*m6Scale);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        //进度条背景颜色
        _total = [[UIView alloc] init];
        _total.backgroundColor = ButtonColor;
        [self addSubview:_total];
        [_total mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(_mobileLabel.mas_bottom).offset(64*m6Scale);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 2));
        }];
        //钻石会员图标
        for (int i = 0; i < 3; i++) {
            //钻石会员图标
            UIImageView *vipImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
            vipImg.tag = 1000+i;
            [self addSubview:vipImg];
            if (i == 0) {
                [vipImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(107*m6Scale);
                    make.top.mas_equalTo(_mobileLabel.mas_bottom).offset(46*m6Scale);
                    make.size.mas_equalTo(CGSizeMake(50*m6Scale, 50*m6Scale));
                }];
            }else if (i == 1){
                [vipImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self.mas_centerX);
                    make.top.mas_equalTo(_mobileLabel.mas_bottom).offset(46*m6Scale);
                    make.size.mas_equalTo(CGSizeMake(50*m6Scale, 50*m6Scale));
                }];
            }else{
                [vipImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-107*m6Scale);
                    make.top.mas_equalTo(_mobileLabel.mas_bottom).offset(46*m6Scale);
                    make.size.mas_equalTo(CGSizeMake(50*m6Scale, 50*m6Scale));
                }];
            }
        }
        //进度条有进度的长度
        _progress = [[UIView alloc] init];
        _progress.backgroundColor = [UIColor whiteColor];
        [_total addSubview:_progress];
    }
    
    return self;
}
/**
 *生成不同等级需要年化门槛 的数组d的懒加载
 */
- (NSMutableArray *)vipArr{
    if (!_vipArr) {
        _vipArr = [NSMutableArray array];
    }
    
    return _vipArr;
}
/**
 *生成不同等级需要年化门槛 的数组
 */
- (void)setVipArrWithDictionary:(NSDictionary *)dictionary andGrade:(NSString *)grade userName:(NSString *)userName yearAmount:(NSString *)yearAmount{
    [self.vipArr addObject:dictionary[@"member_invest_amount_v0"]];
    [self.vipArr addObject:dictionary[@"member_invest_amount_v1"]];
    [self.vipArr addObject:dictionary[@"member_invest_amount_v2"]];
    [self.vipArr addObject:dictionary[@"member_invest_amount_v3"]];
    [self.vipArr addObject:dictionary[@"member_invest_amount_v4"]];
    [self.vipArr addObject:dictionary[@"member_invest_amount_v5"]];
    [self.vipArr addObject:dictionary[@"member_invest_amount_v6"]];
    //会员等级
    _grade = grade.integerValue;
    //累计财气值
    _money = yearAmount.integerValue;
    //根据会员等级确定会员头像背景图
    [self setUserImgViewByGrade:_grade];
    //根据不同等级需要年化门槛 确定会员等级停留处
    [self setUserVipGrade];
    //用户名称
    _mobileLabel.text = userName;
}
/**
 *根据会员等级确定会员头像背景图
 */
- (void)setUserImgViewByGrade:(NSInteger)grade{
    if (grade == 0) {
        _backimg.image = [UIImage imageNamed:@"beijing0"];
    }else if (grade > 0 && grade < 4){
        _backimg.image = [UIImage imageNamed:@"beijing1"];
    }else if (grade > 3 && grade < 6){
        _backimg.image = [UIImage imageNamed:@"beijing4"];
    }else{
        _backimg.image = [UIImage imageNamed:@"beijing6"];
    }
    
    _userImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"V%ld", grade]];//会员头像
}
/**
 *根据不同等级需要年化门槛 确定会员等级停留处
 */
- (void)setUserVipGrade{
    //根据会员现有等级确定会员起始图标
    switch (_grade) {
        case 0:
            [self setVipImgViewFirst:@"item_0_h" second:@"item_1_s" last:@"item_2_s" withIndex:1];
            _total.backgroundColor = Colorful(96, 101, 108);
            break;
        case 1:
            [self setVipImgViewFirst:@"item_0_s" second:@"item_1_h" last:@"item_2_h" withIndex:2];
            _total.backgroundColor = Colorful(101, 97, 89);
            break;
        case 2:
            [self setVipImgViewFirst:@"item_1_h" second:@"item_2_h" last:@"item_3_h"withIndex:2];
            _total.backgroundColor = Colorful(101, 97, 89);
            break;
        case 3:
            [self setVipImgViewFirst:@"item_2_h" second:@"item_3_h" last:@"item_4_s3" withIndex:2];
            _total.backgroundColor = Colorful(101, 97, 89);
            break;
        case 4:
            [self setVipImgViewFirst:@"item_3_s" second:@"item_4_h" last:@"item_5_s2" withIndex:2];
            _total.backgroundColor = Colorful(234, 185, 44);
            break;
        case 5:
            [self setVipImgViewFirst:@"item_4_s2" second:@"item_5_h" last:@"V5_6" withIndex:2];
            _total.backgroundColor = Colorful(234, 185, 44);
            break;
        case 6:
            [self setVipImgViewFirst:@"item_4_s" second:@"item_5_s" last:@"item_6_h" withIndex:3];
            _total.backgroundColor = Colorful(234, 185, 44);
            break;
            
        default:
            [self setVipImgViewFirst:@"item_0_h" second:@"item_1_s" last:@"item_2_s" withIndex:1];
            _total.backgroundColor = Colorful(96, 101, 108);
            break;
    }
}
/**
 *根据会员等级确定会员图标
 */
- (void)setVipImgViewFirst:(NSString *)first second:(NSString *)second last:(NSString *)last withIndex:(NSInteger)index{
    NSArray *array = @[first, second, last];
    for (int i = 0; i < 3; i++) {
        //根据tag值获取控件
        UIImageView *imgView = (UIImageView *)[self viewWithTag:1000+i];
        imgView.image = [UIImage imageNamed:array[i]];
    }
    //根据会员等级，确定哪个会员图标的变大
    UIImageView *img = (UIImageView *)[self viewWithTag:1000+index-1];
    if (index == 1) {
        [img mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(107*m6Scale);
            make.top.mas_equalTo(_mobileLabel.mas_bottom).offset(40*m6Scale);
            make.size.mas_equalTo(CGSizeMake(62*m6Scale, 62*m6Scale));
        }];
    }else if (index == 2){
        [img mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_mobileLabel.mas_bottom).offset(40*m6Scale);
            make.size.mas_equalTo(CGSizeMake(62*m6Scale, 62*m6Scale));
        }];
    }else{
        [img mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-107*m6Scale);
            make.top.mas_equalTo(_mobileLabel.mas_bottom).offset(40*m6Scale);
            make.size.mas_equalTo(CGSizeMake(62*m6Scale, 62*m6Scale));
        }];
    }
    //根据会员等级确定进度条的进度
    if (self.vipArr.count) {
        [self setVipProgressByIndex:index];
    }
}
/**
 *根据会员等级确定进度条的进度
 */
- (void)setVipProgressByIndex:(NSInteger)index{
    CGFloat progress = 0;
    if (index == 1) {
        //用户晋级到下一个会员等级所需要的财气值
        NSString *total = [NSString stringWithFormat:@"%@", self.vipArr[0]];
        //计算出用户在两个等级之间应该移动的进度距离
        progress = _money/total.floatValue*_width;
        //最终确定进度条应该移动的距离
        _progress.frame = CGRectMake(0, 0, progress+169*m6Scale, 2);
    }else if (index == 2){
        //用户晋升到当前会员等级所需要的财气值
        NSString *current = [NSString stringWithFormat:@"%@", self.vipArr[_grade-1]];
        //用户晋升到下一个会员等级所需要的财气值
        NSString *next = [NSString stringWithFormat:@"%@", self.vipArr[_grade]];
        //计算出用户在两个等级之间应该移动的进度距离
        progress = (_money-current.floatValue)/(next.floatValue-current.floatValue)*_width;
        //最终确定进度条应该移动的距离
        _progress.frame = CGRectMake(0, 0, progress+219*m6Scale+_width, 2);
        
    }else{
        //最终确定进度条应该移动的距离
        _progress.frame = CGRectMake(0, 0, kScreenWidth, 2);
    }
    [UIView animateWithDuration:1 animations:^{
        _progress.size = CGSizeMake(_progress.frame.size.width, 2);
    } completion:^(BOOL finished) {
        //累计财气值
        _moneyLabel = [Factory CreateLabelWithTextColor:1 andTextFont:22 andText:[NSString stringWithFormat:@"累计年化金额%ld元", _money] addSubView:self];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_progress.mas_right).offset(15*m6Scale);
            make.top.mas_equalTo(_progress.mas_bottom).offset(35*m6Scale);
        }];
    }];
}

@end
