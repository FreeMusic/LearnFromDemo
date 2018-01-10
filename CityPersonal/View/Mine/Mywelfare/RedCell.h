//
//  RedCell.h
//  CityJinFu
//
//  Created by xxlc on 16/8/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedModel.h"

@interface RedCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageview;//背景图片
@property (nonatomic, strong) UIView *backView;//承载所有控件 的额view
@property (nonatomic, strong) UIImageView *hookImageView;//对勾
/**
 * 红包-投资
 */
- (void)updateCellWithRedModel:(RedModel *)model andIndexPath:(NSIndexPath *)indexPath;
/**
 * 红包-福利
 */
- (void)updateCellWithMyRedModel:(RedModel *)model andIndexPath:(NSIndexPath *)indexPath;
/**
 *  体验金
 */
- (void)updateCellWithGoldModel:(RedModel *)model andIndexPath:(NSIndexPath *)indexPath;
@end
