//
//  HomeCell.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/12.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "HomeCell.h"

@interface HomeCell ()

@property (nonatomic, strong) UIView *backView;//为了能够让期限 起投金额 剩余百分比三个标签能够实现居中放置
@property (nonatomic, strong) UIImageView *timeImgView;
@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UIImageView *noDataImg;///暂无数据背景图

@end

@implementation HomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _imageview = [UIImageView new];
        _imageview.image = [UIImage imageNamed:@"ErZhouNianQing.jpg"];
        [self.contentView addSubview:_imageview];
        [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [self creatView];
    }
    return self;
}
/**
 布局
 */
- (void)creatView{
    [self.imageview addSubview:self.backView];
    [self.imageview addSubview:self.titlelab];
    [self.imageview addSubview:self.itemTitle];
    [self.imageview addSubview:self.ratelab];
    [self.imageview addSubview:self.rateTitle];
    [self.imageview addSubview:self.hotImageView];
    [self.backView addSubview:self.cycleLabel];
    [self.backView addSubview:self.moneyLabel];
    [self.backView addSubview:self.accountLabel];
    [self.imageview addSubview:self.invistBtn];
    //项目标题
    [_titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(35*m6Scale);
        make.width.equalTo(@(kScreenWidth));
    }];
//    //竖线
//    CALayer *percent = [[CALayer alloc] init];
//    percent.frame = CGRectMake(kScreenWidth/2, 30*m6Scale, 1, 40*m6Scale);
//    percent.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:241 / 255.0 blue:242 / 255.0 alpha:1].CGColor;
//    [self.contentView.layer addSublayer:percent];
//    //副标题
//    [_itemTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView.mas_right);
//        make.top.equalTo(self.contentView.mas_top).offset(30*m6Scale);
//        make.width.equalTo(@(kScreenWidth/2 - 30*m6Scale));
//    }];
    //横线
    CALayer *showpercent = [[CALayer alloc] init];
    showpercent.frame = CGRectMake(30*m6Scale, 100*m6Scale, kScreenWidth - 60*m6Scale, 1);
    showpercent.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:241 / 255.0 blue:242 / 255.0 alpha:1].CGColor;
    [self.contentView.layer addSublayer:showpercent];
    //利率
    [_ratelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(_itemTitle.mas_bottom).offset(150*m6Scale);
    }];
    //往期利率
    [_rateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(_ratelab.mas_bottom).offset(30*m6Scale);
    }];
    //空白View
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.contentView.mas_top).offset(353*m6Scale);
        make.height.mas_equalTo(40*m6Scale);
    }];
    NSArray *array = @[@"时间",@"金额",@"剩余"];
    //时间图标
    _timeImgView = [UIImageView new];
    _timeImgView.image = [UIImage imageNamed:array[0]];
    [self.backView addSubview:_timeImgView];
    [_timeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
    }];
    //时间
    [_cycleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_timeImgView.mas_right).offset(10*m6Scale);
        make.top.mas_equalTo(0);
    }];
    //起投图标
    _hotImageView = [[UIImageView alloc]init];
    _hotImageView.image = [UIImage imageNamed:array[1]];
    [self.backView addSubview:_hotImageView];
    [_hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_cycleLabel.mas_right).offset(20*m6Scale);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
    }];
    //起投
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_hotImageView.mas_right).offset(10*m6Scale);
        make.top.mas_equalTo(0);
    }];
    //剩余图标
    UIImageView *accountImage = [UIImageView new];
    accountImage.image = [UIImage imageNamed:array[2]];
    [self.backView addSubview:accountImage];
    [accountImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_moneyLabel.mas_right).offset(20*m6Scale);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
    }];
    //剩余
    [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(accountImage.mas_right).offset(10*m6Scale);
        make.top.mas_equalTo(0);
    }];
    //按钮
    [_invistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20*m6Scale);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 380*m6Scale, 80*m6Scale));
    }];
}
/**
 项目标题
 */
- (UILabel *)titlelab{
    if (!_titlelab) {
        _titlelab = [self commitLab:@"新手专享标6666"];
        _titlelab.textAlignment = NSTextAlignmentCenter;
    }
    return _titlelab;
}
/**
 副标题
 */
- (UILabel *)itemTitle{
    if (!_itemTitle) {
        _itemTitle = [UILabel new];
        _itemTitle.text = @"新手福利，多重保护";
        _itemTitle.textAlignment = NSTextAlignmentLeft;
        _itemTitle.textColor = [UIColor lightGrayColor];
        _itemTitle.font = [UIFont systemFontOfSize:30*m6Scale];
    }
    return _itemTitle;
}
/**
 年化利率
 */
- (UILabel *)ratelab{
    if (!_ratelab) {
        _ratelab = [UILabel new];
        _ratelab.text = @"8.8%+0.2%";
        _ratelab.textColor = UIColorFromRGB(0xff5933);
        _ratelab.font = [UIFont systemFontOfSize:70*m6Scale];
    }
    return _ratelab;
}
/**
 往期年化
 */
- (UILabel *)rateTitle{
    if (!_rateTitle) {
        _rateTitle = [UILabel new];
        _rateTitle.text = @"往期年化";
        _rateTitle.textColor = [UIColor lightGrayColor];
        _rateTitle.font = [UIFont systemFontOfSize:36*m6Scale];
    }
    return _rateTitle;
}
/**
 立即投资
 */
- (UIButton *)invistBtn {
    if (!_invistBtn) {
        _invistBtn = [SubmitBtn buttonWithType:UIButtonTypeCustom];
        _invistBtn.layer.cornerRadius = 40*m6Scale;
        [_invistBtn setTitle:@"立即投资" forState:UIControlStateNormal];
    }
    return _invistBtn;
}
/**
 *为了能够让期限 起投金额 剩余百分比三个标签能够实现居中放置(背景View)
 */
- (UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc] init];
    }
    return _backView;
}
/**
 *暂无数据背景图
 */
- (UIImageView *)noDataImg{
    if(!_noDataImg){
        _noDataImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无数据"]];
        [self.contentView addSubview:_noDataImg];
        [_noDataImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(200*m6Scale);
            make.size.mas_equalTo(CGSizeMake(244*m6Scale, 244*m6Scale));
        }];
    }
    return _noDataImg;
}
/**
 项目期限
 */
- (UILabel *)cycleLabel{
    if (!_cycleLabel) {
        _cycleLabel = [self commitLab:@"期限0天"];
    }
    return _cycleLabel;
}
/**
 起投金额
 */
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [self commitLab:@"起投0元"];
    }
    return _moneyLabel;
}
/**
 剩余金额
 */
- (UILabel *)accountLabel{
    if (!_accountLabel) {
        _accountLabel = [self commitLab:@"剩余0%"];
    }
    return _accountLabel;
}
/**
 共性labe
 */
- (UILabel *)commitLab:(NSString *)text{
    UILabel *label = [UILabel new];
    label.text = text;
    label.textColor = BlackColor;
    label.font = [UIFont systemFontOfSize:33*m6Scale];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)cellForModel:(NewItemModel *)model{
    if (model.ID.integerValue) {
        self.noDataImg.hidden = YES;
        _imageview.hidden = NO;
        self.userInteractionEnabled = YES;
        _titlelab.text = model.itemName;//标题
        if (model.itemAddRate.floatValue > 0) {
            NSString *rate = [NSString stringWithFormat:@"%.1f%@",model.itemRate.floatValue,@"%"];
            NSMutableAttributedString *rateAtt = [[NSMutableAttributedString alloc]initWithString:rate attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xff5933),NSFontAttributeName:[UIFont systemFontOfSize:70*m6Scale]}];
            [rateAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30*m6Scale] range:[rate rangeOfString:@"%"]];
            
            NSString *addRate = [NSString stringWithFormat:@"+%.1f%@",model.itemAddRate.floatValue,@"%"];
            NSMutableAttributedString *addRateAtt = [[NSMutableAttributedString alloc]initWithString:addRate attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xff5933),NSFontAttributeName:[UIFont systemFontOfSize:40*m6Scale]}];
            [addRateAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:28*m6Scale] range:[addRate rangeOfString:@"%"]];
            [addRateAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36*m6Scale] range:[addRate rangeOfString:@"+"]];
            [rateAtt appendAttributedString:addRateAtt];
            _ratelab.attributedText = rateAtt;
            
        }else{
            _ratelab.text = [NSString stringWithFormat:@"%.1f%@", model.itemRate.floatValue,@"%"];//年化利率
            NSMutableAttributedString *string = [self MutableString:_ratelab.text andLeftRange:NSMakeRange(_ratelab.text.length-1, 1) leftFont:36];
            _ratelab.attributedText = string;
        }
        NSString *dataUnit = nil;
        //确定时间单位
        switch (model.itemCycleUnit.integerValue) {
            case 1:
                dataUnit = @"天";
                break;
            case 2:
                dataUnit = @"月";
                break;
            case 3:
                dataUnit = @"季";
                break;
            case 4:
                dataUnit = @"年";
                break;
                
            default:
                dataUnit = @"天";
                break;
        }
        _cycleLabel.text = [NSString stringWithFormat:@"期限%d%@", model.itemCycle.intValue, dataUnit];//期限
        _moneyLabel.text = [NSString stringWithFormat:@"起投%d元", model.itemSingleMinInvestment.intValue];//起投金额
        NSInteger ongoing = model.itemOngoingAccount.integerValue*100;
        NSInteger total = model.itemAccount.integerValue;
        if (total) {
            NSInteger rest = 100-(ongoing/total);
            _accountLabel.text = [NSString stringWithFormat:@"剩余%ld%@", rest,@"%"];//剩余百分比
        }
        NSInteger status = model.itemStatus.integerValue;
        NSLog(@"status = %ld", status);
        if (status == 0 || status == 1 || status == 2) {
            [self setButtonTitle:@"等待开放"];
        }else if (status == 18 || status == 20 || status == 23){
            [self setButtonTitle:@"已满标"];
            _accountLabel.text = @"剩余0%";
        }else if(status == 30 || status == 31 || status == 32){
            [self setButtonTitle:@"还款中"];
            _accountLabel.text = @"剩余0%";
        }else if(status == 10){
            [_invistBtn setTitle:@"立即投资" forState:UIControlStateNormal];
            _invistBtn.backgroundColor = ButtonColor;
        }else if(status == 13 || status == 14){
            [self setButtonTitle:@"流标"];
            _accountLabel.text = @"剩余0%";
        }
        //对空白View做重新约束
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_timeImgView.mas_left);
            make.right.mas_equalTo(self.accountLabel.mas_right);
            make.top.mas_equalTo(353*m6Scale);
            make.height.mas_equalTo(40*m6Scale);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
    }else{
        self.userInteractionEnabled = NO;
        _imageview.hidden = YES;
        self.noDataImg.hidden = NO;
    }
}
/**
 *设置立即投标按钮的颜色
 */
- (void)setButtonTitle:(NSString *)title{
    [_invistBtn setTitle:title forState:UIControlStateNormal];
    _invistBtn.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
}

/**
 同一个label改变字体大小(可自定义改变字体大小)
 */
- (NSMutableAttributedString *)MutableString:(NSString *)string andLeftRange:(NSRange)leftrange leftFont:(CGFloat)leftFont{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    //设置某个范围内的字体大小
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:70*m6Scale] range:NSMakeRange(0, string.length)];
    //设置某个范围内的字体大小
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:leftFont*m6Scale] range:leftrange];
    
    return str;
}
@end
