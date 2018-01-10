//
//  AutoBidRecodeTableViewCell.h
//  CityJinFu
//
//  Created by mic on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoBidRecodeModel.h"

@interface AutoBidRecodeTableViewCell : UITableViewCell
/**
 * 投资记录
 */
- (void)updateCellWithRecordModel:(AutoBidRecodeModel *)model andIndexPath:(NSIndexPath *)indexPath;
@end
