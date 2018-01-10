//
//  PushView.m
//  CityJinFu
//
//  Created by mic on 2017/7/4.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PushView.h"
#import "FormValidator.h"
#import "VipEquityVC.h"
#import "PushCell.h"

@interface PushView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;//数据

@end

@implementation PushView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        //白色背景View
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 10*m6Scale;
        _backView.layer.masksToBounds = YES;
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-150*m6Scale, 200*m6Scale));
        }];
        
        //弹窗内容
        _pushLabel = [Factory CreateLabelWithTextColor:0 andTextFont:30 andText:@"" addSubView:_backView];
        _pushLabel.numberOfLines = 0;
        _pushLabel.textAlignment = NSTextAlignmentCenter;
        [_pushLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_backView.mas_centerX);
            make.centerY.mas_equalTo(_backView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-170*m6Scale, 200*m6Scale));
        }];
    }
    
    return self;
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(100*m6Scale, 200*m6Scale, kScreenWidth-200*m6Scale, 200*m6Scale) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        
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
    NSString *str = @"cell";
    PushCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[PushCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    if (indexPath.row) {
        [cell setCellByEquity:self.dataSource[indexPath.row-1][@"content"] andIndex:indexPath.row];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*m6Scale;
}

/**
 *立即投资按钮
 */
- (UIButton *)investBtn{
    if(!_investBtn){
        _investBtn = [UIButton buttonWithType:0];
        [_investBtn setTitle:@"立即投资" forState:0];
        [_investBtn setTitleColor:buttonColor forState:0];
        _investBtn.backgroundColor = ButtonColor;
        _investBtn.layer.cornerRadius = 30*m6Scale;
        _investBtn.layer.masksToBounds = YES;
        [_investBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_investBtn];
        [_investBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_pushLabel.mas_bottom).offset(-10*m6Scale);
            make.left.mas_equalTo(100*m6Scale);
            make.right.mas_equalTo(-100*m6Scale);
            make.height.mas_equalTo(60*m6Scale);
        }];
    }
    return _investBtn;
}
- (void)buttonClick{
    self.hidden = YES;
    
    NSNotification *notification = [[NSNotification alloc] initWithName:@"GoToInvest" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    VipEquityVC *strVC = (VipEquityVC *)[self ViewController];
    [strVC.navigationController popToRootViewControllerAnimated:NO];
}

- (void)setPushLabelWithString:(NSString *)content andInvest:(NSString *)invest{
    NSLog(@"%@", content);
    _pushLabel.text = content;
    _pushLabel.textAlignment = NSTextAlignmentLeft;
    CGRect rect =[FormValidator rectWidthAndHeightWithStr:content AndFont:30*m6Scale WithStrWidth:kScreenWidth-190*m6Scale];
    [_pushLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_backView.mas_centerX);
        make.top.mas_equalTo(20*m6Scale);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-190*m6Scale, rect.size.height));
    }];
    //重新约束背景view
    if ([invest isEqualToString:@"YES"]) {
        
        self.investBtn.hidden = NO;
        
        [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_pushLabel.mas_top).offset(-10*m6Scale);
            make.bottom.mas_equalTo(self.investBtn.mas_bottom).offset(10*m6Scale);
            make.width.mas_equalTo(kScreenWidth-150*m6Scale);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }else{
       [self remakeBackViewWithBottom:20];
        self.investBtn.hidden = YES;
    }
}

- (void)setTableViewCellByArray:(NSArray *)array{
    self.dataSource = array;
    _backView.hidden = NO;
    [_backView addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_backView.mas_centerX);
        make.top.mas_equalTo(20*m6Scale);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-256*m6Scale, 50*m6Scale*(array.count+1)));
    }];
    self.investBtn.hidden = NO;
    [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_pushLabel.mas_top).offset(-10*m6Scale);
        make.bottom.mas_equalTo(_pushLabel.mas_bottom).offset(10*m6Scale);
        make.width.mas_equalTo(kScreenWidth-176*m6Scale);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

/**
 *重新约束背景view
 */
- (void)remakeBackViewWithBottom:(NSInteger)bottom{
    [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_pushLabel.mas_top).offset(-10*m6Scale);
        make.bottom.mas_equalTo(_pushLabel.mas_bottom).offset(10*m6Scale);
        make.width.mas_equalTo(kScreenWidth-150*m6Scale);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GoToInvest" object:nil];
}

@end
