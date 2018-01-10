//
//  CarTradeVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/8.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "CarTradeVC.h"
#import "CityWalletCell.h"
#import "ItemTypeVC.h"

@interface CarTradeVC ()<UITableViewDelegate, UITableViewDataSource, FactoryDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;//模型数组
@property (nonatomic,strong) NSMutableDictionary *dataDic;//模型字典
@property (nonatomic,strong) UIImageView *backImgView;//暂无数据背景图片
@property (nonatomic,assign) NSInteger page;//计算刷新的页数
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic,strong) NSMutableArray *muArray;//上拉加载的数组
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, copy) NSString *appointTime;//预约时间
@end

@implementation CarTradeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    [self.view addSubview:self.tableView];
    
    //网络请求时时改变
    Factory *fatory = [[Factory alloc] init];
    fatory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    
    //停止刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRefresh) name:@"stopRefresh" object:nil];
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-(90*m6Scale+44+NavigationBarHeight)) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 20*m6Scale;
        _tableView.backgroundColor = backGroundColor;
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
 *模型字典的懒加载
 */
- (NSMutableDictionary *)dataDic{
    if(!_dataDic){
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
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
#pragma mark - 下拉刷新数据
- (void)pullDown{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(serviceData)];
    [_tableView.mj_header beginRefreshing];
}
/**
 *请求数据
 */
- (void)serviceData{
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
        //没有网络的时候提示网络出错
        //没有网络停止刷新
        [_tableView.mj_header endRefreshing];
    }else{
        [DownLoadData postList:^(id obj, NSError *error) {
            self.dataArr = obj[@"SUCCESS"];
            self.dataDic = obj[@"SUCCESS1"];
            //假如网罗求情下来的没有数据
            if (_dataArr.count == 0) {
                _tableView.mj_footer.hidden = YES;
                //防止突然没有数据 导致暂无内容图和数据交叉
                [self.tableView reloadData];
                self.backImgView.hidden = NO;
                
                [_tableView.mj_header endRefreshing];
                self.tableView.mj_footer.hidden = YES;
            }else{
                _tableView.mj_footer.hidden = NO;
                self.backImgView.hidden = YES;
                [self.tableView reloadData];
                NSString *total = [NSString stringWithFormat:@"%@",_dataDic[@"total"]];
                if (total.integerValue <= 10) {
                    self.tableView.mj_footer.hidden = YES;
                }else{
                    _tableView.mj_footer.hidden = NO;
                    [self pullup];
                    [_tableView.mj_footer resetNoMoreData];
                    _tableView.mj_footer = _footer;
                    _footer.stateLabel.hidden = YES;
                    _page = 2;
                    _footer.stateLabel.hidden = NO;
                }
                [_tableView.mj_header endRefreshing];
                _tableView.tableFooterView = [UIView new];
            }
        } pageNum:@"1" pageSize:@"10" itemStatus:self.itemStatus itemType:@"2"];
    }
}
#pragma mark - 上拉加载数据
- (void)pullup{
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}
#pragma mark - 上拉加载
- (void)loadData{
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
    }else{
        [DownLoadData postList:^(id obj, NSError *error) {
            _dataDic = obj[@"SUCCESS1"];
            NSString *total = [NSString stringWithFormat:@"%@",_dataDic[@"total"]];
            if (total.integerValue <= 10) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                _page++;
                NSString *str = [NSString stringWithFormat:@"%@", _dataDic[@"isLastPage"]];
                if ([str isEqualToString:@"0"]) {
                    //不是最后一页
                    if (obj[@"SUCCESS"]) {
                        _muArray = [[NSMutableArray alloc] init];
                        _muArray = obj[@"SUCCESS"];
                        [_dataArr addObjectsFromArray:_muArray];
                        [_tableView reloadData];
                        [_tableView.mj_footer endRefreshing];
                        _tableView.tableFooterView = [UIView new];
                    }
                }else{
                    //是最后一页
                    _muArray =[[NSMutableArray alloc]init];
                    _muArray = obj[@"SUCCESS"];
                    [_dataArr addObjectsFromArray:_muArray];
                    [_tableView reloadData];
                    [_tableView.mj_footer endRefreshing];
                    _tableView.tableFooterView = [UIView new];
                    _footer.stateLabel.hidden = NO;
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                    _footer.stateLabel.hidden = YES;
                }
            }
        } pageNum:[NSString stringWithFormat:@"%ld", (long)_page] pageSize:@"10" itemStatus:self.itemStatus itemType:@"2"];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CarTradeVC = @"CarTradeVC";
    CityWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:CarTradeVC];
    if (!cell) {
        cell = [[CityWalletCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CarTradeVC];
    }
    cell.appointBtn.tag = 100+indexPath.row;
    [cell.appointBtn addTarget:self action:@selector(appointButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell cellForModel:self.dataArr[indexPath.row]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 248*m6Scale;
}
/**
 *预约按钮
 */
- (void)appointButtonClick:(UIButton *)sender{
    MoneyListModel *model = self.dataArr[sender.tag - 100];
    if ([HCJFNSUser stringForKey:@"userId"]) {
        if ([model.appointId integerValue] == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您是否开启预约标" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"预约按钮%ld", sender.tag);
                [DownLoadData postAppointBid:^(id obj, NSError *error) {
                    if ([obj[@"result"] isEqualToString:@"success"]) {
                        [Factory alertMes:@"预约成功"];
                        self.appointTime = [NSString stringWithFormat:@"%@",obj[@"time"]];
                        if ([self.appointTime doubleValue]==0) {
                            self.appointTime = @"1";
                        }
                         [self LocalNotice:[model.ID stringValue]];
                        [self.tableView.mj_header beginRefreshing];
                    }
                    else{
                        [Factory alertMes:obj[@"messageText"]];
                    }
                } userId:[defaults objectForKey:@"userId"] itemId:[NSString stringWithFormat:@"%@",model.ID]];
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            [Factory alertMes:@"该标您已经预约过了"];
        }
    }else{
        [Factory alertMes:@"您还未登录"];
    }
}
//创建本地推送
- (void)LocalNotice :(NSString *)itemId{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:@"您有一条新通知" arguments:nil];
        content.body = [NSString localizedUserNotificationStringForKey:@"您预约的标开启时间到了"
                                                             arguments:nil];
        content.sound = [UNNotificationSound defaultSound];
        
        // 在 alertTime 后推送本地推送
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:[self.appointTime doubleValue] repeats:NO];
        
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:itemId
                                                                              content:content trigger:trigger];
        //添加推送成功后的处理！
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"添加了10推送");
        }];
        
        
    }
    else{
        UILocalNotification *localNotice = [[UILocalNotification alloc]init];
        localNotice.fireDate = [NSDate dateWithTimeIntervalSinceNow:[self.appointTime doubleValue]];
        localNotice.alertBody = @"您预约的标开启时间到了";
        localNotice.alertTitle = @"您有一条新通知";
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotice];
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemTypeVC *tempVC = [ItemTypeVC new];
    MoneyListModel *model = self.dataArr[indexPath.row];
    tempVC.itemId = [NSString stringWithFormat:@"%@", model.ID];//项目ID
    tempVC.itemStatus = model.itemStatus;//标状态
    tempVC.itemNameText = model.itemName;//标标题
    tempVC.dataStr = [NSString stringWithFormat:@"%@开抢", [Factory stdTimeyyyyMMddFromNumer:model.releaseTime andtag:4]];
    [self.navigationController pushViewController:tempVC animated:YES];
}
- (void)compareSelegentServiceData{
    //请求数据
    [self serviceData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求数据
    [self pullDown];
}
/**
 *stopRefresh停止刷新
 */
- (void)stopRefresh{
    [_tableView.mj_header endRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.tableView.mj_header endRefreshing];
}

@end
