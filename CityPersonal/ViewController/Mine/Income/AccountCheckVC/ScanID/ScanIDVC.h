//
//  ScanIDVC.h
//  CityJinFu
//
//  Created by mic on 2017/7/27.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanIDVC : UIViewController

@property (nonatomic, strong) NSString *style;//确定要拍身份证正面或者反面
@property (nonatomic, assign) NSInteger backStyle;

@end
