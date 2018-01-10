//
//  FinishOrderVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/31.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "FinishOrderVC.h"
#import "MyOrderCell.h"
#import "OrderDetailsVC.h"
#import "OrderVC.h"
#import "FinishOrderDetailsVC.h"
#import "LogisticsInfoVC.h"
#import "OrderDetailsModel.h"

@interface FinishOrderVC ()<UITableViewDelegate, UITableViewDataSource, FactoryDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *userLabel;//用户名
@property (nonatomic, strong) NSMutableArray *dataSource;//数据数组
@property (nonatomic, strong) NSMutableDictionary *dataDic;//数据字典
@property (nonatomic,strong) UIImageView *backImgView;//暂无数据背景图片
@property (nonatomic,assign) NSInteger page;//计算刷新的页数
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic,strong) NSMutableArray *muArray;//上拉加载的数组
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, strong) MyOrderCell *cell;

@end

@implementation FinishOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //网络请求时时改变
    Factory *fatory = [[Factory alloc] init];
    fatory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = backGroundColor;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0*m6Scale, kScreenWidth, kScreenHeight-90*m6Scale-NavigationBarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = Colorful(235, 234, 241);
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[MyOrderCell class] forCellReuseIdentifier:@"MyOrderCell"];
    }
    return _tableView;
}
/**
 *数据数组懒加载
 */
- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
/**
 *数据字典的懒加载
 */
- (NSMutableDictionary *)dataDic{
    if(!_dataDic){
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
/**
 *请求数据
 */
- (void)serviceData{
    
}
/**
 *我的订单列表数据请求
 */
- (void)GetOrderLists{
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
        //没有网络的时候提示网络出错
        //没有网络停止刷新
        [_tableView.mj_header endRefreshing];
    }else{
        [DownLoadData postGetMyOrderLists:^(id obj, NSError *error) {
            
            [self.dataDic removeAllObjects];
            [self.dataSource removeAllObjects];
            self.dataSource = obj[@"SUCCESS"];
            self.dataDic = obj[@"SUCCESS1"];
            //假如网罗求情下来的没有数据
            if (_dataSource.count == 0) {
                //防止突然没有数据 导致暂无内容图和数据交叉
                [self.tableView reloadData];
                self.backImgView.hidden = NO;
                _tableView.mj_footer.hidden = YES;
                
                [_tableView.mj_header endRefreshing];
            }else{
                _tableView.mj_footer.hidden = NO;
                self.backImgView.hidden = YES;
                [self.tableView reloadData];
                NSString *total = [NSString stringWithFormat:@"%@",_dataDic[@"total"]];
                if (total.integerValue <= 10) {
                    
                }else{
                    [self pullup];
                    [_tableView.mj_footer resetNoMoreData];
                    _tableView.mj_footer = _footer;
                    _footer.stateLabel.hidden = YES;
                    _page = 2;
                    _footer.stateLabel.hidden = NO;
                }
                [_tableView.mj_header endRefreshing];
                _tableView.tableFooterView = [UIView new];
                [self.tableView reloadData];
            }
        } pageNum:@"1" pageSize:@"10" status:[NSString stringWithFormat:@"%d", 1] userId:[HCJFNSUser stringForKey:@"userId"]];
    }
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
        [self GetOrderLists];
    }
}
#pragma mark - 下拉刷新数据
- (void)pullDown{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(GetOrderLists)];
    [_tableView.mj_header beginRefreshing];
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
        [DownLoadData postGetMyOrderLists:^(id obj, NSError *error) {
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
                        [self.dataSource addObjectsFromArray:_muArray];
                        [_tableView reloadData];
                        [_tableView.mj_footer endRefreshing];
                        _tableView.tableFooterView = [UIView new];
                    }
                }else{
                    //是最后一页
                    _muArray =[[NSMutableArray alloc]init];
                    _muArray = obj[@"SUCCESS"];
                    [self.dataSource addObjectsFromArray:_muArray];
                    [_tableView reloadData];
                    [_tableView.mj_footer endRefreshing];
                    _tableView.tableFooterView = [UIView new];
                    _footer.stateLabel.hidden = NO;
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                    _footer.stateLabel.hidden = YES;
                }
            }
        } pageNum:[NSString stringWithFormat:@"%ld",_page] pageSize:@"10" status:[NSString stringWithFormat:@"%d", 1] userId:[HCJFNSUser stringForKey:@"userId"]];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderCell"];
    _cell.btn.tag = 200+indexPath.row;
    [_cell.btn addTarget:self action:@selector(PayForGoodsClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cell cellForModel:self.dataSource[indexPath.row]];
    
    return _cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 330*m6Scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderModel *model = self.dataSource[indexPath.row];
    FinishOrderDetailsVC *tempVC = [FinishOrderDetailsVC new];
    tempVC.kindID = [NSString stringWithFormat:@"%@", model.kindId];//kindId
    tempVC.number = [NSString stringWithFormat:@"%@", model.goodsNum];//商品数量
    tempVC.type = 1;//订单确认页面的数据获取方式是顺值
    tempVC.orderNo = [NSString stringWithFormat:@"%@", model.orderNo];//商品定单编号
    
    [self.navigationController pushViewController:tempVC animated:YES];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *物流信息点击事件
 */
- (void)PayForGoodsClick:(UIButton *)sender{
    MyOrderModel *model = self.dataSource[sender.tag-200];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DownLoadData postGetOrderDetails:^(id obj, NSError *error) {
        [hud setHidden:YES];
        OrderDetailsModel *model = obj[@"model"];
        //订单编号
        NSString *logisticsOrderNo = [NSString stringWithFormat:@"%@", model.logisticsOrderNo];
        NSLog(@"%@", logisticsOrderNo);
        if ([logisticsOrderNo isEqualToString:@"(null)"]) {
            [Factory addAlertToVC:self withMessage:@"暂无物流信息"];
        }else{
            LogisticsInfoVC *tempVC = [LogisticsInfoVC new];
            tempVC.logisticsType = [NSString stringWithFormat:@"%@", model.logisticsType];
            tempVC.logisticsOrderNo = logisticsOrderNo;
            [self.navigationController pushViewController:tempVC animated:YES];
        }
        
    } orderNo:[NSString stringWithFormat:@"%@", model.orderNo]];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self pullDown];
    
}

@end
