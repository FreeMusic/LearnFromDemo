//
//  NoticeListsVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/23.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "NoticeListsVC.h"
#import "NoticeListsCell.h"
#import "NoticeTrendsModel.h"
#import "FormValidator.h"
#import "NoticeDetailsVC.h"
#import "ActivityVC.h"

@interface NoticeListsVC ()<UITableViewDelegate, UITableViewDataSource, FactoryDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;//数据数组
@property (nonatomic, strong) NSMutableDictionary *dataDic;//数据字典
@property (nonatomic,strong) UIImageView *backImgView;//暂无数据背景图片
@property (nonatomic,assign) NSInteger page;//计算刷新的页数
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic,strong) NSMutableArray *muArray;//上拉加载的数组
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation NoticeListsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景颜色
    self.view.backgroundColor = backGroundColor;
    //导航栏不透明
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //添加标题
    self.title = @"公告动态";
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //加载tableView
    [self.view addSubview:self.tableView];
    //网络请求时时改变
    Factory *fatory = [[Factory alloc] init];
    fatory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    //请求数据
    [self pullDown];
}
/**
 *懒加载tableView
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20*m6Scale, -1, kScreenWidth-40*m6Scale, kScreenHeight-NavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = backGroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
/**
 *数据数组的懒加载
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
        [DownLoadData postGetAnnouncementList:^(id obj, NSError *error) {
            self.dataSource = obj[@"SUCCESS"];
            self.dataDic = obj[@"SUCCESS1"];
            //假如网络请求下来的没有数据
            if (self.dataSource.count == 0) {
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
            }
        } pageSize:@"10" pageNum:@"1"];
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
        [DownLoadData postGetAnnouncementList:^(id obj, NSError *error) {
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
        } pageSize:@"10" pageNum:[NSString stringWithFormat:@"%ld", (long)_page]];
    }
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
#pragma mark - <UITableViewDataSource>
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        static NSString *reuse = @"UITableView";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        }
        cell.textLabel.text = @"阅读全文";
        cell.selectionStyle = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = UIColorFromRGB(0x393939);
        cell.textLabel.font = [UIFont systemFontOfSize:28*m6Scale];
        
        return cell;
    }    else{
        static NSString *use = @"NoticeListsCell";
        NoticeListsCell *cell = [tableView dequeueReusableCellWithIdentifier:use];
        if (!cell) {
            cell = [[NoticeListsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:use];
        }
        cell.model = [self.dataSource objectAtIndexVerify:indexPath.section];
        
        return cell;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        return 90*m6Scale;
    }else{
        
        return 518*m6Scale;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NoticeTrendsModel *model = [self.dataSource objectAtIndexVerify:section];
    UIView *headView = [UIView new];
    headView.backgroundColor = backGroundColor;
    //头部公告时间
     UILabel  *sectiontimeLabel = [Factory CreateLabelWithTextColor:1 andTextFont:22 andText:@"" addSubView:headView];
    
    sectiontimeLabel.text = [Factory stdTimeyyyyMMddFromNumer:model.addtime andtag:77];
    sectiontimeLabel.textAlignment = NSTextAlignmentCenter;
    sectiontimeLabel.textColor = UIColorFromRGB(0xFFFFFF);
    sectiontimeLabel.backgroundColor = UIColorFromRGB(0xDEDEDE);
    sectiontimeLabel.layer.cornerRadius = 15*m6Scale;
    sectiontimeLabel.layer.masksToBounds = YES;
    [sectiontimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(284*m6Scale, 44*m6Scale));
        make.centerX.mas_equalTo(headView.mas_centerX);
        make.centerY.mas_equalTo(headView.mas_centerY);
    }];
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 112*m6Scale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeTrendsModel *model = [self.dataSource objectAtIndexVerify:indexPath.section];
    NoticeDetailsVC *tempVC = [NoticeDetailsVC new];
    tempVC.titleStr = model.name;//标题
    tempVC.time = [Factory stdTimeyyyyMMddFromNumer:model.addtime andtag:53];//时间
    tempVC.author = model.author;//作者
    tempVC.contents = model.content;//内容
    [self.navigationController pushViewController:tempVC animated:YES];
}
// 去掉UITableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 112*m6Scale;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏tabar
    [Factory hidentabar];
    //移除导航栏上的UIView
    [Factory navgation:self];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

@end
