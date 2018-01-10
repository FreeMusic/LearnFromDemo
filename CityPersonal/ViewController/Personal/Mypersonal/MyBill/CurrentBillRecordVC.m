//
//  CurrentBillRecordVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/11.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "CurrentBillRecordVC.h"
#import "MyBillDetailCell.h"
#import "MyBillRecordVC.h"
#import "PartIncomeModel.h"
#import "PartInvestModel.h"

@interface CurrentBillRecordVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;//数据数组
@property (nonatomic,strong) NSMutableDictionary *dataDic;//数据字典
@property (nonatomic,strong) UIImageView *backImgView;//暂无数据

@end

@implementation CurrentBillRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_type == 2) {
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"本月投资记录"];
    }else{
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"本月回款记录"];
    }
    //左边返回按钮
    UIButton *leftBtn = [Factory addLeftbottonToVC:self];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = backGroundColor;
    [self.view addSubview:self.tableView];
    //请求数据
    [self getData];
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}
- (UIImageView *)backImgView{
    if(!_backImgView){
        _backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无数据"]];
        [self.view addSubview:_backImgView];
        [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(260*m6Scale, 260*m6Scale));
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.centerY.mas_equalTo(self.view.mas_centerY);
        }];
    }
    return _backImgView;
}
/**
 *数据数组
 */
- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
/**
 *数据字典
 */
- (NSMutableDictionary *)dataDic{
    if(!_dataDic){
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
/**
 * 返回
 */
- (void)leftBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *请求数据
 */
- (void)getData{
    if (_type == 2) {
        //用户本月所有投资记录
        [DownLoadData postGetInvestListByUserId:^(id obj, NSError *error) {
            self.dataArr = obj[@"SUCCESS"];
            if (self.dataArr.count == 0) {
                [self backImgView];
            }
            [self.tableView reloadData];
        } userId:[HCJFNSUser stringForKey:@"userId"] queryMonth:_dataString];
    }else{
        //用户本月所有回款记录
        [DownLoadData postGetCollectListAllByUserId:^(id obj, NSError *error) {
            self.dataArr = obj[@"SUCCESS"];
            if (self.dataArr.count == 0) {
                [self backImgView];
            }
            [self.tableView reloadData];
        } userId:[HCJFNSUser stringForKey:@"userId"] queryMonth:_dataString];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"MyBillDetailCell";
    MyBillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[MyBillDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    if (_type == 2) {
        [cell cellForModel:_dataArr[indexPath.row] withtype:_type];
    }else{
        [cell cellForModel:_dataArr[indexPath.row] withtype:0];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*m6Scale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyBillRecordVC *tempVC = [MyBillRecordVC new];
    //2投资3回款
    if (_type == 2) {
        PartInvestModel *model = self.dataArr[indexPath.row];
        tempVC.section = 2;
        tempVC.investID = [NSString stringWithFormat:@"%@", model.investId];
    }else{
        //2投资3回款
        PartIncomeModel *model = self.dataArr[indexPath.row];
        NSLog(@"%@", model.collectId);
        tempVC.section = 3;
        tempVC.investID = [NSString stringWithFormat:@"%@", model.collectId];
    }
    [self.navigationController pushViewController:tempVC animated:YES];
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90*m6Scale)];
//    
//    
//    return backView;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 90*m6Scale;
//}
@end
