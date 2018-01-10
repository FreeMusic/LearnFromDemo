//
//  ScanIdentityVC.h
//  CityJinFu
//
//  Created by mic on 2017/7/27.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanIdentityVC : UIViewController

//假如用户从投资页面跳转到实名页面 需要一个特殊的标志 确保用户在绑卡完成之后 能够返回到投资页
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *userName;//假如是老用户 留有用户名
@property (nonatomic, strong) NSString *identifyCard;//同上  用户身份证号
@property (nonatomic, strong) NSString *realnameStatus;//用户实名状态 0 否 1 已实名
@property (nonatomic, strong) UIImage *idCradImg;//身份证正面信息
@property (nonatomic, strong) UIImage *reverseImg;//身份证反面信息
@property (nonatomic, strong) UIImage *numberImage;//身份证号信息
@property (nonatomic, strong) NSString *cardName;//身份证信息  确认正反面
@property (nonatomic, strong) NSString *cardNum;//身份证号
@property (nonatomic, strong) NSString *name;//用户的真实姓名


@end
