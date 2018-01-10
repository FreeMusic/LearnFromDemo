//
//  LockTestViewController.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalFatherVC.h"

@interface LockTestViewController : ModalFatherVC
@property (nonatomic ,assign)BOOL isCloseProtect;
@property (nonatomic ,assign)NSInteger tag;

@end
