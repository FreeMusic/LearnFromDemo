//
//  MyBankCardVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyBankCardVC.h"
#import "MyBankCardCell.h"
#import "BidCardFirstVC.h"
#import "BankListModel.h"
#import "RechargeView.h"
#import "DealPswVC.h"

@interface MyBankCardVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;//银行卡列表数据数组
@property (nonatomic, strong) RechargeView *rechargeView;//交易密码输入框
@property (nonatomic, strong) NSString *bankId;//银行卡ID

@end

@implementation MyBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"我的银行卡"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    //交易密码输入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sxyRecharge:) name:@"sxyRecharge" object:nil];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = backGroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
/**
 *银行卡列表数据数组
 */
- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}
- (void)onClickLeftItem{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
/**
 *请求用户银行卡列表
 */
- (void)getListByUserId{
    //用户银行卡列表
    [DownLoadData postGetListByUserId:^(id obj, NSError *error) {
        [self.dataSource removeAllObjects];
        self.dataSource = obj[@"SUCCESS"];
        [self.tableView reloadData];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuse = @"MyBankCardCell";
    MyBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[MyBankCardCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    [cell cellForModel:self.dataSource[indexPath.row]];
    [cell.unBindBtn addTarget:self action:@selector(unbindBankCard:) forControlEvents:UIControlEventTouchUpInside];
    cell.unBindBtn.tag = indexPath.row+100;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 237*m6Scale;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [UIView new];
    //添加银行卡按钮
    UIButton *addBtn = [UIButton buttonWithType:0];
    [addBtn setImage:[UIImage imageNamed:@"添加银行卡"] forState:0];
    [addBtn addTarget:self action:@selector(skipToBidBankCard) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(688*m6Scale, 88*m6Scale));
        make.centerX.mas_equalTo(footerView.mas_centerX);
        make.top.mas_equalTo(32*m6Scale);
    }];
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 120*m6Scale;
}
/**
 *解绑银行卡
 */
- (void)unbindBankCard:(UIButton *)sender{
    //解绑银行卡接口
    BankListModel *model = self.dataSource[sender.tag-100];
    //银行卡ID
    self.bankId = [NSString stringWithFormat:@"%@", model.ID];
    self.rechargeView.hidden = NO;
    [self.rechargeView.myTextFiled becomeFirstResponder];
    
}
- (void)sxyRecharge:(NSNotification *)noti{
    //加密因子
    NSString *mcryptKey = noti.userInfo[@"mcryptKey"];
    //加密码
    NSString *passWord = noti.userInfo[@"passWord"];
    //解绑银行卡接口
    [DownLoadData postUnbindCard:^(id obj, NSError *error) {
        if ([obj[@"result"] isEqualToString:@"fail"]) {
            self.rechargeView.hidden = YES;
            [self.rechargeView.myTextFiled resignFirstResponder];
            self.rechargeView.myTextFiled.text = @"";
            if ([obj[@"messageText"] isEqualToString:@"密码错误"]) {
                [self alterUserPswError];
            }else{
                [Factory addAlertToVC:self withMessage:obj[@"messageText"]];
            }
        }else{
            [Factory alertMes:@"您已解绑成功"];
            
            //反馈成功之后三秒返回到我的界面
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                sleep(1.0);
                //回到主队列
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.rechargeView.hidden = YES;
                    [self.rechargeView.myTextFiled resignFirstResponder];
                    self.rechargeView.myTextFiled.text = @"";
                    //用户银行卡列表
                    [self getListByUserId];
                });
            });
        }
    } userId:[HCJFNSUser stringForKey:@"userId"] bankId:self.bankId password:passWord mcryptKey:mcryptKey];
    
}
/**
 *提示用户交易密码输入错误
 */
- (void)alterUserPswError{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您输入的交易密码错误" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"忘记密码" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        DealPswVC *tempVC = [DealPswVC new];
        [self.navigationController pushViewController:tempVC animated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.rechargeView.hidden = NO;
        [self.rechargeView.myTextFiled becomeFirstResponder];
        
        [self.view endEditing:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 *输入交易密码弹出视图
 */
- (RechargeView *)rechargeView{
    if(!_rechargeView){
        _rechargeView = [[RechargeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _rechargeView.amountLabel.hidden = YES;
        _rechargeView.styleLabel.text = @"解绑银行卡";
        
        [[UIApplication sharedApplication].keyWindow addSubview:_rechargeView];
    }
    return _rechargeView;
}
/**
 *跳转至绑定银行卡界面
 */
- (void)skipToBidBankCard{
    BidCardFirstVC *tempVC = [BidCardFirstVC new];
    tempVC.index = 5;
    tempVC.userName = self.userName;//用户名字
    [self.navigationController pushViewController:tempVC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //用户银行卡列表
    [self getListByUserId];
}

@end
