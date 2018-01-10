//
//  TopUpView.m
//  CityJinFu
//
//  Created by mic on 2017/7/20.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "TopUpView.h"
#import "TopCell.h"
#import "FormValidator.h"
#import "TopUpVC.h"
#import "BidCardVC.h"

@interface TopUpView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger bankIndex;//记录用户点击了那个单元格

@end

@implementation TopUpView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [self addSubview:self.backView];
        //标题
        UILabel *label = [Factory CreateLabelWithTextColor:0.4 andTextFont:28 andText:@"选择充值方式" addSubView:self.backView];
        label.textAlignment = NSTextAlignmentCenter;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(84*m6Scale);
        }];
        //删除按钮
        _btn = [UIButton buttonWithType:0];
        _btn.hidden = YES;
        [_btn setImage:[UIImage imageNamed:@"shangchu"] forState:0];
        [_btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(84*m6Scale, 84*m6Scale));
        }];
        
        //单线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
        [label addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        [self.backView addSubview:self.tableView];
        
    }
    
    return self;
}
/**
 *背景View
 */
- (UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 90*m6Scale*self.dataSource.count+104*m6Scale+84*m6Scale)];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
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
    return self.dataSource.count+1;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataSource.count) {
        NSString *str = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
            UIImageView *image = [UIImageView new];
            image.image = [UIImage imageNamed:@"银行卡"];
            [cell.contentView addSubview:image];
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.contentView.mas_left).offset(20*m6Scale);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
            UILabel *addCardLabel = [Factory CreateLabelWithTextColor:0.5 andTextFont:30 andText:@"添加银行卡付款" addSubView:cell.contentView];
            addCardLabel.textColor = [UIColor blackColor];
            [addCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(image.mas_right).offset(20*m6Scale);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
        }
        cell.selectionStyle = NO;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }else{
        NSString *str = @"cell";
        TopCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[TopCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        if (_bankIndex) {
            [cell cellForIndex:_bankIndex andAllIndex:indexPath.row];
        }else{
//            BankListModel *model = self.dataSource[indexPath.row];
            [cell cellForModel:self.dataSource[indexPath.row] andIndex:_index andIndexPath:indexPath];
        }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataSource.count) {
        BankListModel *model = self.dataSource[indexPath.row];
        NSString *content = [NSString stringWithFormat:@"%@", model.remark];
        CGRect rect =[FormValidator rectWidthAndHeightWithStr:content AndFont:24*m6Scale WithStrWidth:kScreenWidth-160*m6Scale];
        
        return 90*m6Scale;
    }else{
        return 104*m6Scale;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSource.count == indexPath.row) {
        [self sxySkipToBidCard];
    }else{
        BankListModel *model = self.dataSource[indexPath.row];
        _bankIndex = indexPath.row+100;
        
        [self.tableView reloadData];
        //用户点击某个银行卡  需要将银行卡信息传到充值界面
        NSNotification *notification = [[NSNotification alloc] initWithName:@"chooseBank" object:nil userInfo:@{@"model":model, @"index":[NSString stringWithFormat:@"%ld", indexPath.row]}];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        _btn.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight*0.6);
        } completion:^(BOOL finished) {
            self.hidden = YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPayCompanyType" object:nil];
        }];
    }
}

- (void)viewWithModel:(NSArray *)array andIndex:(NSInteger)index{
    
    if (90*m6Scale*array.count+104*m6Scale < kScreenHeight*0.6-84*m6Scale) {
        _tableView.frame = CGRectMake(0, 84*m6Scale, kScreenWidth, 90*m6Scale*array.count+104*m6Scale);
    }else{
        _tableView.frame = CGRectMake(0, 84*m6Scale, kScreenWidth, kScreenHeight*0.6-84*m6Scale);
    }
    
    self.dataSource = array;
    _index = index;
    [self.tableView reloadData];
}

- (void)buttonClick{
    _btn.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight*0.6);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        
    }];
}

- (void)sxySkipToBidCard{
    _btn.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight*0.6);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        NSNotification *notification = [[NSNotification alloc] initWithName:@"sxySkipToBidCard" object:nil userInfo:nil];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
