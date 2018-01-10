//
//  AccountCheckVC.h
//  CityJinFu
//
//  Created by mic on 2017/7/17.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "TemplateVC.h"

@interface AccountCheckVC : UIViewController

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *userName;//假如是老用户 留有用户名
@property (nonatomic, strong) NSString *identifyCard;//同上  用户身份证号

@end
