//
//  FirstBankView.h
//  CityJinFu
//
//  Created by xxlc on 17/8/2.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstBankView : UIView
@property (nonatomic ,strong)UITextField *nameText;//姓名
@property (nonatomic ,strong)UITextField *cardNoText;//卡号
@property (nonatomic , copy)void(^buttonAction)(id obj);
@end
