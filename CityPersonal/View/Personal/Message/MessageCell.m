//
//  MessageCell.m
//  CityJinFu
//
//  Created by xxlc on 16/8/21.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "MessageCell.h"
#import "MessageVC.h"

@interface MessageCell ()
@property (nonatomic, strong) UIImageView *messageImage;//信封
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UILabel *messageLabel;//信息
@property (nonatomic, strong) MessageModel *model;

@end
@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}
/**
 *  布局
 */
- (void)createView{
    [self.contentView addSubview:self.messageImage];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.redView];
    //图片
    [_messageImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(36*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(50*m6Scale);
        make.size.mas_equalTo(CGSizeMake(76*m6Scale, 76*m6Scale));
    }];
    //标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_messageImage.mas_right).offset(20*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(36*m6Scale);
        make.height.equalTo(@(30*m6Scale));
    }];
    //未读消息红点
    [_redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(20*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(46*m6Scale);
        make.size.mas_equalTo(CGSizeMake(10*m6Scale, 10*m6Scale));
    }];
    //时间
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20*m6Scale);
        make.top.equalTo(self.contentView.mas_top).offset(40*m6Scale);
        make.height.equalTo(@(20*m6Scale));
    }];
    //信息
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_messageImage.mas_right).offset(20*m6Scale);
        make.right.equalTo(self.contentView.mas_right).offset(-40*m6Scale);
        make.top.equalTo(_titleLabel.mas_bottom).offset(5*m6Scale);
        make.height.equalTo(@(90*m6Scale));
    }];
}
/**
 *未读消息biaozhi标志红点
 */
- (UIView *)redView{
    if(!_redView){
        _redView = [[UIView alloc] init];
        _redView.backgroundColor = [UIColor redColor];
        _redView.layer.cornerRadius = 5*m6Scale;
        _redView.layer.masksToBounds = YES;
    }
    return _redView;
}
/**
 *  信封
 */
- (UIImageView *)messageImage{
    if (!_messageImage) {
        _messageImage = [UIImageView new];
        _messageImage.image = [UIImage imageNamed:@"系统"];
    }
    return _messageImage;
}
/**
 *  标题
 */
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"快来领取体验金!";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:35*m6Scale];
    }
    return _titleLabel;
}
/**
 *  时间
 */
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.text = @"07-06 13:58";
        _timeLabel.textColor = titleColor;
        _timeLabel.font = [UIFont systemFontOfSize:25*m6Scale];
    }
    return _timeLabel;
}
/**
 *  信息
 */
- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.text = @"汇诚金服送您[50元]红包";
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = titleColor;
        _messageLabel.font = [UIFont systemFontOfSize:23*m6Scale];
    }
    return _messageLabel;
}
/**
 * 消息中心
 */
- (void)updateCellWithRedModel:(MessageModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    self.model = model;
    //标题
    _titleLabel.text = model.title;
    //时间
    _timeLabel.text = [Factory stdTimeyyyyMMddFromNumer:model.addtime andtag:1];
    //信息
    _messageLabel.text = model.contents;
    if (model.status.integerValue) {
        self.redView.hidden = YES;
    }else{
        self.redView.hidden = NO;
    }
    //确定消息的类型图标
    switch (model.type.integerValue) {
        case 1:
            //系统消息
            _messageImage.image = [UIImage imageNamed:@"系统"];
            break;
        case 2:
            //订单消息
            _messageImage.image = [UIImage imageNamed:@"dingdan"];
            break;
        case 3:
            //活动消息
            _messageImage.image = [UIImage imageNamed:@"hudong"];
            break;
        case 4:
            //汇诚动态
            _messageImage.image = [UIImage imageNamed:@"dongtai"];
            break;
            
        default:
            _messageImage.image = [UIImage imageNamed:@"系统"];
            break;
    }
}

- (void)hidRedView{
    _redView.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    MessageVC *ctr = (MessageVC *)[self.contentView ViewController];
    //点击单条消息弹出消息详情
    [Factory addAlertToVC:ctr withMessage:self.model.contents title:self.model.title];
    //点击单条消息（读消息）
    [DownLoadData postReadSiteMail:^(id obj, NSError *error) {
        if ([obj[@"result"] isEqualToString:@"success"]) {
            _redView.hidden = YES;
        }
    } siteMailId:[NSString stringWithFormat:@"%@", _model.ID]];
}

@end
