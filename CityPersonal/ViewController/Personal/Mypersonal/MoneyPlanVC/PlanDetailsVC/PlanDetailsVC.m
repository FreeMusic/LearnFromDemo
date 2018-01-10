//
//  PlanDetailsVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/15.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PlanDetailsVC.h"
#import "PlanDetailsView.h"
#import "PlanDetailsCell.h"

@interface PlanDetailsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PlanDetailsView *planDetailsView;//计划详情View

@end

@implementation PlanDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:self.vcTitle];
    //计划详情View
    [self.view addSubview:self.planDetailsView];
    
    [self.view addSubview:self.tableView];
    //请求数据
    [self serviceData];
}

/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 198*m6Scale, kScreenWidth, kScreenHeight-198*m6Scale) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    
    return _tableView;
}
/**
 *请求数据
 */
- (void)serviceData{
    //查询锁投规则投资记录
    [DownLoadData postGetListByAutoId:^(id obj, NSError *error) {
        
    } autoId:self.autoId];
}
/**
 *计划详情View的懒加载
 */
- (PlanDetailsView *)planDetailsView{
    if(!_planDetailsView){
        _planDetailsView = [[PlanDetailsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 198*m6Scale)];
    }
    
    return _planDetailsView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        NSString *reuse = @"PersonalPlanCell";
        PlanDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[PlanDetailsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        }
        
        return cell;
    }else{
        NSString *str = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.selectionStyle = NO;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20*m6Scale, 16*m6Scale, 2, 28*m6Scale)];
        line.backgroundColor = ButtonColor;
        [cell.contentView addSubview:line];
        cell.textLabel.text = @"锁定投标";
        cell.textLabel.font = [UIFont systemFontOfSize:28*m6Scale];
        cell.textLabel.textColor = UIColorFromRGB(0x3e3e3e);
        cell.detailTextLabel.text = @"投资成功";
        cell.detailTextLabel.textColor = UIColorFromRGB(0xff5933);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:26*m6Scale];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        return 90*m6Scale;
    }else{
        return 56*m6Scale;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = backGroundColor;
    UILabel *headerLabel = [Factory CreateLabelWithTextColor:1 andTextFont:26 andText:@"投资记录" addSubView:headerView];
    headerLabel.textColor = UIColorFromRGB(0x9d9d9d);
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70*m6Scale);
        make.centerY.mas_equalTo(headerView.mas_centerY);
    }];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 76*m6Scale;
}


@end
