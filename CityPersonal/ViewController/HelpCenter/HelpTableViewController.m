//
//  HelpTableViewController.m
//  CityJinFu
//
//  Created by xxlc on 16/8/17.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "HelpTableViewController.h"
#import "QYDemoBadgeView.h"
#import "ContactUsVC.h"
#import "CalendarVC.h"

@interface HelpTableViewController ()<UITableViewDelegate, UITableViewDataSource,QYConversationManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *selectSource;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UINavigationBar *QYnavBar;
@property (strong, nonatomic) YSFDemoBadgeView *badgeView;

@end

@implementation HelpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backGroundColor;
    //导航栏设置
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"帮助中心"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];

    //添加网易七鱼客服消息未读数量
    //_badgeView = [[YSFDemoBadgeView alloc] init];
    
    //tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight ) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate  = self;
    _tableView.contentInset = UIEdgeInsetsMake(15*m6Scale, 0, 0, 0);
    self.tableView.bounces = NO;//不能上滑
    _tableView.separatorColor = SeparatorColor;
    _tableView.sectionHeaderHeight = 0;
    _tableView.sectionFooterHeight = 15*m6Scale;
    [self.view addSubview:_tableView];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else
    {
        return 4;
    }
}
#pragma mark -cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Identifier = @"HCJF";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右边的样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//去掉选中背景的颜色
    NSArray *array = @[@"在线客服",@"客服电话"];
    NSArray *textArr = @[@"wallet_kefu@2x_80", @"wallet_dianhua"];
    NSArray *sectionArray = @[@"充值提现问题",@"银行卡绑定问题",@"其他问题", @"联系我们"];
    NSArray *picArr = @[@"wallet_chongzi", @"wallet_yinhangka", @"wallet_qita", @"联系我们"];
    if (indexPath.section == 0) {
        cell.textLabel.text = array[indexPath.row];
        if (indexPath.row == 0) {
//            [cell addSubview:_badgeView];
//            [_badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(cell.mas_right).mas_equalTo(-80*m6Scale);
//                make.centerY.mas_equalTo(cell.mas_centerY);
//                make.size.mas_equalTo(CGSizeMake(30*m6Scale, 30*m6Scale));
//            }];
        }
        cell.imageView.image = [UIImage imageNamed:textArr[indexPath.row]];//左边的图片
    }
    else
    {
        cell.textLabel.text = sectionArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:picArr[indexPath.row]];//左边的图片
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120 *m6Scale;
}
/**
 *  每一格的点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        //在线客服
        if ([defaults objectForKey:@"userId"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = NSLocalizedString(@"连接中...", @"HUD loading title");
            //用户个人信息
            [DownLoadData postUserInformation:^(id obj, NSError *error) {

                NSLog(@"%@-------",obj);

                if (obj[@"usableCouponCount"]) {

                    [HCJFNSUser setValue:obj[@"usableCouponCount"] forKey:@"Red"];
                }
                if (obj[@"usableTicketCount"]) {
                    [HCJFNSUser setValue:obj[@"usableTicketCount"] forKey:@"Ticket"];

                }
                if ([obj[@"identifyCard"] isKindOfClass:[NSNull class]] || obj[@"identifyCard"] == nil) {
                    [HCJFNSUser setValue:@"1" forKey:@"IdNumber"];
                }else{
                    [HCJFNSUser setValue:obj[@"identifyCard"] forKey:@"IdNumber"];
                }
                NSArray *array = obj[@"accountBankList"];
                if ([array count] == 0) {
                    [HCJFNSUser setValue:@"1" forKey:@"cardNo"];
                }else{

                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [HCJFNSUser setValue:obj[@"cardNo"] forKey:@"cardNo"];
                    }];
                }
                [HCJFNSUser setValue:[obj[@"accountBankList"] firstObject][@"realname"] forKey:@"realname"];//姓名
                [HCJFNSUser synchronize];
                [hud setHidden:YES];
                //在线客服
                QYSessionViewController *sessionViewController = [Factory jumpToQY];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
                if (iOS11) {
                    self.QYnavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, NavigationBarHeight)];
                }else{
                    self.QYnavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NavigationBarHeight)];
                }
                UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"汇诚金服"];
                TitleLabelStyle *titleLabel = [[TitleLabelStyle alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
                [titleLabel titleLabel:@"汇诚金服" color:[UIColor blackColor]];
                navItem.titleView = titleLabel;
                UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanghui"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];

                left.tintColor = [UIColor blackColor];
                [self.QYnavBar pushNavigationItem:navItem animated:NO];
                [navItem setLeftBarButtonItem:left];
                //    [navItem setRightBarButtonItem:right];
                [navi.view addSubview:self.QYnavBar];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:navi animated:YES completion:nil];
                });
//                [self.navigationController pushViewController:navi animated:YES];
            } userId:[HCJFNSUser objectForKey:@"userId"]];
        }
        else{
            [Factory alertMes:@"请先登录"];
        }
        
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        NSString *clip = @"客服时间:9:00-17:30\n400-0571-909";
        //客服电话
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:clip preferredStyle:UIAlertControllerStyleAlert];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:clip];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36 * m6Scale] range:NSMakeRange(clip.length - 12, 12)];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:26 * m6Scale] range:NSMakeRange(0, clip.length - 12)];
//        if ([alert valueForKey:@"attributedMessage"]) {
        
            [alert setValue:attStr forKey:@"attributedMessage"];
//        }
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *str = @"tel://400-0571-909";
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        if (indexPath.row == 3) {
            ContactUsVC *tempVC = [ContactUsVC new];
            
            [self.navigationController pushViewController:tempVC animated:YES];
        }else{
            AchieveVC *achieve = [AchieveVC new];
            if (indexPath.row == 0) {
                achieve.acTag = 1;
            }else if (indexPath.row == 1){
                achieve.acTag = 2;
            }else{
                achieve.acTag = 3;
            }
            [self.navigationController pushViewController:achieve animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 15 * m6Scale;
    }
    else
    {
          return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
#pragma mark - 网易七鱼返回
- (void)onBack:(UINavigationItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - QYConversationManagerDelegate点击调用
- (void)onUnreadCountChanged:(NSInteger)count
{
    [self configBadgeView];
}
- (void)configBadgeView
{
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    [_badgeView setHidden:count == 0];
    NSString *value = count > 99 ? @"99+" : [NSString stringWithFormat:@"%zd",count];
    [_badgeView setBadgeValue:value];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [Factory hidentabar];//隐藏tabar
    [Factory navgation:self];
    //网易七鱼设置代理，用来检测未读数量
    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
    [self configBadgeView];
    
    //修改电池电量条的颜色为白色
    UIApplication *myApplication = [UIApplication sharedApplication];
    
    [myApplication setStatusBarHidden:NO];
    
    [myApplication setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
