//
//  LockTestView.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define lockBtnCount 9
#define columeCount 3
#define lineCount 3

@interface LockTestView : UIView

@property(nonatomic,strong)NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, assign) NSInteger accessTag;//进入的方式
@property (nonatomic, copy) NSString *clipTag;
@property (nonatomic ,assign) BOOL isCloseProtect;//是否关闭账号保护

@end
