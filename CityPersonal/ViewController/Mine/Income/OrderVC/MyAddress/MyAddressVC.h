//
//  MyAddressVC.h
//  CityJinFu
//
//  Created by mic on 2017/6/2.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAddressVC : UIViewController

@property (nonatomic, assign) NSInteger type;//在用户点击商城购买订单的时候 用户未添加地址  到该页面添加地址
@property (nonatomic, assign) NSInteger style;

@property (nonatomic, strong) NSString *userName;//联系人
@property (nonatomic, strong) NSString *address;//收货地址
@property (nonatomic, strong) NSString *mobile;//联系方式

- (void)RefreshTableView;

@end
