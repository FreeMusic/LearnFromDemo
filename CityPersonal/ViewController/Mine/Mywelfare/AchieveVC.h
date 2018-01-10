//
//  AchieveVC.h
//  CityJinFu
//
//  Created by xxlc on 16/10/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AchieveVC : UIViewController

@property (nonatomic, strong) NSString *urlStr;//链接
@property (nonatomic, assign) NSInteger acTag;//不同的值对应不同的链接
@property (nonatomic, strong) NSString *titileStr;//标题
@property (nonatomic, strong) NSString *orderNO;//合同编号

@end
