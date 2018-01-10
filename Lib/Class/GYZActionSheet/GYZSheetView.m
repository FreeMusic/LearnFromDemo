//
//  GYZSheetView.m
//  GYZCustomActionSheet
//  
//  Created by GYZ on 16/6/20.
//  Copyright © 2016年 GYZ. All rights reserved.
//

#import "GYZSheetView.h"
#import "GYZSheetCell.h"
#import "GYZCommon.h"

#define GYZSHEETCELL @"GYZSheetCell"

@implementation GYZSheetView

// 代码创建输入框视图
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        
        self.divLine = [[UIView alloc]init];
        self.divLine.backgroundColor = kGrayLineColor;
        [self addSubview:self.divLine];
        
        self.tableView = [[UITableView alloc]init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        
        [self.tableView registerClass:[GYZSheetCell class] forCellReuseIdentifier:GYZSHEETCELL];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.divLine.frame = CGRectMake(0, 0, self.frame.size.width, kLineHeight);
    self.tableView.frame = CGRectMake(0, MaxY(self.divLine), WIDTH(self), HEIGHT(self));
}

#pragma mark - UITableView数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYZSheetCell *cell= [tableView dequeueReusableCellWithIdentifier:GYZSHEETCELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    cell.myImageView.image = _cellImage;
    cell.myLabel.text = _dataSource[indexPath.row];
    cell.myImageView.image = [UIImage imageNamed:_dataSourceImages[indexPath.row]];
    cell.myLabel.font = [UIFont systemFontOfSize:34*m6Scale];

    
//    if (_cellTextStyle == NSTextStyleLeft) {
//        cell.myLabel.textAlignment = NSTextAlignmentLeft;
//    } else if (_cellTextStyle == NSTextStyleRight){
//        cell.myLabel.textAlignment = NSTextAlignmentRight;
//    } else {
//        cell.myLabel.textAlignment = NSTextAlignmentCenter;
//    }
    
    if (_showTableDivLine) {
        cell.tableDivLine.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger index = indexPath.row;
    GYZSheetCell *cell = (GYZSheetCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *cellTitle = cell.myLabel.text;
    UIImage *cellImage = cell.myImageView.image;
    
    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectIndex:selectTitle:selectImage:)]) {
        [self.delegate sheetViewDidSelectIndex:index selectTitle:cellTitle selectImage:cellImage];
    }
}
@end
