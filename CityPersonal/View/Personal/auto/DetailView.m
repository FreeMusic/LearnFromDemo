//
//  DetailView.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/24.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "DetailView.h"
#import "DetailTableViewCell.h"

@interface DetailView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation DetailView

#pragma mark - 懒加载
- (UITableView *)detailTableView {
    
    if (_detailTableView == nil) {
        
        _detailTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _detailTableView.delegate =self;
        _detailTableView.dataSource = self;
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return _detailTableView;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.detailTableView];
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.masksToBounds = YES;
    }
    
    return self;
    
}

- (void)setDataArr:(NSArray *)dataArr {
    
    _dataArr = dataArr;
    
    [self.detailTableView reloadData];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    
    if (cell == nil) {
        
        cell = [[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailCell"];
    }
       
    cell.clipLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *userInfo = @{
                               @"selectStr" : self.dataArr[indexPath.row],
                               
                               @"tag" : self.viewTag
                               };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectStr" object:nil userInfo:userInfo];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 80 * m6Scale;
    
}

@end
