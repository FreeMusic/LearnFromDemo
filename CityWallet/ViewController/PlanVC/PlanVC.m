//
//  PlanVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PlanVC.h"
#import "PlanCell.h"
#import "AutoBidSettingViewController.h"
#import "ActivityVC.h"
#import "PlanSettingVC.h"
#import "BidCardVC.h"
#import "ScanIdentityVC.h"
#import "NewSignVC.h"

@interface PlanVC ()<UITableViewDelegate, UITableViewDataSource, FactoryDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;//模型数组
@property (nonatomic,strong) UIImageView *backImgView;//暂无数据背景图片
@property (nonatomic,assign) NSInteger page;//计算刷新的页数
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic,strong) NSMutableArray *muArray;//上拉加载的数组
@property (nonatomic, strong) Reachability *conn;

@end

@implementation PlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    //网络请求时时改变
    Factory *fatory = [[Factory alloc] init];
    fatory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    
    self.view.backgroundColor = backGroundColor;
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-(90*m6Scale+NavigationBarHeight)) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(serviceData)];
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 20*m6Scale;
        _tableView.contentInset = UIEdgeInsetsMake(-50*m6Scale, 0, 0, 0);
    }
    return _tableView;
}
/**
 *模型数组的懒加载
 */
- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
/**
 *暂无数据背景图片的懒加载
 */
- (UIImageView *)backImgView{
    if(!_backImgView){
        _backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无数据"]];
        [self.tableView addSubview:_backImgView];
        [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(260*m6Scale, 260*m6Scale));
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(kScreenHeight/4);
        }];
    }
    return _backImgView;
}
#pragma mark - 网络情况监控
- (void)netWorkStateChanged{
    NSInteger state = [Factory checkNetwork];
    //有网络的情况下请求数据
    if (state == 1 || state == 2) {
        [self serviceData];
    }
}


/**
 *请求数据
 */
- (void)serviceData{
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
         [_tableView.mj_header endRefreshing];
    }else{
        [DownLoadData postGetWalletLists:^(id obj, NSError *error) {
            [_tableView.mj_header endRefreshing];
            [self.dataArr removeAllObjects];
            self.dataArr = obj[@"SUCCESS"];
            
            [self.tableView reloadData];
        } isDelete:@"0"];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *SelectedVC = @"SelectedVC";
    PlanCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectedVC];
    if (!cell) {
        cell = [[PlanCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SelectedVC];
    }
    
    [cell cellForModel:self.dataArr[indexPath.section]];
    [cell.btn addTarget:self action:@selector(skipToAutoVC) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 228*m6Scale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlanModel *model = self.dataArr[indexPath.section];
    if (indexPath.section == 3) {
        
    }else{
        if (model.planCycle.integerValue) {
            if ([HCJFNSUser stringForKey:@"userId"]) {
                PlanSettingVC *tempVC = [PlanSettingVC new];
                tempVC.planId = [NSString stringWithFormat:@"%@", model.ID];//planID
                tempVC.title = [NSString stringWithFormat:@"%@", model.planName];
                [self.navigationController pushViewController:tempVC animated:YES];
            }else{
                [Factory alertMes:@"请您先登录"];
            }
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3) {
        UIView *backView  = [UIView new];
        UILabel *label = [Factory CreateLabelWithTextColor:0.5 andTextFont:26 andText:@"资金不站岗，收益节节高" addSubView:backView];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(backView.mas_centerX);
            make.centerY.mas_equalTo(backView.mas_centerY);
        }];
        
        return backView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        CGFloat height = kScreenHeight-(90*m6Scale+NavigationBarHeight) - 248*m6Scale*4;
        
        return height;
    }else{
        return 0;
    }
}

/**
 *跳转至自动投标页面
 */
- (void)skipToAutoVC{
    if ([HCJFNSUser stringForKey:@"userId"]) {
        //用户已经登录
        [self login];
    }else{
        //提示用户登录
        [self alterUserLogin];
    }
}
/**
 *用户已登录 执行用户实名查询接口
 */
- (void)login{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //实名前查询老用户实名信息
    [DownLoadData postRealNameInformation:^(id obj, NSError *error) {
        //首先根据realnameStatus该字段判断用户是否实名过
        NSString *status = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
        if (status.integerValue) {
            //用户实名过  判断他是否绑过卡
            [DownLoadData postBankMessage:^(id obj, NSError *error) {
                [hud hideAnimated:YES];
                NSString *result = obj[@"result"];
                if ([result isEqualToString:@"success"]) {
                    //跳转自动投标界面
                    AutoBidSettingViewController *autoVC = [AutoBidSettingViewController new];
                    [self.navigationController pushViewController:autoVC animated:YES];
                }else {
                    //提示用户去绑卡
                    [self alert];
                }
            } userId:[HCJFNSUser objectForKey:@"userId"]];
        }else{
            [hud hideAnimated:YES];
            //提示绑卡
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您尚未实名，是否立刻去实名?" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //当用户想要去实名认证的时候.需要获得用户的名字和身份证号
                NSString *realName = [NSString stringWithFormat:@"%@", obj[@"realname"]];
                NSString *identifyCard = [NSString stringWithFormat:@"%@", obj[@"identifyCard"]];
                NSString *realnameStatus = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                ScanIdentityVC *tempVC = [ScanIdentityVC new];
                tempVC.userName = realName;//用户名字
                tempVC.identifyCard = identifyCard;//用户身份证号
                tempVC.realnameStatus = realnameStatus;//用户实名的状态 0未实名 1实名
                [self.navigationController pushViewController:tempVC animated:YES];
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *用户未登录 提示用户去登陆
 */
- (void)alterUserLogin{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，是否立刻登录？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NewSignVC *signVC = [[NewSignVC alloc] init];
        signVC.presentTag = @"2";
        [self presentViewController:signVC animated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 是否绑卡提示
 */
- (void)alert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您尚未绑卡，是否立刻绑定银行卡?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转至绑定银行卡页面
        BidCardVC *tempVC = [BidCardVC new];
        [self.navigationController pushViewController:tempVC animated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)compareSelegentServiceData{
    //请求数据
    [self serviceData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求数据
    [self.tableView.mj_header beginRefreshing];
}
@end
