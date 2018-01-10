//
//  OrderVC.h
//  CityJinFu
//
//  Created by mic on 2017/6/2.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderVC : UIViewController

@property (nonatomic, assign) NSInteger type;//当用户从我的订单部分跳转到该页面的时候 1
@property (nonatomic, strong) NSString *orderNo;//订单编号
@property (nonatomic,strong) NSString *kindID;//期限种类id
@property (nonatomic,strong) NSString *number;//数量

@end
