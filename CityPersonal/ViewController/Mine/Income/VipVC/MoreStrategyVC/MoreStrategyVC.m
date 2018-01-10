//
//  MoreStrategyVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/4.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MoreStrategyVC.h"
#import "IntergralRecordVC.h"
#import "MoreStrategyCell.h"
#import "MoreStrategyModel.h"
#import "ScanIdentityVC.h"
#import "AutoBidSettingViewController.h"
#import "InviteFriendVC.h"
#import "IphoneVC.h"
#import "IntegralShopVC.h"
#import "MywelfareVC.h"

@interface MoreStrategyVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;//tableView头视图
@property (nonatomic, strong) UIView *line;//tableView头视图中间黑线
@property (nonatomic, strong) UISegmentedControl *segment;//日常任务和新手任务的选择条
@property (nonatomic, strong) UILabel *intergralLabel;//积分标签
@property (nonatomic, strong) NSString *type;//任务类型 2新手，3日常
@property (nonatomic,strong) NSMutableArray *dataArr;//模型数组
@property (nonatomic, assign) BOOL isSign;//记录用户是否已经签到过了

@end

@implementation MoreStrategyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"赚积分"];
    //查看积分记录按钮
    UIButton *rightBtn = [Factory addRightbottonToVC:self andImageName:@"jifenjilu"];;
    [rightBtn addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableView];
    self.type = @"3";
    //请求数据
    [self serviceData];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
/**
 *请求数据
 */
- (void)serviceData{
    //根据用户id和任务类型查询任务列表(2新手，3日常)
    [DownLoadData postGetMissions:^(id obj, NSError *error) {
        [self.dataArr removeAllObjects];
        self.dataArr = obj[@"SUCCESS"];
        [self.tableView reloadData];
    } userId:[HCJFNSUser stringForKey:@"userId"] type:self.type];
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
 *tableView自定义头视图的懒加载
 */
- (UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 330*m6Scale)];
        _headerView.backgroundColor = [UIColor whiteColor];
        //tableView头视图中间黑线
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 183*m6Scale, kScreenWidth, 1)];
        _line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
        [_headerView addSubview:_line];
        //当前积分标签
        UILabel *currentLabel = [Factory CreateLabelWithTextColor:0.6 andTextFont:30 andText:@"当前积分" addSubView:_headerView];
        [currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(40*m6Scale);
            make.centerX.mas_equalTo(_headerView.mas_centerX);
        }];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 310*m6Scale, kScreenWidth, 20*m6Scale)];
        [_headerView addSubview:backView];
        backView.backgroundColor = backGroundColor;
        //设置选择条
        [self settingSegment];
    }
    return _headerView;
}
/**
 *当前积分标签的懒加载
 */
- (UILabel *)intergralLabel{
    if(!_intergralLabel){
        _intergralLabel = [Factory CreateLabelWithTextColor:1 andTextFont:40 andText:@"6,666" addSubView:self.headerView];
        _intergralLabel.textColor = buttonColor;
        [_intergralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_headerView.mas_centerX);
            make.bottom.mas_equalTo(_line.mas_top).offset(-40*m6Scale);
        }];
    }
    
    return _intergralLabel;
}
/**
 *选择条
 */
- (void)settingSegment{
    //标题
    _segment = [[UISegmentedControl alloc] initWithItems:@[@"日常任务", @"新手任务"]];
    _segment.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:_segment];
    [_segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50*m6Scale);
        make.top.mas_equalTo(_line.mas_bottom).offset(22*m6Scale);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 100*m6Scale, 80*m6Scale));
    }];
    //宽度设置
    _segment.width = kScreenWidth - 100*m6Scale;
    //默认选择
    _segment.selectedSegmentIndex = 0;
    //点击事件
    [_segment addTarget:self action:@selector(segmentBtnClick:) forControlEvents:UIControlEventValueChanged];
    _segment.tintColor = ButtonColor;
}
/**
 *选择条的点击事件
 */
- (void)segmentBtnClick:(UISegmentedControl *)sender{
    //改变点击模块的颜色
    _segment.tintColor = ButtonColor;
    self.type = (sender.selectedSegmentIndex > 0) ? @"2" : @"3";
    [self serviceData];
}
/**
 *查看积分记录按钮点击事件
 */
- (void)rightButtonClick{
    IntergralRecordVC *tempVC = [IntergralRecordVC new];
    
    [self.navigationController pushViewController:tempVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reStr = @"MoreStrategyCell";
    MoreStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:reStr];
    if (!cell) {
        cell = [[MoreStrategyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reStr];
    }
    [cell cellForModel:self.dataArr[indexPath.row] andType:1];
    MoreStrategyModel *model = self.dataArr[indexPath.row];
    if (model.integralType.integerValue == 7) {
        if (self.isSign) {
            cell.rightLabel.text = @"已完成";
            cell.rightLabel.backgroundColor = ButtonColor;
            cell.userInteractionEnabled = NO;
        }else{
            cell.rightLabel.text = @"赚积分";
            cell.rightLabel.backgroundColor = UIColorFromRGB(0xFF6935);
        }
    }

  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 144*m6Scale;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //用户当前积分
    self.intergralLabel.text = [Factory countNumAndChange:self.intergral];
    
    return self.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 330*m6Scale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", indexPath.row);
    MoreStrategyModel *model = self.dataArr[indexPath.row];
    NSString *integralType = [NSString stringWithFormat:@"%@", model.integralType];
    switch (integralType.integerValue) {
        case 1:{
            //实名
            ScanIdentityVC *tempVC = [ScanIdentityVC new];
            [self.navigationController pushViewController:tempVC animated:YES];
        }
            break;
        case 2:{
            //邀请好友
            InviteFriendVC *tempVC = [InviteFriendVC new];
            [self.navigationController pushViewController:tempVC animated:YES];
        }
            break;
        case 3:{
            //首次开启自动投标
            AutoBidSettingViewController *tempVC = [AutoBidSettingViewController new];
            [self.navigationController pushViewController:tempVC animated:YES];
        }
            
            break;
        case 4:{
            //设置锁投
            IphoneVC *tempVC = [IphoneVC new];
            [self.navigationController pushViewController:tempVC animated:YES];
            
            
//            NSNotification *notification = [[NSNotification alloc] initWithName:@"GoToInvest" object:nil userInfo:@{@"selectIndex":@"3"}];
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//            
//            [self.navigationController popToRootViewControllerAnimated:NO];
        }
            break;
        case 5:{
            //投资
            NSNotification *notification = [[NSNotification alloc] initWithName:@"GoToInvest" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
            break;
        case 6:{//积分商城消费
            //积分商城
            ClipActivityController *strVC = [ClipActivityController new];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strVC.navigationController.view animated:YES];
            //兑吧免登陆接口
            [DownLoadData postLogFreeUrl:^(id obj, NSError *error) {
                [hud hideAnimated:YES];
                IntegralShopVC *tempVC = [IntegralShopVC new];
                tempVC.strUrl = obj[@"ret"];
                [strVC.navigationController pushViewController:tempVC animated:YES];
            } userId:[HCJFNSUser stringForKey:@"userId"] redicrect:@""];
        }
            break;
        case 7:{//签到
            //调用签到接口
            [DownLoadData postGetMemberPicture:^(id obj, NSError *error) {
                if ([obj[@"result"] isEqualToString:@"success"]) {
                    [Factory addAlertToVC:self withMessage:obj[@"remark"]];
                    self.isSign = YES;
                    NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    [Factory addAlertToVC:self withMessage:obj[@"messageText"]];
                }
            } userId:[HCJFNSUser stringForKey:@"userId"]];
        }
            break;
        case 8:{
            //活动福利
            MywelfareVC *tempVC = [MywelfareVC new];
            [self.navigationController pushViewController:tempVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:navigationColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}
@end
