//
//  IntegralShopVC.h
//  CityJinFu
//
//  Created by mic on 2017/7/26.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXYWebVC.h"

@interface IntegralShopVC : SXYWebVC

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy) NSString *strUrl;//跳转路径
@property (nonatomic, copy) NSString *urlName;//头部名称

@end
