//
//  RealNameVC.m
//  CityJinFu
//
//  Created by xxlc on 16/9/9.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "RealNameVC.h"

@interface RealNameVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,strong) MBProgressHUD *hud;

@end

@implementation RealNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"实名认证"];
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //tableView
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = SeparatorColor;
    [self.view addSubview:_tableView];
    
    [self loadData];//加载数据
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = HCJF;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"姓名";
        cell.detailTextLabel.text = self.realName;
    }else{
        cell.textLabel.text = @"身份证号";
        cell.detailTextLabel.text = self.IDCardNum;
    }
   
    cell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];//字体色颜色
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100*m6Scale;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 18*m6Scale;
    
}
/**
 加载数据
 */
- (void)loadData {
    
    //后台数据
    NSUserDefaults *user = HCJFNSUser;
    
    [self labelExample];//HUD6
    [DownLoadData postrealName:^(id obj, NSError *error) {
        
        NSString *status = [NSString stringWithFormat:@"%@",obj[@"realnameStatus"]];
        
        if ([status isEqualToString:@"1"]) {
            
            self.realName = obj[@"realname"];//真实姓名
            self.IDCardNum = obj[@"identifyCard"];//身份证号
            [user setValue:obj[@"realname"] forKey:@"realname"];//姓名和身份证号存入本地
            [user setValue:obj[@"identifyCard"] forKey:@"IdNumber"];
            [user synchronize];
            
            [self.tableView reloadData];
            
        }else {
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hud hideAnimated:YES];
        });
    } userId:[user objectForKey:@"userId"]];
}

//HUD加载转圈
- (void)labelExample {
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the label text.
    _hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
    // You can also adjust other label properties if needed.
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(10.);
        
    });
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
