//
//  NoticeListsCell.m
//  CityJinFu
//
//  Created by mic on 2017/6/27.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "NoticeListsCell.h"

@implementation NoticeListsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = NO;
        //标题
        _titleLabel = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:@"!!!!!!!!!!!!!!!1" addSubView:self.contentView];
        _titleLabel.textColor = UIColorFromRGB(0x393939);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.right.mas_equalTo(-20*m6Scale);
            make.top.mas_equalTo(34*m6Scale);
        }];
        //时间标签
        _timeLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"6月23日" addSubView:self.contentView];
        _timeLabel.textColor = UIColorFromRGB(0xA5A5A5);
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(26*m6Scale);
        }];
        //公告图片
        _backImgView = [[UIImageView alloc] init];
        _backImgView.backgroundColor = backGroundColor;
        [self.contentView addSubview:_backImgView];
        [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.top.mas_equalTo(_timeLabel.mas_bottom).offset(28*m6Scale);
            make.size.mas_equalTo(CGSizeMake(650*m6Scale, 314*m6Scale));
        }];
        //内容标签
        _contentLabel = [Factory CreateLabelWithTextColor:1 andTextFont:26 andText:@"^^^^^^^^^^^^^^^^^^" addSubView:self.contentView];
        _contentLabel.textColor = UIColorFromRGB(0xA6A6A6);
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.bottom.mas_equalTo(-7*m6Scale);
            make.width.mas_equalTo(kScreenWidth-40*m6Scale);
        }];
    }
    
    return self;
}

- (void)setModel:(NoticeTrendsModel *)model{
    //标题
    _titleLabel.text = model.name;
    //时间
    _timeLabel.text = [Factory stdTimeyyyyMMddFromNumer:model.addtime andtag:5];
    //内容(将后台返回的html数据去掉标签)
//    NSString *content = [Factory flattenHTML:model.content];
    //将字符串中的某些字符替换掉
//    NSString *string = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    _contentLabel.backgroundColor = [UIColor whiteColor];
    if (model.summary!=nil&&![model.summary isEqual:[NSNull null]]) {
        _contentLabel.text = [NSString stringWithFormat:@"%@", model.summary];
    }
    else{
        _contentLabel.text = @"暂无";
    }
    //图片
    [_backImgView sd_setImageWithURL:[NSURL URLWithString:model.picturePath] placeholderImage:[UIImage imageNamed:@"activity_image"]];
}

@end
