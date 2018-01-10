//
//  CardVolumeCell.h
//  CityJinFu
//
//  Created by xxlc on 16/8/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketModel.h"

@interface CardVolumeCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imageview;//背景图片
@property (nonatomic,strong) UIView *backView;//承载所有控件 的额view
@property (nonatomic, strong) UIImageView *hookImageView;//对勾
/**
 * 加息劵-投资
 */
- (void)updateCellWithTicketModel:(TicketModel *)model andIndexPath:(NSIndexPath *)indexPath;
/**
 * 加息劵-福利
 */
- (void)updateCellWithMyTicketModel:(TicketModel *)model andIndexPath:(NSIndexPath *)indexPath;
@end
