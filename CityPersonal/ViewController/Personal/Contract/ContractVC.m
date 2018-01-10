//
//  ContractVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/20.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ContractVC.h"
#import "ContractTCell.h"
#import "ContractModel.h"

@interface ContractVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;//刷新
@property (nonatomic, strong) NSMutableArray *dataArr; //数据数组
@property (nonatomic, strong) UIView *backgroundImage;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic ,strong) NSTimer *paintingTimer;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, strong) NSString *contractNum;//合同编号

@end

@implementation ContractVC {
    NSMutableDictionary *_dic1;
    NSMutableArray *_muArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //导航栏设置
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"合同查看"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    //tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-120*m6Scale) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate  = self;
    _tableView.backgroundColor = backGroundColor;
    _tableView.separatorColor = SeparatorColor;
    [self.view addSubview:_tableView];
    
    //暂无数据背景图
    _backgroundImage = [[UIView alloc]initWithFrame:CGRectMake((_tableView.frame.size.width -130)/2, (_tableView.frame.size.height -130)/2, 130, 130)];
    //下拉刷新
    [self pullDown];
    
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
////查看
//-(void)checkLook {
//    NSLog(@"%@",_contractNum);
//    [DownLoadData postContractsSee:^(id obj, NSError *error) {
//        NSLog(@"%@",obj);
//    } orderNo:_contractNum];
//    
//}
#pragma mark - 懒加载
- (NSMutableArray *)dataArr {
    
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

//下拉刷新
- (void)pullDown {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    
}
//上拉加载
- (void)pullUp {
    
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
//下拉刷新
- (void)loadData {
    
    //23333
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
    } else {
        [DownLoadData postContractsList:^(id obj, NSError *error) {
            
            if (!error) {
                self.flag = NO;
                self.dataArr = obj[@"modelArr"];
                _dic1 = obj[@"paginator"];
                if (_dataArr.count == 0) {
                    _backgroundImage.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"无数据"]];
                    [_tableView addSubview:_backgroundImage];
                    self.tableView.separatorStyle = NO;
                    [_tableView.mj_header endRefreshing];
                } else {
                    [_backgroundImage removeFromSuperview];
                    [self.tableView reloadData];
//                    self.tableView.backgroundColor = [UIColor whiteColor];
                    self.tableView.separatorStyle = YES;
                    NSString *total = [NSString stringWithFormat:@"%@",_dic1[@"total"]];
                    if (total.intValue <= 10) {
                        
                    } else {
                        [self pullUp];
                        [_tableView.mj_footer resetNoMoreData];
                        _tableView.mj_footer = _footer;
                        _footer.stateLabel.hidden = YES;
                        _pageNum = 2;
                        _footer.stateLabel.hidden = NO;
                    }
                    [_tableView.mj_header endRefreshing];
                    _tableView.tableFooterView = [UIView new];
                }
            }
            else {
                [Factory showNoDataHud];
                //数据请求失败，返回上一级
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } userId:[user objectForKey:@"userId"] pageNum:1 pageSize:10];
    }
}
//上拉加载
- (void)loadMoreData {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
    }
    else {
        [DownLoadData postContractsList:^(id obj, NSError *error) {
            if (!error) {
                self.flag = NO;
                _dic1 = obj[@"paginator"];
                NSString *total = [NSString stringWithFormat:@"%@",_dic1[@"total"]];
                if (total.intValue <= 10) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    _pageNum ++;
                    NSString *str = [NSString stringWithFormat:@"%@",_dic1[@"isLastPage"]];
                    if ([str isEqualToString:@"0"]) {
                        if (obj[@"modelArr"]) {
                            _muArray =[[NSMutableArray alloc]init];
                            _muArray = obj[@"modelArr"];
                            [_dataArr addObjectsFromArray:_muArray];
                            [_tableView reloadData];
                            [_tableView.mj_footer endRefreshing];
                            _tableView.tableFooterView = [UIView new];
                        }
                    }else  {
                        _muArray =[[NSMutableArray alloc]init];
                        _muArray = obj[@"modelArr"];
                        [_dataArr addObjectsFromArray:_muArray];
                        [_tableView reloadData];
                        [_tableView.mj_footer endRefreshing];
                        _tableView.tableFooterView = [UIView new];
                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
            }
            else {
                [Factory showNoDataHud];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } userId:[user objectForKey:@"userId"] pageNum:self.pageNum pageSize:10];
    }
}
#pragma mark -numberOfSectionsInTableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
#pragma mark -cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *str = @"HCJF";
    ContractTCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[ContractTCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   
    cell.model = self.dataArr[indexPath.section];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300*m6Scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 18*m6Scale;
}
#pragma mark -didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContractModel *model = self.dataArr[indexPath.section];
    NSLog(@"%@-------%@",model.serialNumber,model.itemName);
        AchieveVC *achieve = [AchieveVC new];
        achieve.acTag = 5;
        achieve.orderNO = model.serialNumber;
        achieve.titileStr = model.itemName;
        achieve.urlStr = model.url;
        [self.navigationController pushViewController:achieve animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [Factory navgation:self];
    [Factory hidentabar];
    [[UINavigationBar appearance] setBarTintColor:navigationColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
