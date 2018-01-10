//
//  InviteRecordCell.m
//  CityJinFu
//
//  Created by mic on 2017/11/8.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "InviteRecordCell.h"

@interface InviteRecordCell ()

@property (nonatomic, strong) UILabel *inviteLabel;//邀请到的好友

@property (nonatomic, strong) UILabel *timeLable;//注册时间

@property (nonatomic, strong) UILabel *bidLabel;//是否绑卡

@property (nonatomic, strong) UILabel *investLabel;//是否投资

@end

@implementation InviteRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = NO;
        //邀请到的好友
        _inviteLabel = [self getLabelWithTitle:@"已邀请好友" order:0];
        //注册时间
        _timeLable = [self getLabelWithTitle:@"注册时间" order:1];
        //是否绑卡
        _bidLabel = [self getLabelWithTitle:@"是否绑卡" order:2];
        //是否投资
        _investLabel = [self getLabelWithTitle:@"是否投资" order:3];
    }
    
    return self;
}

- (UILabel *)getLabelWithTitle:(NSString *)title order:(int)order{
    
    CGFloat width = self.frame.size.width/4;
    
    UILabel *label = [Factory CreateLabelWithColor:buttonColor andTextFont:25 andText:title addSubView:self.contentView];
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        if (order > 1) {
            make.width.mas_equalTo(width-30*m6Scale);
            make.left.mas_equalTo((width+30*m6Scale)*2+(order-2)*(width-30*m6Scale));
        }else{
            make.width.mas_equalTo(width+30*m6Scale);
            make.left.mas_equalTo((width+30*m6Scale)*order);
        }
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    return label;
}

- (void)cellForModel:(InvitePersonModel *)model{
    _inviteLabel.text = model.mobile;//已经邀请到的好友
    _timeLable.text = [Factory stdTimeyyyyMMddFromNumer:model.addtime andtag:99];//注册时间
    _bidLabel.text = model.isBindCard;//是否绑卡
    _investLabel.text = model.isInvest;//是否投资
    
}

@end
