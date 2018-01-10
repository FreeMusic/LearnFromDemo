//
//  BuyOrderVC.h
//  CityJinFu
//
//  Created by mic on 2017/8/3.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyOrderVC : UIViewController
@property (nonatomic, assign) NSInteger type;//当用户从我的订单部分跳转到该页面的时候 1
@property (nonatomic, strong) NSString *orderNo;//订单编号
@property (nonatomic,strong) NSString *kindID;//期限种类id
@property (nonatomic,strong) NSString *number;//数量
@property (nonatomic, strong) NSMutableArray *addressArr;//地址数组
@property (nonatomic, strong) NSString *result;//判断用户进入到修改页面用户是否修改地址了

@end
