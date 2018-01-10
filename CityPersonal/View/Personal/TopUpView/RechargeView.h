//
//  RechargeView.h
//  CityJinFu
//
//  Created by mic on 2017/7/21.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassGuardCtrl.h"
#import "BankListModel.h"
#import "TopUpModel.h"
#import "TopUpCell.h"

@interface RechargeView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UIView *backView;//
@property (nonatomic, strong) UILabel *styleLabel;//输入框判断是充值还是提现
@property (nonatomic, strong) UILabel *amountLabel;//金额标签
@property (nonatomic, strong) PassGuardTextField *myTextFiled;//交易密码输入框
@property (nonatomic, strong) UILabel *titleLabel;//标题类型
@property (nonatomic, strong) NSString *mcryptKey;//加密因子
@property (nonatomic, strong) NSString *passWord;
@property (nonatomic, strong) NSString *isShowBankList;//暂时设定在投资页面展示银行卡列表信息 值大于零显示银行卡信息
@property (nonatomic, assign) BOOL isAllow;
//在投资页面输入交易密码框的时候  区分是投资还是提现  1是投资  2是提现
@property (nonatomic, strong) NSString *style;
@property (nonatomic, strong) NSString *bankId;
@property (nonatomic, strong) UITableView *tableView;//展示银行卡列表信息
@property (nonatomic, strong) BankListModel *model;
@property (nonatomic, strong) TopUpModel *topUpModel;
@property (nonatomic, strong) TopUpCell *cell;

//跳转至银行卡列表弹框
@property (nonatomic, copy) void (^skipToBankListView)(NSInteger index, NSArray *dataSource, NSArray *payArr, NSInteger bankDefault, NSInteger comDefault);

@end
