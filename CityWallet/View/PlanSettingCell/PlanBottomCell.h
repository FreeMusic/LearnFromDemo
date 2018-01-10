//
//  PlanBottomCell.h
//  CityJinFu
//
//  Created by mic on 2017/7/13.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanBottomCell : UITableViewCell

@property (nonatomic, strong) UITextView *detailsLabel;//了解详情内容

- (void)cellForModel:(NSString *)content;

@end
