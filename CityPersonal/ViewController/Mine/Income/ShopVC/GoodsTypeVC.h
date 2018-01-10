//
//  GoodsTypeVC.h
//  CityJinFu
//
//  Created by mic on 2017/6/14.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"

@interface GoodsTypeVC : UIViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic,strong) NSString *Navititle;//导航栏标题
@property (nonatomic,strong) NSString *typeID;//类型ID

- (void)setTypeID:(NSString *)typeID;

@end
