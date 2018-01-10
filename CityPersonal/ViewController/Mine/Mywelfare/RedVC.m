//
//  RedVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "RedVC.h"
#import "RedCell.h"
#import "RedModel.h"
#import "HomeViewController.h"
#import "InviteFriendVC.h"
#import "BidCardFirstVC.h"
#import "ScanIdentityVC.h"

@interface RedVC ()<UITableViewDelegate, UITableViewDataSource,FactoryDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;//红包的数量
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;//刷新
@property (nonatomic, strong) UIView *backgroundImage;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) RedModel *model;//model层
@property (nonatomic, strong) NSMutableDictionary *dic1;
@property (nonatomic, strong) NSMutableArray *muArray;

@end

@implementation RedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    [self.view addSubview:self.tableView];
    
    //(121,196)
    _backgroundImage = [[UIView alloc]initWithFrame:CGRectMake((_tableView.frame.size.width -130)/2, (_tableView.frame.size.height -130)/2, 130, 130)];
    [self pullDown];//下拉刷新
    
    //网络请求实时改变
    Factory *factory = [[Factory alloc]init];
    factory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
        
}
#pragma mark - UITableView Lazyloading
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-120) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = backGroundColor;
        //去掉cell中的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 15*m6Scale;
    }
    return _tableView;
}
- (void)netWorkStateChanged{
    NSInteger state = [Factory checkNetwork];
    //当有网状态下请求数据
    if (state == 1 || state == 2) {
        [self serverData];
    }
}
//上拉加载
- (void)example11
{
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadNewData)];
}
//上拉加载
-(void)LoadNewData{
    NSUserDefaults *user = HCJFNSUser;
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
    }
    else {
        [DownLoadData postCouponTicketGold:^(id obj, NSError *error) {
            _dic1 = obj[@"SUCCESS1"];
            NSString *total = [NSString stringWithFormat:@"%@",_dic1[@"total"]];
            if (total.intValue <= 10) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                _page ++;
                NSString *str = [NSString stringWithFormat:@"%@",_dic1[@"isLastPage"]];
                if ([str isEqualToString:@"0"]) {
                    if (obj[@"SUCCESS"]) {
                        _muArray =[[NSMutableArray alloc]init];
                        _muArray = obj[@"SUCCESS"];
                        [_array addObjectsFromArray:_muArray];
                        [_tableView reloadData];
                        [_tableView.mj_footer endRefreshing];
                        _tableView.tableFooterView = [UIView new];
                    }
                }else  {
                    _muArray =[[NSMutableArray alloc]init];
                    _muArray = obj[@"SUCCESS"];
                    [_array addObjectsFromArray:_muArray];
                    [_tableView reloadData];
                    [_tableView.mj_footer endRefreshing];
                    _tableView.tableFooterView = [UIView new];
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
        } userId:[user objectForKey:@"userId"] andpageSize:@"10" andpageNum:[NSString stringWithFormat:@"%ld",(long)_page] andtype:0];
    }
}

//下拉刷新
- (void)pullDown
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(serverData)];
    [_tableView.mj_header beginRefreshing];
    
}
/**
 *  服务器数据
 */
- (void)serverData{
    NSUserDefaults *user = HCJFNSUser;
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
    } else {
        [DownLoadData postCouponTicketGold:^(id obj, NSError *error) {
            
            _array = obj[@"SUCCESS"];
            _dic1 = obj[@"SUCCESS1"];
            if (_array.count == 0) {
                _tableView.backgroundColor = backGroundColor;
                _backgroundImage.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"无数据"]];
                [_tableView addSubview:_backgroundImage];
                self.tableView.separatorStyle = NO;
                [_tableView.mj_header endRefreshing];
            }
            else {
                [_backgroundImage removeFromSuperview];
                [self.tableView reloadData];
//                self.tableView.backgroundColor = [UIColor whiteColor];
                self.tableView.separatorStyle = YES;
                NSString *total = [NSString stringWithFormat:@"%@",_dic1[@"total"]];
                if (total.intValue <= 10) {
                    
                } else {
                    [self example11];
                    [_tableView.mj_footer resetNoMoreData];
                    _tableView.mj_footer = _footer;
                    _footer.stateLabel.hidden = YES;
                    _page = 2;
                    _footer.stateLabel.hidden = NO;
                    
                }
                [_tableView.mj_header endRefreshing];
                _tableView.tableFooterView = [UIView new];
            }
        } userId:[user objectForKey:@"userId"] andpageSize:@"10" andpageNum:@"1" andtype:0];
    }
}
#pragma mark -numberOfSections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
#pragma mark -cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *string = HCJF;
    RedCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[RedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    //model层数据
    _model = _array[indexPath.section];
    [cell updateCellWithMyRedModel:_model andIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 295*m6Scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
#pragma mark -didSelect
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _model = _array[indexPath.section];
    
    if (_model.status.integerValue == 4) {
        
        InviteFriendVC *achieve = [InviteFriendVC new];
        [self.navigationController pushViewController:achieve animated:YES];
        
    }else{
        if (_model.status.integerValue == 1) {
            [Factory alertMes:@"红包已使用"];
        }else if (_model.status.integerValue == 3){
            [Factory alertMes:@"红包已过期"];
        }else{
            //魔库注册用户
            if ([_model.couponName isEqualToString:@"现金红包"]) {
                //判断用户是否实名绑卡
                [self userIsBindCard];
            }else{
                //发送通知，让用户跳转到理财页面
                NSNotification *notification = [[NSNotification alloc] initWithName:@"GoToInvest" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
}
/**
 *  判断用户是否实名绑卡
 */
- (void)userIsBindCard{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //实名前查询老用户实名信息
    [DownLoadData postRealNameInformation:^(id obj, NSError *error) {
        NSString *realName = [NSString stringWithFormat:@"%@", obj[@"realname"]];
        //首先根据realnameStatus该字段判断用户是否实名过
        NSString *status = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
        if (status.integerValue) {
            //用户实名过  判断他是否绑过卡
            [DownLoadData postGetBankByUserId:^(id obj, NSError *error) {
                [hud hideAnimated:YES];
                NSString *result = obj[@"result"];
                if ([result isEqualToString:@"success"]) {
                    //验证通过 发送通知，让用户跳转到理财页面
                    NSNotification *notification = [[NSNotification alloc] initWithName:@"GoToInvest" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else {
                    //跳转至绑定银行卡页面
                    BidCardFirstVC *tempVC = [BidCardFirstVC new];
                    tempVC.userName = realName;//用户真实姓名
                    [self.navigationController pushViewController:tempVC animated:YES];
                }
            } userId:[HCJFNSUser objectForKey:@"userId"]];
        }else{
            [hud hideAnimated:YES];
            NSString *identifyCard = [NSString stringWithFormat:@"%@", obj[@"identifyCard"]];
            NSString *realnameStatus = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
            //提示实名
            [self alertActionWithUserName:realName identifyCard:identifyCard status:realnameStatus];
        }
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *  提示用户去开户
 */
- (void)alertActionWithUserName:(NSString *)userName identifyCard:(NSString *)identifyCard status:(NSString *)status{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未实名，请您先去实名。" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ScanIdentityVC *tempVC = [ScanIdentityVC new];
        tempVC.userName = userName;
        tempVC.identifyCard = identifyCard;
        tempVC.realnameStatus = status;
        [weakSelf.navigationController pushViewController:tempVC animated:YES];
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
