//
//  SelectedVC.h
//  CityJinFu
//
//  Created by mic on 2017/6/8.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedVC : UIViewController

@property (nonatomic,strong) NSString *itemStatus;//(0-全部 1-预约 2-满标）

- (void)compareSelegentServiceData;

@end
