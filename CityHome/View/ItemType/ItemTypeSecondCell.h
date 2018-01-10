//
//  ItemTypeSecondCell.h
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailsModel.h"

@interface ItemTypeSecondCell : UITableViewCell
/**
 * 项目详情
 */
- (void)updateCellWithTimeLabelText:(NSString *)timeLableText andSumLableText:(NSString *)sumLableText andItemRepayMethod:(NSString *)itemRepayMethod andItemAddRate:(NSString *)itemAddRate andPassword:(NSString *)password andItemCycleUnit:(NSString *)itemCycleUnit andtag:(NSInteger)tag;

- (void)cellForModel:(ItemDetailsModel *)model;

@end
