//
//  GoodsDetailsCell.h
//  CityJinFu
//
//  Created by mic on 2017/6/15.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailsCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgView;//商品图片

- (void)cellForImgView:(NSString *)imgName;

@end
