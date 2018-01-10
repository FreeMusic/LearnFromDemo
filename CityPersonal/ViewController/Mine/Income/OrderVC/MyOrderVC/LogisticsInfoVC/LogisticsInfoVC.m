//
//  LogisticsInfoVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/28.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "LogisticsInfoVC.h"
#import "LogisticsInfoCell.h"
#import "FormValidator.h"

@interface LogisticsInfoVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *backView;//头部背景图
@property (nonatomic, strong) UILabel *statusLabel;//运输状态
@property (nonatomic, strong) UILabel *nameLabel;//快递名称
@property (nonatomic, strong) UILabel *numLabel;//运单编号
@property (nonatomic, strong) NSString *status;//运输状态

@end

@implementation LogisticsInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"物流信息"];
    self.view.backgroundColor = backGroundColor;
    self.navigationController.navigationBar.translucent = NO;
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //请求数据
    [self serviceData];
    
    [self.view addSubview:self.tableView];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = backGroundColor;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 20*m6Scale;
    }
    return _tableView;
}
/**
 *头部白色的View懒加载
 */
- (UIView *)backView{
    if(!_backView){
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        //运输状态
        NSArray *textArr = @[@"物流状态", @"承运来源：", @"运单编号："];
        for (int i = 0; i < textArr.count; i++) {
            UILabel *label = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:textArr[i] addSubView:_backView];
            if (i) {
                label.textColor = UIColorFromRGB(0xA7A7A7);
                label.font = [UIFont systemFontOfSize:28*m6Scale];
                if (i == 1) {
                    //承接来源
                    _nameLabel = [Factory CreateLabelWithTextColor:0 andTextFont:30 andText:@"" addSubView:_backView];
                    _nameLabel.textColor = UIColorFromRGB(0xA7A7A7);
                    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(label.mas_right).offset(40*m6Scale);
                        make.top.mas_equalTo(label.mas_top);
                    }];
                }else{
                    //运单编号
                    _numLabel = [Factory CreateLabelWithTextColor:0 andTextFont:30 andText:@"" addSubView:_backView];
                    _numLabel.textColor = UIColorFromRGB(0xA7A7A7);
                    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(label.mas_right).offset(40*m6Scale);
                        make.top.mas_equalTo(label.mas_top);
                    }];
                }
            }else{
                label.textColor = UIColorFromRGB(0x393939);
                //运输状态
                _statusLabel = [Factory CreateLabelWithTextColor:0 andTextFont:30 andText:@"" addSubView:_backView];;
                [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(label.mas_right).offset(40*m6Scale);
                    make.top.mas_equalTo(36*m6Scale);
                }];
            }
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20*m6Scale);
                make.top.mas_equalTo(36*m6Scale+50*m6Scale*i);
            }];
        }
        
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 188*m6Scale, kScreenWidth, 20*m6Scale)];
    view.backgroundColor = backGroundColor;
    [_backView addSubview:view];
    
    return _backView;
}
/**
 *数据数组的懒加载
 */
- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *请求数据
 */
- (void)serviceData{
    //物流信息查询
    [DownLoadData postQueryLogisticsByNo:^(id obj, NSError *error) {
        
        self.dataSource = obj[@"SUCCESS"];
        self.status = obj[@"status"];
        
        [self.tableView reloadData];
        
    } userId:[HCJFNSUser stringForKey:@"userId"] logisticsNo:self.logisticsOrderNo logisticsType:self.logisticsType];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1+self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        static NSString *str = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.selectionStyle = NO;
        cell.imageView.image = [UIImage imageNamed:@"物流"];
        cell.textLabel.text = @"物流实时信息";
        cell.textLabel.textColor = UIColorFromRGB(0x393939);
        cell.textLabel.font = [UIFont systemFontOfSize:28*m6Scale];
        
        return cell;
    }else{
        static NSString *reuse = @"LogisticsInfoCell";
        LogisticsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[LogisticsInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        }
        if (indexPath.row == 1) {
            //假如是第一个，那么需要进度变绿
            [cell cellForModel:self.dataSource[self.dataSource.count - indexPath.row] index:1];
        }else{
            [cell cellForModel:self.dataSource[self.dataSource.count - indexPath.row] index:0];
        }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 66*m6Scale;
    }else{
        LogisticsInfoModel *model =self.dataSource[self.dataSource.count - indexPath.row];
        CGRect rect =[FormValidator rectWidthAndHeightWithStr:model.context AndFont:24*m6Scale WithStrWidth:kScreenWidth-100*m6Scale];
        
        return rect.size.height+70*m6Scale;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //承接来源
    _nameLabel.text = self.logisticsType;
    //运单编号
    _numLabel.text = self.logisticsOrderNo;
    //物流状态
    _statusLabel.text = self.status;
    if ([self.status isEqualToString:@"运输中"]) {
        _statusLabel.textColor = UIColorFromRGB(0x14D369);
    }
    
    return self.backView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 208*m6Scale;
}

@end
