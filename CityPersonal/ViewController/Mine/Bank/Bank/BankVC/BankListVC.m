//
//  BankListVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/21.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "BankListVC.h"
#import "TopCell.h"
#import "BidCardFirstVC.h"

@interface BankListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BankListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"选择银行卡"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
//    //添加银行卡按钮
//    UIButton *rightButton = [Factory addRightbottonToVC:self andImageName:@"topUp_tianjia"];
//    [rightButton addTarget:self action:@selector(addBankCard) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = backGroundColor;
    
    [self.view addSubview:self.tableView];
}

/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20*m6Scale, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        //_tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    }
    return _tableView;
}
- (void)onClickLeftItem{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count+1;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<self.dataSource.count) {
        NSString *str = @"cell";
        TopCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[TopCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        [cell cellForWithDrawalModel:self.dataSource[indexPath.row] andIndex:_index andIndexPath:indexPath];
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lastCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"lastCell"];
            cell.imageView.image = [UIImage imageNamed:@"银行卡"];
            cell.textLabel.text = @"添加银行卡";
            cell.textLabel.font = [UIFont systemFontOfSize:30*m6Scale];
            cell.selectionStyle = NO;
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104*m6Scale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataSource.count) {
        BankListModel *model = self.dataSource[indexPath.row];
        _index = indexPath.row;
        
        [self.tableView reloadData];
        //用户点击某个银行卡  需要将银行卡信息传到充值界面
        NSNotification *notification = [[NSNotification alloc] initWithName:@"chooseWithdrawalBank" object:nil userInfo:@{@"model":model, @"index":[NSString stringWithFormat:@"%ld", (long)_index]}];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self addBankCard];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //  分割线去掉左边15个像素
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        
    {
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        
    {
        
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        
    }
    
}
/**
 *添加银行卡
 */
- (void)addBankCard{
    BidCardFirstVC *tempVC = [BidCardFirstVC new];
    tempVC.userName = self.userName;
    tempVC.index = 5;
    [self.navigationController pushViewController:tempVC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
}

@end
