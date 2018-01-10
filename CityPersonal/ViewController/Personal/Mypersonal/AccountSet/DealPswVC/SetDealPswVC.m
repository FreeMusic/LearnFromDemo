//
//  SetDealPswVC.m
//  CityJinFu
//
//  Created by mic on 2017/8/20.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "SetDealPswVC.h"
#import "PassGuardCtrl.h"

@interface SetDealPswVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *mcryptKey;//加密因子

@end

@implementation SetDealPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"设置交易密码"];
    self.view.backgroundColor = backGroundColor;
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //获取用户的加密因子
    [self getUserMcryptKey];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 24*m6Scale, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = backGroundColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    if (_style.integerValue) {
        NSNotification *noti = [[NSNotification alloc] initWithName:@"sxyPushviewDismiss" object:nil userInfo:@{@"result":@"1"}];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *获取用户的加密因子
 */
- (void)getUserMcryptKey{
    [DownLoadData postGetSrandNum:^(id obj, NSError *error) {
        //获取加密因子
        self.mcryptKey = [NSString stringWithFormat:@"%@", obj[@"mcryptKey"]];
        
        [self.view addSubview:self.tableView];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    NSArray *array = @[@"设置交易密码", @"确认交易密码"];
    NSArray *placeArr = @[@"请设置6位数字交易密码", @"请确认6位数字交易密码"];
    cell.selectionStyle = NO;
    cell.textLabel.text = array[indexPath.row];
    cell.textLabel.textColor = UIColorFromRGB(0x434040);
    cell.textLabel.font = [UIFont systemFontOfSize:28*m6Scale];
    //交易密码输入框
    PassGuardTextField *pswFiled = [[PassGuardTextField alloc] init];
    pswFiled.tag = 1000+indexPath.row;
    [pswFiled setM_license:KeyboardKey];
    [pswFiled setM_iMaxLen:6];
    //加密因子;
    [pswFiled setM_strInput1:self.mcryptKey];
    [pswFiled setM_mode:true];
    pswFiled.secureTextEntry = YES;
    pswFiled.keyboardType = UIKeyboardTypeNumberPad;
    pswFiled.placeholder = placeArr[indexPath.row];
    pswFiled.font = [UIFont systemFontOfSize:26*m6Scale];
    [cell addSubview:pswFiled];
    [pswFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.textLabel.mas_right).offset(20*m6Scale);
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [UIView new];
    footerView.backgroundColor = backGroundColor;
    UIButton *sureBtn = [UIButton buttonWithType:0];
    [sureBtn setTitle:@"确定" forState:0];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    [sureBtn addTarget:self action:@selector(userSetPsw) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.backgroundColor = ButtonColor;
    sureBtn.layer.cornerRadius = 6*m6Scale;
    sureBtn.layer.masksToBounds = YES;
    [footerView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(700*m6Scale, 86*m6Scale));
        make.centerX.mas_equalTo(footerView.mas_centerX);
        make.top.mas_equalTo(58*m6Scale);
    }];
    
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92*m6Scale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 150*m6Scale;
}
/**
 *用户确认设置交易密码
 */
- (void)userSetPsw{
    PassGuardTextField *textFiled1 = (PassGuardTextField *)[self.view viewWithTag:1000];
    PassGuardTextField *textFiled2 = (PassGuardTextField *)[self.view viewWithTag:1001];
    
    NSLog(@"%@    %@", textFiled2.text, textFiled1.text);
    NSString *password = [textFiled1 getOutput1];
    if (textFiled1.text.length == 6) {
        if ([textFiled1.text isEqualToString:textFiled2.text]) {
            [DownLoadData postSetPaymentPs:^(id obj, NSError *error) {
                if ([obj[@"result"] isEqualToString:@"success"]) {
                    [Factory alertMes:@"交易密码设置成功"];
                    //反馈成功之后三秒返回到我的界面
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                        sleep(1);
                        //回到主队列
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSNotification *noti = [[NSNotification alloc] initWithName:@"sxyPushviewDismiss" object:nil userInfo:@{@"result":@"0"}];
                            [[NSNotificationCenter defaultCenter] postNotification:noti];
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    });
                }else{
                    [Factory alertMes:obj[@"messageText"]];
                }
            } userId:[HCJFNSUser stringForKey:@"userId"] factor:self.mcryptKey password:password];
        }else{
            [Factory alertMes:@"两次输入的交易密码不一致"];
        }
    }else{
        [Factory alertMes:@"交易密码长度不正确"];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

@end
