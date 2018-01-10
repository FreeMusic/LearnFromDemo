//
//  AlertView.m
//  UIalertView
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AlertView.h"
#import "ListCell.h"


#define ScreenBounds [UIScreen mainScreen].bounds
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

@interface AlertView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) NSInteger tyeTag;//区分奖励明细还是人数

@end

@implementation AlertView

+(id)GlodeBottomView{
    return [self new];
}

-(void)show{
    UIWindow *current = [UIApplication sharedApplication].keyWindow;
    self.backgroundColor = RGBA(0, 0, 0, 0.2);
    [current addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:(UIViewAnimationCurveEaseOut)];
        self.backView.frame = CGRectMake(50, 0, kScreenWidth-60*m6Scale, kScreenHeight);
    }];
}

#pragma mark - 懒加载
-(UIView*)backView{
    if (_backView == nil) {
        self.backView = [UIView new];
        _backView.bounds = CGRectMake(50, 0, kScreenWidth-60*m6Scale, kScreenHeight);
        [self addSubview:_backView];
    }
    return _backView;
}

-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    if (titleArray.count * 50 >= (kScreenHeight *3/4)) {
        self.backView.frame = CGRectMake(50, kScreenHeight *1/3, kScreenWidth-60*m6Scale, kScreenHeight);
        
        self.tableView.frame = CGRectMake(30*m6Scale, kScreenHeight *1/3-150, kScreenWidth-60*m6Scale, kScreenHeight *3/4);
    }else{
        self.backView.frame = CGRectMake(50, kScreenHeight -  titleArray.count * 50, kScreenWidth-60*m6Scale, kScreenHeight);
        
        self.tableView.frame = CGRectMake(30*m6Scale, kScreenHeight -  self.titleArray.count * 50 , kScreenWidth-60*m6Scale, titleArray.count * 50);
    }
}


#pragma UITableView-delegate

-(UITableView*)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(30*m6Scale, 0, kScreenWidth-60*m6Scale, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.backView addSubview:_tableView];
    }
    return _tableView;
}
#pragma mark -cellForRowAtIndexPath
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tyeTag == 1) {
        ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[ListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        return cell;
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HCJF];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HCJF];
        }
        cell.imageView.image = [UIImage imageNamed:@"钱袋"];
        cell.textLabel.text = @"邀请好友红包";
        cell.detailTextLabel.text = @"¥ 20";
        cell.detailTextLabel.textColor = buttonColor;
        return cell;
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    //奖励明细
    UIButton *detailBtn = [[UIButton alloc] init];
    [detailBtn setTitle:@"奖励明细" forState:(UIControlStateNormal)];
    [detailBtn setTitleColor:RGB(83, 83, 83) forState:(UIControlStateNormal)];
    [detailBtn addTarget:self action:@selector(detailBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [headerView addSubview:detailBtn];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left);
        make.top.equalTo(headerView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 90*m6Scale));
    }];
    //灰线
    CALayer *messageLayer = [[CALayer alloc] init];
    messageLayer.frame = CGRectMake(30*m6Scale, 100 * m6Scale, kScreenWidth - 100*m6Scale, 0.5);
    messageLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [headerView.layer addSublayer:messageLayer];
    //灰线
    CALayer *shouwLayer = [[CALayer alloc] init];
    shouwLayer.frame = CGRectMake(kScreenWidth/2 - 40*m6Scale, 20*m6Scale, 0.5, 60*m6Scale);
    shouwLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [headerView.layer addSublayer:shouwLayer];
    //邀请人数
    UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [numBtn setTitle:@"邀请人数" forState:(UIControlStateNormal)];
    [numBtn setTitleColor:buttonColor forState:(UIControlStateNormal)];
    [numBtn addTarget:self action:@selector(numBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [headerView addSubview:numBtn];
    [numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right);
        make.top.equalTo(headerView.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 90*m6Scale));
    }];

    return headerView;
}
/**
 奖励明细
 */
-(void)detailBtn:(UIButton*)bt{
    _tyeTag = 2;
    [_tableView reloadData];
}
/**
 人数
 */
- (void)numBtn:(UIButton *)sender{
    _tyeTag = 1;
    [_tableView reloadData];
}
#pragma mark -didSelectRowAtIndexPath
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(clickButton:)]) {
        [self.delegate clickButton:indexPath.row];
    }if (self.GlodeBottomView) {
        self.GlodeBottomView(indexPath.row,self.titleArray[indexPath.row]);
    }
    [self dissMIssView];
}
/**
 点击退出
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dissMIssView];
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    self.frame = ScreenBounds;
}
/**
 点击退出
 */
-(void)dissMIssView{
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:(UIViewAnimationCurveEaseIn)];
        self.backView.frame = CGRectMake(50, kScreenHeight, kScreenWidth-60*m6Scale, kScreenHeight);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
//    }
//}


@end
