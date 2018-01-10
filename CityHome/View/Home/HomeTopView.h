//
//  HomeTopView.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/23.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTopView : UIView



@property (nonatomic, copy) NSString *totalInvestStr; //累计投资金额
@property (nonatomic, copy) NSString *totalRegisterUserStr; //累计注册用户

- (void)viewForTotalInvestStr:(NSString *)account TotalRegisterUserStr:(NSString *)userNum;

@end
