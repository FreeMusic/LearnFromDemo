//
//  RecommendedCell.h
//  CityJinFu
//
//  Created by xxlc on 17/6/8.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"

@interface RecommendedCell : UITableViewCell <NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

- (void)cellForModelArray:(NSArray *)array;

@end
