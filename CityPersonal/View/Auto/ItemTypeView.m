//
//  ItemTypeView.m
//  CityJinFu
//
//  Created by mic on 2017/10/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "ItemTypeView.h"

@implementation ItemTypeView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50*m6Scale);
            make.right.mas_equalTo(-50*m6Scale);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(4*90*m6Scale);
        }];
        
    }
    
    return self;
}

/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuse = @"cell";
    
    NSArray *typeArr = @[@"类型不限", @"类型车贷宝", @"类型学车宝", @"类型车商宝"];
    NSArray *dateArr = @[@"期限15-360天", @"期限15-45天", @"期限90-360天", @"期限90-360天"];
    NSArray *rateArr = @[@"利率7%-15%", @"利率7%-10%", @"利率9%-12%", @"利率9%-12%"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        
    }
    
    cell.selectionStyle = NO;
    cell.textLabel.text = typeArr[indexPath.row];
    cell.detailTextLabel.text = rateArr[indexPath.row];
    //期限标签
    UILabel *dateLabel = [Factory CreateLabelWithTextColor:0.5 andTextFont:26 andText:dateArr[indexPath.row] addSubView:cell];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(cell.mas_centerX);
        make.centerY.mas_equalTo(cell.mas_centerY);
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90*m6Scale;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *type;
    NSString *date;
    NSString *rate;
    NSString *maxDate;
    NSString *minDate;
    NSString *minRate;
    NSString *maxRate;
    
    switch (indexPath.row) {
        case 0:
            type = @"不限";
            date = @"15天-360天";
            rate = @"7%-15%";
            minDate = @"15";
            maxDate = @"360";
            minRate = @"7";
            maxRate = @"15";
            break;
            
        case 1:
            type = @"车贷宝";
            date = @"15天-45天";
            rate = @"7%-10%";
            minDate = @"15";
            maxDate = @"45";
            minRate = @"7";
            maxRate = @"10";
            break;
            
        case 2:
            type = @"学车宝";
            date = @"90天-360天";
            rate = @"9%-12%";
            minDate = @"90";
            maxDate = @"360";
            minRate = @"9";
            maxRate = @"12";
            break;
            
        case 3:
            type = @"车商宝";
            date = @"90天-360天";
            rate = @"9%-12%";
            minDate = @"90";
            maxDate = @"360";
            minRate = @"9";
            maxRate = @"12";
            break;
            
        default:
            break;
    }
    
    self.SelectType(type, minDate, maxDate, minRate, maxRate, date, rate);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.hidden = YES;
    
}

@end
