//
//  RecordCell.h
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordModel.h"

@interface RecordCell : UITableViewCell
/**
 * 投资记录
 */
- (void)updateCellWithRecordModel:(RecordModel *)model andIndexPath:(NSIndexPath *)indexPath;

@end
