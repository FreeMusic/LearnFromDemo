//
//  PlanBottomCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/13.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PlanBottomCell.h"
#import "FormValidator.h"

@implementation PlanBottomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        //线条
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = ButtonColor;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.top.mas_equalTo(28*m6Scale);
            make.size.mas_equalTo(CGSizeMake(1, 28*m6Scale));
        }];
        //了解详情标签
        UILabel *titleLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"了解详情" addSubView:self.contentView];
        titleLabel.textColor = UIColorFromRGB(0x393939);
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line.mas_right).offset(3*m6Scale);
            make.top.mas_equalTo(28*m6Scale);
        }];
        //了解详情详细内容
        _detailsLabel = [[UITextView alloc] init];
        _detailsLabel.editable = NO;
        [self.contentView addSubview:_detailsLabel];
        [_detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.top.mas_equalTo(66*m6Scale);
            make.width.mas_equalTo(kScreenWidth-20*m6Scale);
            make.bottom.mas_equalTo(0);
        }];
    }
    
    return self;
}

- (void)cellForModel:(NSString *)content{

    _detailsLabel.text = @"锁投加息是为投资人提供期限内本金自动循环投资的锁投加息，由系统为投资人自动按月投资，利息将根据锁定期限的不同进行加息。投资人在锁定后资金处于冻结状态，待标的匹配完成后，系统将投资人资金从其存管账户投至借款人存管账户，资金流向均在银行存管下安全透明。到期回款在锁定期内将自动复投，充分提高资金的利用效率。";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_detailsLabel.text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:7];
    
    paragraphStyle.firstLineHeadIndent=32;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_detailsLabel.text length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.5 alpha:1] range:NSMakeRange(0, [_detailsLabel.text length])];
    
    _detailsLabel.attributedText = attributedString;
    
    [_detailsLabel sizeToFit];
}

@end
