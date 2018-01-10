//
//  FirstBankView.m
//  CityJinFu
//
//  Created by xxlc on 17/8/2.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "FirstBankView.h"
#import "OpenOneCell.h"
@interface FirstBankView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation FirstBankView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createview];
    }
    return self;
}
- (void)createview{
    self.dataArray = @[@"姓名",@"卡号"];
    [self addSubview:self.tableView];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = backGroundColor;
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22*m6Scale;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OpenOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[OpenOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.title.text = self.dataArray[indexPath.section];
    [cell.title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(90*m6Scale);
    }];
    if (indexPath.section == 0) {
        self.nameText = cell.intPut;
        self.nameText.userInteractionEnabled = NO;
    }
    else if (indexPath.section == 1){
        self.cardNoText = cell.intPut ;
        self.cardNoText.placeholder = @"请输入16-19位银行卡号";
        self.cardNoText.delegate = self;
        self.cardNoText.keyboardType = UIKeyboardTypePhonePad;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 200;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [UIView new];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.layer setBackgroundColor:ButtonColor.CGColor];
    button.layer.cornerRadius = 6*m6Scale;
    [button setTitle:@"下一步" forState:0];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footView.mas_left).offset(20*m6Scale);
        make.right.mas_equalTo(footView.mas_right).offset(-20*m6Scale);
        make.top.mas_equalTo(footView.mas_top).offset(80*m6Scale);
        make.height.mas_offset(80*m6Scale);
    }];
    return footView;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location>=19) {
        return NO;
    }
    return YES;
}
- (void)buttonClick:(UIButton *)button{
    if (self.buttonAction) {
        self.buttonAction(button);
    }
}
@end
