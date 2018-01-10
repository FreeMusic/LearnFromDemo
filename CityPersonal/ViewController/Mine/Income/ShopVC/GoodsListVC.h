//
//  GoodsListVC.h
//  CityJinFu
//
//  Created by mic on 2017/7/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollPageViewDelegate.h"

@interface GoodsListVC : UIViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic,strong) NSString *typeID;//类型ID

@end
