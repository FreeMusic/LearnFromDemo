//
//  GoodsDetailsCell.m
//  CityJinFu
//
//  Created by mic on 2017/6/15.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "GoodsDetailsCell.h"

@implementation GoodsDetailsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = backGroundColor;
        //商品图片
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return self;
}


- (void)cellForImgView:(NSString *)imgName{
    //商品图片
    [_imgView sd_setImageWithURL:[NSURL URLWithString:imgName]];
}
@end
