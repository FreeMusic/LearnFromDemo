//
//  ItemTypeFirstCell.m
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ItemTypeFirstCell.h"

@interface ItemTypeFirstCell ()
@property (nonatomic, strong) UILabel *itemName;//项目名称
@property (nonatomic, strong) UILabel *itemType;//项目类型
@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) NSMutableAttributedString *att;//对百分号进行处理
@property (nonatomic, strong) UIImageView *bottomImg;
@property (nonatomic, strong) UILabel *smallLab;
@property (nonatomic, strong) UIImageView *smallImg;

@end
@implementation ItemTypeFirstCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
/**
 *  布局
 */
- (void)creatView{
    
    [self.contentView addSubview:self.bottomImg];
    [self.contentView addSubview:self.itemName];
    
    [self.bottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    //百分比
    self.percentLabel = [UILabel new];
    self.percentLabel.textColor = [UIColor whiteColor];
    self.percentLabel.backgroundColor = [UIColor clearColor];
    self.percentLabel.text = @"8.8%";
    self.percentLabel.font = [UIFont systemFontOfSize:140*m6Scale];
    [self.contentView addSubview:self.percentLabel];
    [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(180 * m6Scale);
        make.height.equalTo(@(180*m6Scale));
    }];
    //对百分号进行处理
    self.att = [Factory attributedString:_percentLabel.text andRangL:[_percentLabel.text rangeOfString:@"%"] andlabel:_percentLabel andtag:10];
    self.percentLabel.attributedText = _att;
    //加息
    self.smallLab = [[UILabel alloc] init];
    self.smallLab.text = @"+0.6%";
    self.smallLab.font = [UIFont systemFontOfSize:30 * m6Scale];
    self.smallLab.textColor = [UIColor colorWithRed:106/255.0 green:75.0/255.0 blue:19.0/255.0 alpha:1.0];
    [self.contentView addSubview:self.smallLab];
    [self.smallLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(160 * m6Scale);
        make.left.equalTo(self.percentLabel.mas_right).offset(-60 * m6Scale);
        make.height.mas_equalTo(@(50 * m6Scale));
    }];
    //项目名称
    [_itemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(55*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(575*m6Scale);
        make.height.mas_equalTo(@(40*m6Scale));
    }];
    //项目类型
    self.itemType = [[UILabel alloc] init];
    //    self.itemType.text = @"13456";
    self.itemType.backgroundColor = [UIColor clearColor];
    self.itemType.font = [UIFont systemFontOfSize:36 * m6Scale];
    self.itemType.adjustsFontSizeToFitWidth = YES;
    self.itemType.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1.0];
    [self.contentView addSubview:self.itemType];
    //项目类型
    [_itemType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(55 *m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(578*m6Scale);
        make.size.mas_offset(CGSizeMake(600 * m6Scale, 45*m6Scale));
    }];
    //可投金额
    for (int i = 0; i < 7; i ++) {
        UILabel *numLab = [[UILabel alloc] init];
        numLab.tag = 70 + i;
        numLab.textAlignment = NSTextAlignmentCenter;
        numLab.backgroundColor = [UIColor clearColor];
        numLab.text = @"0";
        numLab.textColor = [UIColor colorWithRed:61/255.0 green:169/255.0 blue:231/255.0 alpha:1.0];
        numLab.font = [UIFont systemFontOfSize:48 * m6Scale];
        [self.contentView addSubview:numLab];
        int j = i/3;
        [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-(130 * m6Scale + 75 * m6Scale * i + 25 * m6Scale * j));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-70 * m6Scale);
            make.size.mas_equalTo(CGSizeMake(60 * m6Scale, 70 * m6Scale));
        }];
    }
}
/**
 详情页背景
 */
- (UIImageView *)bottomImg {
    if (!_bottomImg) {
        _bottomImg = [[UIImageView alloc] init];
        _bottomImg.clipsToBounds = YES;
        _bottomImg.image = [UIImage imageNamed:@"beijing"];
    }
    return _bottomImg;
}
/**
 *  项目名称
 */
- (UILabel *)itemName{
    if (!_itemName) {
        _itemName = [UILabel new];
        _itemName.font = [UIFont systemFontOfSize:36*m6Scale];
        _itemName.textColor = [UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:1.0];
    }
    return _itemName;
}
///**
// * 项目利率
// */
//- (void)updateCellItemName:(NSString *)itemName andItemAccount:(NSString *)itemAccount andItemOngoingAccount:(NSString *)itemOngoingAccount andItemSecondName:(NSString *)itemSecondName andItemPercent:(NSString *)ItemPercent anditemAddRate:(NSString *)itemAddRate anditemStatus:(NSString *)itemStatus
//{
//    NSLog(@"%@,%@,%@",itemAccount,itemOngoingAccount,itemStatus);
//    //可投金额
//    NSString *surplusMoney = @"";
//    NSMutableArray *numArr = [NSMutableArray new];
//    if (itemStatus.intValue == 18) {
//        surplusMoney = @"0";
//    }else{
//        surplusMoney = [NSString stringWithFormat:@"%d",(itemAccount.intValue - itemOngoingAccount.intValue)];
//    }
//    for (NSInteger i = surplusMoney.length; i > 0; i --) {
//        
//        [numArr addObject:[surplusMoney substringWithRange:NSMakeRange(i-1, 1)]];
//    }
//    //    NSLog(@"11111+++++%@",numArr);
//    for (int i = 0; i < numArr.count; i ++) {
//        UILabel *myLab = [self.contentView viewWithTag:70 + i];
//        myLab.text = numArr[i];
//    }
//    //利率
//    self.percentLabel.text = ItemPercent;
//    //对百分号进行处理
//    self.att = [Factory attributedString:_percentLabel.text andRangL:[_percentLabel.text rangeOfString:@"%"] andlabel:_percentLabel andtag:10];
//    self.percentLabel.attributedText = _att;
//    //判断是否加息
//    if (itemAddRate.floatValue == 0) {
//        self.smallLab.hidden = YES;
//        //        self.smallImg.hidden = YES;
//    }
//    else {
//        self.smallLab.text = [NSString stringWithFormat:@"＋%@",itemAddRate];
//        //对百分号进行处理
//        self.att = [Factory attributedString:_smallLab.text andRangL:[_smallLab.text rangeOfString:itemAddRate] andlabel:_smallLab andtag:20];
//        self.smallLab.attributedText = _att;
//    }
//    //    _itemName.text = itemName;//项目名称
//    _itemType.text = itemSecondName;//项目的副标题
//}
- (void)cellForModel:(ItemDetailsModel *)model{
    NSInteger status = model.itemStatus.integerValue;
    //可投金额
    NSString *surplusMoney = @"";
    NSMutableArray *numArr = [NSMutableArray new];
    NSLog(@"status = %ld", status);
    if (status == 18 || status == 20 || status == 23){
//        [self setButtonTitle:@"已满标"];
        [numArr addObject:@"0"];
    }else if(status == 30 || status == 31 || status == 32){
//        [self setButtonTitle:@"还款中"];
        [numArr addObject:@"0"];
    }else if(status == 13 || status == 14){
//        [self setButtonTitle:@"流标"];
        [numArr addObject:@"0"];
    }else{
        surplusMoney = [NSString stringWithFormat:@"%d",(model.itemAccount.intValue - model.itemOngoingAccount.intValue)];
        for (NSInteger i = surplusMoney.length; i > 0; i --) {
            
            [numArr addObject:[surplusMoney substringWithRange:NSMakeRange(i-1, 1)]];
        }
    }
    for (int i = 0; i < numArr.count; i ++) {
        UILabel *myLab = [self.contentView viewWithTag:70 + i];
        myLab.text = numArr[i];
    }
    NSLog(@"%@", model.itemSecondName);
    if (model.itemSecondName == nil) {
        _itemName.text = model.itemName;//项目名称
    }else{
        _itemName.text = model.itemSecondName;//项目副标题
    }
    self.percentLabel.text = [NSString stringWithFormat:@"%.1f%@", model.itemRate.floatValue, @"%"];//利率
    //对百分号进行处理
    self.att = [Factory attributedString:_percentLabel.text andRangL:[_percentLabel.text rangeOfString:@"%"] andlabel:_percentLabel andtag:10];
    self.percentLabel.attributedText = _att;//利率
    //加息利率
    self.smallLab.text = model.itemAddRate.floatValue > 0 ? [NSString stringWithFormat:@"+%.1f%@", model.itemAddRate.floatValue, @"%"] : @"";
}

@end
