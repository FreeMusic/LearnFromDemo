//
//  GoingVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/14.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "GoingVC.h"
#import "PersonalPlanCell.h"
#import "PlanDetailsVC.h"

@interface GoingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *threeArr;
@property (nonatomic, strong) NSMutableArray *sixArr;
@property (nonatomic, strong) NSMutableArray *yearArr;

@end

@implementation GoingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backGroundColor;
    
    [self.view addSubview:self.tableView];
    
    [self serviceData];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-298*m6Scale-NavigationBarHeight) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 24*m6Scale;
        _tableView.contentInset = UIEdgeInsetsMake(-35+24*m6Scale, 0, 0, 0);
    }
    
    return _tableView;
}
/**
 *季度数组
 */
- (NSMutableArray *)threeArr{
    if(!_threeArr){
        _threeArr = [NSMutableArray array];
    }
    return _threeArr;
}
/**
 *半年数组
 */
- (NSMutableArray *)sixArr{
    if(!_sixArr){
        _sixArr = [NSMutableArray array];
    }
    return _sixArr;
}
/**
 *年度数组
 */
- (NSMutableArray *)yearArr{
    if(!_yearArr){
        _yearArr = [NSMutableArray array];
    }
    return _yearArr;
}
/**
 *请求数据
 */
- (void)serviceData{
    //计划中我的规则列表
    [DownLoadData postMyPlans:^(id obj, NSError *error) {
        
        self.threeArr = obj[@"threeArr"];
        self.sixArr = obj[@"sixArr"];
        self.yearArr = obj[@"yearArr"];
        
        [self.tableView reloadData];
        
    } userId:[HCJFNSUser stringForKey:@"userId"] isDelete:@"0"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.threeArr.count) {
           return self.threeArr.count+1;
        }else{
            return 2;
        }
    }else if (section == 1){
        if (self.sixArr.count) {
            return self.sixArr.count+1;
        }else{
            return 2;
        }
    }else{
        if (self.yearArr.count) {
            return self.yearArr.count+1;
        }else{
            return 2;
        }
    }
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //季度计划
        if (indexPath.row) {
            NSString *str = @"threeCell";
            PersonalPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[PersonalPlanCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
            }
            if (self.threeArr.count) {
                [cell cellForModel:self.threeArr[indexPath.row-1]];
            }else{
                [cell cellForModel:nil];
            }
            
            return cell;
        }else{
            NSString *reuse = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20*m6Scale, 10*m6Scale, 2, 40*m6Scale)];
                line.backgroundColor = ButtonColor;
                [cell.contentView addSubview:line];
                UILabel *text = [UILabel new];
                text.text = @"季度计划";
                text.font = [UIFont systemFontOfSize:30*m6Scale];
                text.textColor = UIColorFromRGB(0x3e3e3e);
                [cell.contentView addSubview:text];
                [text mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(line.mas_right).offset(10*m6Scale);
                    make.centerY.mas_equalTo(line.mas_centerY);
                }];
            }
            cell.selectionStyle = NO;
            cell.userInteractionEnabled = NO;

            
            return cell;
        }
    }else if (indexPath.section == 1){
        //半年计划
        if (indexPath.row) {
            NSString *str = @"threeCell";
            PersonalPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[PersonalPlanCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
            }
            if (self.sixArr.count) {
                [cell cellForModel:self.sixArr[indexPath.row-1]];
            }else{
                [cell cellForModel:nil];
            }
            
            return cell;
        }else{
            NSString *reuse = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20*m6Scale, 10*m6Scale, 2, 40*m6Scale)];
                line.backgroundColor = ButtonColor;
                [cell.contentView addSubview:line];
                UILabel *text = [UILabel new];
                text.text = @"半年计划";
                text.font = [UIFont systemFontOfSize:30*m6Scale];
                text.textColor = UIColorFromRGB(0x3e3e3e);
                [cell.contentView addSubview:text];
                [text mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(line.mas_right).offset(10*m6Scale);
                    make.centerY.mas_equalTo(line.mas_centerY);
                }];

            }
            cell.selectionStyle = NO;
            cell.userInteractionEnabled = NO;

            return cell;
        }
    }else{
        //年度计划
        if (indexPath.row) {
            NSString *str = @"threeCell";
            PersonalPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[PersonalPlanCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
            }
            if (self.yearArr.count) {
                [cell cellForModel:self.yearArr[indexPath.row-1]];
            }else{
                [cell cellForModel:nil];
            }
            return cell;
        }else{
            NSString *reuse = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20*m6Scale, 10*m6Scale, 2, 40*m6Scale)];
                line.backgroundColor = ButtonColor;
                [cell.contentView addSubview:line];
                UILabel *text = [UILabel new];
                text.text = @"年度计划";
                text.font = [UIFont systemFontOfSize:30*m6Scale];
                text.textColor = UIColorFromRGB(0x3e3e3e);
                [cell.contentView addSubview:text];
                [text mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(line.mas_right).offset(10*m6Scale);
                    make.centerY.mas_equalTo(line.mas_centerY);
                }];

            }
            cell.selectionStyle = NO;
            cell.userInteractionEnabled = NO;
            
            return cell;
        }
    }
    
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        return 116*m6Scale;
    }else{
        return 60*m6Scale;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        if (self.threeArr.count) {
//            if (indexPath.row) {
//                MyPlanModel *model = self.threeArr[indexPath.row-1];
//                //季度
//                PlanDetailsVC *tempVC = [PlanDetailsVC new];
//                tempVC.vcTitle = @"季度计划";//标题
//                tempVC.autoId = [NSString stringWithFormat:@"%@", model.ID];
//                [self.navigationController pushViewController:tempVC animated:YES];
//            }
//        }
//    }else if (indexPath.section == 1){
//        if (indexPath.row) {
//            //半年
//            if (self.sixArr.count) {
//                MyPlanModel *model = self.sixArr[indexPath.row];
//                //季度
//                PlanDetailsVC *tempVC = [PlanDetailsVC new];
//                tempVC.vcTitle = @"半年计划";//标题
//                tempVC.autoId = [NSString stringWithFormat:@"%@", model.ID];
//                [self.navigationController pushViewController:tempVC animated:YES];
//            }
//        }
//    }else{
//        if (indexPath.row) {
//            //年度
//            if (self.yearArr.count) {
//                MyPlanModel *model = self.sixArr[indexPath.row];
//                //季度
//                PlanDetailsVC *tempVC = [PlanDetailsVC new];
//                tempVC.vcTitle = @"年度计划";//标题
//                tempVC.autoId = [NSString stringWithFormat:@"%@", model.ID];
//                [self.navigationController pushViewController:tempVC animated:YES];
//            }
//        }
//    }
//}

@end
