//
//  FilterView.m
//  CityJinFu
//
//  Created by mic on 2017/8/9.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "FilterView.h"

@interface FilterView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation FilterView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [self addSubview:self.tableView];
    }
    
    return self;
}

/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -88*m6Scale*6, kScreenWidth, 88*m6Scale*6) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuse = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:28*m6Scale];
    NSArray *array = @[@"不限",@"全部已读", @"福利消息", @"订单消息", @"投资项目", @"其他"];
    if (indexPath.row == 0) {
        cell.textLabel.textColor = UIColorFromRGB(0xff5933);
    }else{
        cell.textLabel.textColor = UIColorFromRGB(0x393939);
    }
    cell.tag = 100+indexPath.row;
    cell.textLabel.text = array[indexPath.row];
    cell.selectionStyle = NO;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88*m6Scale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.filterSelect) {
        self.filterSelect(indexPath.row);
    }
    for (int i = 0; i < 6; i++) {
        UITableViewCell *cell = (UITableViewCell *)[self viewWithTag:100+i];
        if (indexPath.row+100 == 100+i) {
            cell.textLabel.textColor = UIColorFromRGB(0xff5933);
        }else{
            cell.textLabel.textColor = UIColorFromRGB(0x393939);
        }
    }
}

@end
