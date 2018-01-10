//
//  GoodsVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/1.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "GoodsVC.h"
#import "GoodsDetailsCell.h"

@interface GoodsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;//数据数组


@end

@implementation GoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    [self.view addSubview:self.tableView];
    
    [self serviceData];
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-108-86*m6Scale)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
/**
 *请求数据
 */
- (void)serviceData{
    [DownLoadData postGetGoodsDescription:^(id obj, NSError *error) {
        NSArray *imgArr = [obj[@"imageId"] componentsSeparatedByString:@","];
        self.dataArr = [[NSMutableArray alloc] initWithArray:imgArr];
        [self.dataArr removeLastObject];
        NSLog(@"%@", self.dataArr);
        [self.tableView reloadData];
    } goodsId:self.goodsID];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"GoodsDetailsCell";
    GoodsDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[GoodsDetailsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    [cell cellForImgView:self.dataArr[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *imgName = self.dataArr[indexPath.row];
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgName]]];
    
    return img.size.height;
}
@end
