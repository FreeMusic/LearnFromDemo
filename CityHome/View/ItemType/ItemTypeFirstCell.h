//
//  ItemTypeFirstCell.h
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailsModel.h"


@interface ItemTypeFirstCell : UITableViewCell

///**
// * 项目利率
// */
//- (void)updateCellItemName:(NSString *)itemName andItemAccount:(NSString *)itemAccount andItemOngoingAccount:(NSString *)itemOngoingAccount andItemSecondName:(NSString *)itemSecondName andItemPercent:(NSString *)ItemPercent anditemAddRate:(NSString *)itemAddRate anditemStatus:(NSString *)itemStatus;

- (void)cellForModel:(ItemDetailsModel *)model;

@end
