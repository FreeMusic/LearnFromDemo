//
//  ProtectSafeViewController.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/17.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProtectSafeViewController : UIViewController
@property (nonatomic, strong) NSString *strTag;//区分从哪跳过来的
@property (nonatomic, assign) BOOL isCloseProtect;//是否关闭账号保护

@end
