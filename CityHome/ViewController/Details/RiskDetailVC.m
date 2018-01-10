//
//  RiskDetailVC.m
//  CityJinFu
//
//  Created by mic on 16/10/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "RiskDetailVC.h"
#import "HelpTableViewController.h"

@interface RiskDetailVC ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UILabel *titleLabel;//车贷宝项目第1205期
@property (nonatomic, strong) UIView *navigationColorView;
@property (nonatomic, strong) UILabel *label1;//-5000000
@property (nonatomic, strong) UILabel *label2;//交易成功
@property (nonatomic, strong) UIView *firstLine;//-5000000
@property (nonatomic, strong) UIView *secondLine;//交易成功

@end

@implementation RiskDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = backGroundColor;
    [self.view addSubview:self.tableView];
    _titleLabel = [[UILabel alloc]init];
    _label1 = [[UILabel alloc]init];
    _label2 = [[UILabel alloc]init];
    _navigationColorView = [[UIView alloc]init];
    _firstLine = [UIView new];
    _secondLine = [UIView new];
}
/**
 *  右边的按钮,跳到客服中心
 */
- (void)onClickRightItem
{
    HelpTableViewController *help = [HelpTableViewController new];
    help.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:help animated:YES];
}
/**
 *  UITableView    lazyloading
 */
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-44) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else {
        return 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HUICHENG = @"huicheng";
    static NSString *JINFU = @"jinfu";
    static NSString *HUICHENGJINFU = @"huichengjinfu";
    if (indexPath.section == 0) {
        UITableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:HUICHENG];
        if (!firstCell) {
            firstCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HUICHENG];
            firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //车贷宝项目第1205期
//        UILabel *label = [[UILabel alloc]init];
        _titleLabel.text = self.titleStr;
        _titleLabel.textColor = [UIColor colorWithRed:97/255.0 green:97/255.0 blue:97/255.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:36*m6Scale];
        [firstCell addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(firstCell.mas_centerX);
            make.centerY.mas_equalTo(firstCell.mas_centerY);
        }];
        //label旁边的线
//        UIView *navigationColorView = [[UIView alloc]init];
        _navigationColorView.backgroundColor = navigationColor;
        [firstCell addSubview:_navigationColorView];
        [_navigationColorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_titleLabel.mas_left).mas_equalTo(-20*m6Scale);
            make.centerY.mas_equalTo(firstCell.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(3*m6Scale, 42*m6Scale));
        }];
        //第一条分割线
//        CALayer *layer = [CALayer layer];
//        _firstLine.backgroundColor = backGroundColor;
//        _firstLine.frame = CGRectMake(40*m6Scale, 129*m6Scale, kScreenWidth-80*m6Scale, 5);
////        _firstLayer.position = CGPointMake(40*m6Scale, 129*m6Scale);
////        _firstLayer.anchorPoint = CGPointMake(0, 0);
//        [firstCell addSubview:_firstLine];
        
        return firstCell;
    }
    else if (indexPath.section == 1) {
        UITableViewCell *secondCell = [tableView dequeueReusableCellWithIdentifier:JINFU];
        if (!secondCell) {
            secondCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JINFU];
            secondCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //label
//        UILabel *label = [[UILabel alloc]init];
        _label1.text = [NSString stringWithFormat:@"- %@",self.moneyStr];
        _label1.textColor = [UIColor colorWithRed:62/255.0 green:62/255.0 blue:62/255.0 alpha:1.0];
        _label1.font = [UIFont systemFontOfSize:60*m6Scale];
        [secondCell addSubview:_label1];
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(secondCell.mas_centerX);
            make.bottom.mas_equalTo(secondCell.mas_centerY);
        }];
        //交易成功
//        UILabel *label2 = [[UILabel alloc]init];
        _label2.text = @"交易成功";
        _label2.textColor = [UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1.0];
        _label2.font = [UIFont systemFontOfSize:28*m6Scale];
        [secondCell addSubview:_label2];
        [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(secondCell.mas_centerX);
            make.top.mas_equalTo(secondCell.mas_centerY).mas_equalTo(30*m6Scale);
        }];
        //第二条分割线
////        CALayer *secondLayer = [CALayer layer];
//        _secondLine.backgroundColor = backGroundColor;
//        _secondLine.frame = CGRectMake(0, 209*m6Scale, kScreenWidth, 5);
////        _secondLayer.position = CGPointMake(0, 209*m6Scale);
////        _secondLayer.anchorPoint = CGPointMake(0, 0);
//        [secondCell addSubview:_secondLine];
        
        return secondCell;
    }
    else {
        UITableViewCell *lastCell = [tableView dequeueReusableCellWithIdentifier:HUICHENGJINFU];
        if (!lastCell) {
            lastCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HUICHENGJINFU];
            lastCell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *textLable = @[@"投资金额",@"投资日期",@"利率",@"期限",@"预期收益",@"回款日",@"订单号"];
            NSLog(@"%@----%@-----%@-----%@-----%@-----%@------%@",self.moneyStr,self.recordTime,self.interest,self.qixian,self.hopeIncome,self.feedBack,self.investOrder);
            NSArray *detailLable = @[[NSString stringWithFormat:@"¥%@",self.moneyStr],self.recordTime,self.interest,self.qixian,self.hopeIncome,self.feedBack,self.investOrder];
            if (indexPath.row == 0) {
                lastCell.detailTextLabel.textColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0];
            } else if (indexPath.row == 4) {
                lastCell.detailTextLabel.textColor = [UIColor colorWithRed:255/255.0 green:66/255.0 blue:66/255.0 alpha:1.0];
            } else {
                lastCell.detailTextLabel.textColor = [UIColor colorWithRed:158/255.0 green:158/255.0 blue:158/255.0 alpha:1.0];
            }
            lastCell.textLabel.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1.0];
            lastCell.textLabel.font = [UIFont systemFontOfSize:28*m6Scale];
            lastCell.textLabel.text = textLable[indexPath.row];
            lastCell.detailTextLabel.text = detailLable[indexPath.row];
        }
        return lastCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 129*m6Scale;
    } else if (indexPath.section == 1) {
        return 209*m6Scale;
    } else {
        return 70*m6Scale;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//{
//    if (section == 0) {
//        view.tintColor = [UIColor whiteColor];
//    }
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *footVIew = [[UIView alloc]initWithFrame:CGRectMake(40*m6Scale, 129*m6Scale, kScreenWidth-80*m6Scale, 1)];
        footVIew.backgroundColor = backGroundColor;
        return footVIew;
    } else if (section == 1) {
        UIView *footVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 209*m6Scale, kScreenWidth, 1)];
        footVIew.backgroundColor = backGroundColor;
        return footVIew;
    } else {
        UIView *footVIew = [[UIView alloc]init];
        footVIew.backgroundColor = backGroundColor;
        return footVIew;
    }
    
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //创建一个导航栏
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self.navBar setBackgroundColor:navigationColor];
//    //隐藏导航栏的分割线
//    [self.navBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navBar.shadowImage = [[UIImage alloc] init];
    //创建一个导航栏集合
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"投资记录"];
    TitleLabelStyle *titleLabel = [[TitleLabelStyle alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    [titleLabel titleLabel:@"投资记录" color:[UIColor whiteColor]];
    navItem.titleView = titleLabel;
    //在这个集合Item中添加标题，按钮
    //style:设置按钮的风格，一共有三种选择
    //action：@selector:设置按钮的点击事件
    
    //创建一个左边按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back-Arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickLeftItem)];
    left.tintColor = [UIColor whiteColor];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"组-8"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickRightItem)];
    right.tintColor = [UIColor whiteColor];
    
    //把导航栏集合添加到导航栏中，设置动画关闭
    [self.navBar pushNavigationItem:navItem animated:NO];
    
    //把左右两个按钮添加到导航栏集合中去
    [navItem setLeftBarButtonItem:left];
    [navItem setRightBarButtonItem:right];
    
    //将标题栏中的内容全部添加到主视图当中
    [self.view addSubview:self.navBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
