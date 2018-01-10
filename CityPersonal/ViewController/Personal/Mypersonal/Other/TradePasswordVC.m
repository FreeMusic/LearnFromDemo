//
//  TradePasswordVC.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/11/9.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "TradePasswordVC.h"

@interface TradePasswordVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TradePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backGroundColor;
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"交易密码"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    [self createView];
    
}
//创建视图
- (void)createView {
    
    UITableView *passwordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
//    passwordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    passwordTableView.delegate = self;
    passwordTableView.dataSource = self;
    [self.view addSubview:passwordTableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 15 * m6Scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 90 * m6Scale;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"passwordCell"];
    
    if (cell == nil) {
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"passwordCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"设置交易密码";
    }else {
        
        cell.textLabel.text = @"修改交易密码";
    }
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    
//    NSString *userId = [user objectForKey:@"userId"];
//    if (indexPath.row == 0) {
//        
//        //调加签接口
//        [DownLoadData postSignature:^(id obj, NSError *error) {
//            
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//            //                NSLog(@"%@",obj);
//            [dic setValue:obj[@"sign"] forKey:@"sign"];
//            [dic setValue:moeyKey forKey:@"merchantId"];
//            [dic setValue:[user objectForKey:@"userId"] forKey:@"userId"];
//            //                NSLog(@"%@",userId);
//            [UcfPaymentServiceSDK authWithRootVC:self params:[dic copy] successBlock:^(NSDictionary *params) {
//                
//                if ([params[@"respMsg"] isEqualToString:@"认证成功"]) {
//                    
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜您，设置成功" preferredStyle:UIAlertControllerStyleAlert];
//                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        [self.navigationController popViewControllerAnimated:YES];
//                    }]];
//                    
//                    [self presentViewController:alert  animated:YES completion:nil];
//                }
//                
//            } failBlock:^(NSDictionary *params) {
//                
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设置失败" preferredStyle:UIAlertControllerStyleAlert];
//                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }]];
//                
//                [self presentViewController:alert  animated:YES completion:nil];
//                
//            }];
//            
//        } userId:userId];
//        
//        
//    }else {
//        
//        [DownLoadData postSignature:^(id object, NSError *error) {
//            
//            if (object[@"sign"]) {
//                
//                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//                //                NSLog(@"%@",obj);
//                [dic setValue:object[@"sign"] forKey:@"sign"];
//                [dic setValue:moeyKey forKey:@"merchantId"];
//                [dic setValue:[user objectForKey:@"userId"] forKey:@"userId"];
//                
//                [UcfPaymentServiceSDK forgetPwdWithRootVC:self params:[dic copy] successBlock:^(NSDictionary *params) {
//                    
//                    
//                    NSLog(@"%@",params);
//                    
//                } failBlock:^(NSDictionary *params) {
//                    
//                    NSLog(@"%@",params);
//                    
//                }];
//                
//            }
//        } userId:[user objectForKey:@"userId"]];
//        
//    }
//    
//    
//}

/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
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
