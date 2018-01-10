//
//  VipEquityVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/4.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "VipEquityVC.h"
#import "EquityHeaderCell.h"
#import "EquityBottomCell.h"
#import "PushView.h"
#import "ActivityCenterVC.h"

@interface VipEquityVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UINavigationBar *QYnavBar;
@property (nonatomic, strong) UITableView *tableView;//
@property (nonatomic, strong) NSArray *equityArr;//会员权益数组
@property (nonatomic, strong) NSDictionary *yearAmountDic;//等级年化收益字典
@property (nonatomic, strong) PushView *pushView;//点击会员权益的弹出视图

@end

@implementation VipEquityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TitleLabelStyle addtitleViewToMyVC:self withTitle:@"会员权益"];
    
    self.navigationController.navigationBar.translucent = YES;
    //右边按钮
    UIButton *rightBtn = [Factory addRightbottonToVC:self];
    [rightBtn addTarget:self action:@selector(helpCenter) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    
    //请求数据
    [self serviceData];
    //接受弹出视图的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PushView:) name:@"PushView" object:nil];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(-NavigationBarHeight, 0, 0, 0);
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
/**
 *点击会员权益的弹出视图
 */
- (PushView *)pushView{
    if(!_pushView){
        _pushView = [[PushView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        [self.view addSubview:_pushView];
    }
    return _pushView;
}
/**
 *请求数据
 */
- (void)serviceData{
    //不同等级需要年化门槛
    [DownLoadData postGetMemberGrade:^(id obj, NSError *error) {
        _yearAmountDic = obj[@"ret"];
        //刷新某一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        //会员权益模块
        [self getMemberGrade];
    }];
}
/**
 *会员权益模块
 */
- (void)getMemberGrade{
    // 会员权益模块
    [DownLoadData postGetPrivileges:^(id obj, NSError *error) {
        _equityArr = obj[@"lists"];
        //刷新某一行
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        //会员权益底部
        EquityBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[EquityBottomCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        if (_equityArr.count) {
            [cell cellForVipEquityByArray:_equityArr andVipGrade:self.vipGrade dictionary:_yearAmountDic andMoney:self.money];
            cell.equityArr = _equityArr;
        }
        [cell.rechargeBtn addTarget:self action:@selector(vipButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{
        //会员权益头部单元格
        static NSString *str = @"EquityHeaderCell";
        EquityHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[EquityHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        [cell setVipArrWithDictionary:_yearAmountDic andGrade:self.vipGrade userName:self.userName yearAmount:self.money];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        return kScreenHeight-490*m6Scale;
    }else{
        return 490*m6Scale;
    }
}
/**
 右边按钮，帮助中心,客服电话
 */
- (void)helpCenter{
    ActivityCenterVC *tempVC = [ActivityCenterVC new];
    tempVC.tag = 50;
    tempVC.strUrl = @"/html/vipLevel.html";
    tempVC.urlName = @"会员规则";
    [self.navigationController pushViewController:tempVC animated:YES];
}
#pragma mark - 网易七鱼返回
- (void)onBack:(UINavigationItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *会员权益按钮点击事件
 */
- (void)PushView:(NSNotification *)notification{
    NSString *tag = notification.userInfo[@"tag"];
    NSString *grade = notification.userInfo[@"grade"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    dic = notification.userInfo[@"dictionary"];
    NSLog(@"%@     %@", dic, [dic objectForKey:@"12"]);
    //用户享受该权益的最小等级
    NSString *minMemberGrade = @"";
    //每一个权益ID
    NSString *equityId = @"";
    //当tag小于1000  图标处于高亮状态
    if (tag.integerValue < 1000) {
        equityId = [NSString stringWithFormat:@"%ld", 999-tag.integerValue];
        minMemberGrade = dic[equityId];
        if (grade.integerValue < minMemberGrade.integerValue) {
            //根据会员等级查询该等级可享权益列表
            [self getConfigsByGrade:grade];
        }else{
            //高亮状态下请求数据  需要 权益ID和等级
            //根据会员等级和权益id查询会员可享受权益
            [self getConfigByIdAndGradePrivilegeId:equityId grade:grade];
        }
    }else{
        //非高亮
        equityId = [NSString stringWithFormat:@"%ld", tag.integerValue-1000];
        minMemberGrade = [dic objectForKey:equityId];
        NSLog(@"equityId = %@  grade = %@   minMemberGrade = %@", equityId,grade, minMemberGrade);
        if (grade.integerValue < minMemberGrade.integerValue) {
            //根据会员等级查询该等级可享权益列表
            [self getConfigsByGrade:grade];
        }else{
            //根据会员等级和权益id查询会员可享受权益
            [self getConfigByIdAndGradePrivilegeId:equityId grade:grade];
        }
    }
}
/**
 *根据会员等级和权益id查询会员可享受权益
 */
- (void)getConfigByIdAndGradePrivilegeId:(NSString *)equityId grade:(NSString *)grade{
    //根据会员等级和权益id查询会员可享受权益
    [DownLoadData postGetConfigByIdAndGrade:^(id obj, NSError *error) {
        self.pushView.hidden = NO;
        self.pushView.backView.transform = CGAffineTransformMakeScale(0.05, 0.05);
        [UIView animateWithDuration:0.5 animations:^{
            self.pushView.backView.transform = CGAffineTransformMakeScale(1, 1);
            [self.pushView setPushLabelWithString:[NSString stringWithFormat:@"权益内容：%@", obj[@"ret"][@"content"]] andInvest:@"NO"];
            self.pushView.pushLabel.textAlignment = NSTextAlignmentCenter;
        } completion:^(BOOL finished) {
            
        }];
    } privilegeId:equityId grade:grade];
}
/**
 *根据会员等级查询该等级可享权益列表
 */
- (void)getConfigsByGrade:(NSString *)grade{
    [DownLoadData postGetConfigsByGrade:^(id obj, NSError *error) {
        self.pushView.hidden = NO;
        self.pushView.backView.transform = CGAffineTransformMakeScale(0.05, 0.05);
        [UIView animateWithDuration:0.5 animations:^{
            self.pushView.backView.transform = CGAffineTransformMakeScale(1, 1);
            NSArray *array = obj[@"lists"];
            NSMutableString *string = [NSMutableString stringWithString:[NSString stringWithFormat:@"升级到V%ld等级方可享受以下特权:\n", grade.integerValue+1]];
            for (int i = 0; i < array.count; i++) {
                NSString *str = [NSString stringWithFormat:@"%d、%@;\n", i+1, array[i][@"content"]];
                [string appendString:str];
            }
            [self.pushView setPushLabelWithString:string andInvest:@"YES"];
        } completion:^(BOOL finished) {
            
        }];
    } grade:[NSString stringWithFormat:@"%ld", grade.integerValue+1]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //导航设置
    self.navigationController.navigationBar.translucent = YES;
     //电池电量条
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.5)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor colorWithWhite:0.5 alpha:1] size:CGSizeMake(self.view.frame.size.width, 0.5)]];
}
/**
 *升级VIP按钮点击事件
 */
- (void)vipButtonClick{
    
    NSNotification *notification = [[NSNotification alloc] initWithName:@"GoToInvest" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GoToInvest" object:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.pushView.hidden = YES;
    self.pushView.pushLabel.text = @"";
}
@end
