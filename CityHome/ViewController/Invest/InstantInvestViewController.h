//
//  InstantInvestViewController.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstantInvestViewController : UIViewController
@property (nonatomic, copy) NSString *itemId;//项目ID
@property (nonatomic, copy) NSString *percentLabel;//年化利率
@property (nonatomic, copy) NSString *itemTime;//项目期限
@property (nonatomic, copy) NSString *itemAccount;//可投金额
@property (nonatomic, copy) NSString *itemCycleUnit;//项目期限的类型
@property (nonatomic, strong) NSString *userName;//用户未绑卡 跳到投资详情页  需要用户的名字 方便绑卡
@property (nonatomic, strong) NSString *titleName;//标名

@end
