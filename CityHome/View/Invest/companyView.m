//
//  companyView.m
//  CityJinFu
//
//  Created by mic on 2017/10/20.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "companyView.h"
#import "TopUpModel.h"

@implementation companyView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
        
        _selected = 0;
        
        [self addSubview:self.tableView];
        
    }
    
    return self;
}

/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.layer.cornerRadius = 5*m6Scale;
        _tableView.layer.masksToBounds = YES;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}
/**
 *  centerLabel懒加载
 */
- (UILabel *)centerLabel{
    if(!_centerLabel){
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.text = @"选择支付公司";
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.textColor = [UIColor blackColor];
        _centerLabel.font = [UIFont systemFontOfSize:28*m6Scale];
    }
    
    return _centerLabel;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count+1;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        NSString *str = @"TopUpCell";
        
        _cell = [tableView dequeueReusableCellWithIdentifier:str];
        
        if (!_cell) {
            _cell = [[TopUpCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        
        [_cell cellForModel:self.dataSource[indexPath.row - 1] andSelected:_selected andOtherIndex:indexPath.row-1];
        
        return _cell;
    }else{
        NSString *str = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.selectionStyle = NO;
        [cell addSubview:self.centerLabel];
        [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 106*m6Scale;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        _selected = indexPath.row-1;
        [self.tableView reloadData];
        TopUpModel *model = self.dataSource[indexPath.row-1];
        //获取用户选择的支付公司
        NSNotification *noti = [[NSNotification alloc] initWithName:@"selectedCompanyPay" object:nil userInfo:@{@"model":model, @"index":[NSString stringWithFormat:@"%ld", _selected]}];
        
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }

}

//- (void)setDataSource:(NSArray *)dataSource{
//    
//    NSLog(@"%@", dataSource);
//    
//    self.dataSource = dataSource;
//    
//    [self.tableView reloadData];
//    
//}

@end
