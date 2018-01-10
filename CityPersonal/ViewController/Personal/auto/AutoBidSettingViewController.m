//
//  AutoBidSettingViewController.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "AutoBidSettingViewController.h"
#import "InvestCountCell.h"
#import "InvestTypeCell.h"
#import "InvestEndCell.h"
#import "DetailView.h"
#import "CreatView.h"
#import "AppDelegate.h"
#import "NewAutoVC.h"
#import "CCPPickerViewTwo.h"
#import "ForgetPasswordView.h"
#import "SelectWeekView.h"
#import "TopUpVC.h"
#import "ProtocolVC.h"
#import "AutoListModel.h"

#import "AutoHeaderCell.h"
#import "AutoBidRecodeViewController.h"
#import "RechargeView.h"
#import "RulerAlterVC.h"
#import "ActivityCenterVC.h"
#import "ItemTypeView.h"

@interface AutoBidSettingViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *autoBidSetTableView;
@property (nonatomic, strong) UISwitch *lockSwitch; //是否锁定投标期限
@property (nonatomic, strong) DetailView *detailView; //数据展示表
@property (nonatomic, copy) NSString *firstDateStr; //投标期限前置条件
@property (nonatomic, copy) NSString *lastDateStr;//投标期限后置条件
@property (nonatomic, copy) NSString *firstIncomeStr;//预期收益前置条件
@property (nonatomic, copy) NSString *lastIncomeStr;//预期收益后置条件
@property (nonatomic, weak) XFDialogFrame *dialogView;//弹出框
@property (nonatomic, copy) NSString *investStr;//不同投资类型的金额
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, strong) CreatView *creatView;//蒙版
@property (nonatomic, copy) NSString *timerRandom;//验证码
@property (nonatomic, copy) NSString *validPhoneExpiredTime;//时间戳
@property (nonatomic, strong) UIButton *makeSureButton;//确定按钮
@property (nonatomic, strong) InvestCountCell *cell;
@property (nonatomic, strong) UITextField *textField;//文本框
@property (nonatomic, strong) ForgetPasswordView *passwordView;//验证码输入
@property (nonatomic, strong) SelectWeekView *selectWeekView;
@property (nonatomic, strong) UILabel *numPersonal;//开启人数
@property (nonatomic, strong) UIButton *selectButton;//协议选择按钮
@property (nonatomic, strong) AutoListModel *autoListModel;
@property (nonatomic, strong) NSString *rank;//排名
@property (nonatomic, strong) NSString *account;//累计投资
@property (nonatomic, strong) NSString *person;//自动投标累计开启人数
@property (nonatomic, strong) NSString *rest;//剩余可投金额
@property (nonatomic, strong) NSString *money;//投资总额
@property (nonatomic, assign) NSInteger allow;
@property (nonatomic, strong) RechargeView *rechargeView;//输入交易密码弹出视图
@property (nonatomic, strong) NSString *protocol;//记录页面是否已经创建了
@property (nonatomic, assign) NSInteger index;//记录点击投资总额输入框的次数
@property (nonatomic, strong) NSString *itemType;//标的类型 0 不限 1.学车宝 2.车商宝 3.车贷宝 4.车易保

@end

@implementation AutoBidSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    
    self.navigationController.navigationBar.translucent = NO;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"自动投标设置"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //右边按钮
    UIButton *rightBtn = [Factory addRightbottonToVC:self andImageName:@"自动投标记录"];
    [rightBtn addTarget:self action:@selector(onClickRight) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.autoBidSetTableView];//tableview
    //修改自动投标金额的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zyynoti:) name:@"zyyAuto" object:nil];
    //获取加密因子和密码
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sxyRecharge:) name:@"sxyRecharge" object:nil];
    
    _numPersonal = [UILabel new];//开启人数
    //自动投标累计开启人数
    [self countUsePeople];
    //请求网络数据
    [self serviceData];
    
    self.protocol = @"10";
}
/**
 自动投标记录
 */
- (void)onClickRight{
    AutoBidRecodeViewController *autoBid = [AutoBidRecodeViewController new];
    self.protocol = @"0";
    [self.navigationController pushViewController:autoBid animated:YES];
}
/**
 *自动投标累计开启人数
 */
- (void)countUsePeople{
    //自动投标累计开启人数
    [DownLoadData postCountUsePeople:^(id obj, NSError *error) {
        self.person = [NSString stringWithFormat:@"%@", obj[@"usePeople"]];
        [self.autoBidSetTableView reloadData];
    }];
}
/**
 *请求数据
 */
- (void)serviceData{
    //自动投标查询
    [DownLoadData postGetAuto:^(id obj, NSError *error) {
        _autoListModel = obj[@"model"];
        if (!_autoListModel) {
            //假如自动投标查询没有数据  说明用户还没有开启自动投标
            _firstDateStr = @"15";
            _firstIncomeStr = @"7";
            
            _lastDateStr = @"360";
            _lastIncomeStr = @"15";
        }
        [self.autoBidSetTableView reloadData];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
    //自动投标排名
    [DownLoadData postGetRankByUserId:^(id obj, NSError *error) {
        self.rank = [NSString stringWithFormat:@"%@", obj[@"rank"]];
        [self.autoBidSetTableView reloadData];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
    //自动投标累计在投
    [DownLoadData postCountInvestingByUserId:^(id obj, NSError *error) {
        self.account = [NSString stringWithFormat:@"%@", obj[@"invseting"]];
        [self.autoBidSetTableView reloadData];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
    //自动投标统计余额
    [DownLoadData postCountBalance:^(id obj, NSError *error) {
        self.rest = obj[@"balance"];
        [self.autoBidSetTableView reloadData];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *输入交易密码弹出视图
 */
- (RechargeView *)rechargeView{
    if(!_rechargeView){
        _rechargeView = [[RechargeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _rechargeView.styleLabel.text = @"";
        
        [[UIApplication sharedApplication].keyWindow addSubview:_rechargeView];
    }
    return _rechargeView;
}
//自动投标金额的监听
- (void)zyynoti:(NSNotification *)cender{
    NSLog(@"%@",cender.userInfo);
    _investmoney = cender.userInfo[@"moneyText"];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 懒加载
- (UITableView *)autoBidSetTableView {
    
    if (!_autoBidSetTableView) {
        _autoBidSetTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _autoBidSetTableView.delegate = self;
        _autoBidSetTableView.dataSource = self;
        _autoBidSetTableView.separatorColor = SeparatorColor;
        _autoBidSetTableView.scrollsToTop = NO;
        
        _autoBidSetTableView.sectionHeaderHeight = 0;
        _autoBidSetTableView.sectionFooterHeight = 15*m6Scale;
    }
    return _autoBidSetTableView;
}
/**
 是否锁定自动投标
 */
- (UISwitch *)lockSwitch {
    
    if (_lockSwitch == nil) {
        _lockSwitch = [[UISwitch alloc] init];
        _lockSwitch.on = NO;
        [_lockSwitch addTarget:self action:@selector(switchValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _lockSwitch;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 2;
    }else if (section == 3){
        return 3;
    }else{
        return 1;
    }
}
#pragma mark -cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *HeaderCell = @"AutoHeaderCell";
    static NSString *TableViewCell = @"UITableViewCell";
    NSArray *name = @[@"标的类型",@"投标标的期限",@"投标利率区间"];
    if (indexPath.section == 0) {
        AutoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCell];
        if (!cell) {
            cell = [[AutoHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeaderCell];
        }
        
        [cell cellForRank:self.rank Account:self.account];
        
        return cell;
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCell];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"开启自动投标";
        [cell.contentView addSubview:self.lockSwitch];
        //根据返回的数据判断开关开启的状态
        NSNumber *status = _autoListModel.itemStatus;
        if (status.integerValue) {
            
            self.lockSwitch.on = YES;
        }else{
            
            self.lockSwitch.on = NO;
        }
        [self.lockSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).offset(-30);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
        //开启人数
        _numPersonal.text = [NSString stringWithFormat:@"已有%ld人开启", (long)self.person.integerValue];
        _numPersonal.textColor = [UIColor lightGrayColor];
        _numPersonal.font = [UIFont systemFontOfSize:30*m6Scale];
        [cell.contentView addSubview:_numPersonal];
        [_numPersonal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.centerX.mas_equalTo(cell.mas_centerX);
        }];
        cell.detailTextLabel.hidden = YES;
        cell.accessoryType = NO;
        
        return cell;
    }else if (indexPath.section == 2) {//投资
        _cell = [tableView dequeueReusableCellWithIdentifier:@"investCount"];
        if (!_cell) {
            _cell = [[InvestCountCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"investCount"];
            _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        _cell.tag = 10000+indexPath.row;
        if (indexPath.row) {
            _cell.investTypeLabel.text = @"";
            _cell.backgroundColor = [UIColor clearColor];
            UIImageView *image= [UIImageView new];
            image.image = [UIImage imageNamed:@"autoBidSetImage"];
            [_cell.contentView addSubview:image];
            if (self.rest.integerValue) {
                _cell.detailTextLabel.text = [NSString stringWithFormat:@"当前自动投标剩余可投金额%@元", self.rest];
            }else{
                _cell.detailTextLabel.text = @"当前自动投标剩余可投金额0元";
            }
            _cell.detailTextLabel.font = [UIFont systemFontOfSize:30*m6Scale];
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_cell.detailTextLabel.mas_left);
                make.centerY.mas_equalTo(_cell.detailTextLabel);
                make.size.mas_offset(CGSizeMake(30*m6Scale, 30*m6Scale));
            }];
        }else{
            self.moneyType = _cell.investTypeLabel;//金额类型
            self.money = [NSString stringWithFormat:@"%@", _autoListModel.itemAmount];//输入的金额
            _cell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
            [_cell inverstMoney:self.money andTag:@"" andIndex:1];
            _investTextField = _cell.investTextField;
            _cell.investTextField.delegate = self;
            //给投资总额添加监听输入事件
            [_investTextField addTarget:self action:@selector(textFiledChanged:) forControlEvents:UIControlEventEditingChanged];
            _investTextField.delegate = self;
            _cell.investTextField.userInteractionEnabled = (self.lockSwitch.on == YES) ? YES : NO;
            if (self.money.integerValue) {
                _investTextField.text = self.money;
            }
        }
        return _cell;
    }else {
        UITableViewCell *clipCell = [tableView dequeueReusableCellWithIdentifier:@"investType"];
        if (!clipCell) {
            
            clipCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HCJF];
            clipCell.selectionStyle = UITableViewCellSelectionStyleNone;
            clipCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        clipCell.tag = indexPath.row+1000;
        clipCell.textLabel.text = name[indexPath.row];
        clipCell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        if (indexPath.row == 1) {
            if (_dataStr.length == 0) {
                if (_autoListModel) {
                    clipCell.detailTextLabel.text = [NSString stringWithFormat:@"%@天~%@天", _autoListModel.itemDayMin, _autoListModel.itemDayMax];
                    _firstDateStr = [NSString stringWithFormat:@"%@",_autoListModel.itemDayMin];
                    _lastDateStr = [NSString stringWithFormat:@"%@", _autoListModel.itemDayMax];
                }else{
                    clipCell.detailTextLabel.text = @"不限";
                }
            }else{
                clipCell.detailTextLabel.text = _dataStr;//投标期限
            }
        }else if(indexPath.row == 2){
            if (_dataStr.length == 0) {
                if (_autoListModel) {
                    clipCell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f%@~%.1f%@", _autoListModel.itemRateMin.floatValue,@"%", _autoListModel.itemRateMax.floatValue, @"%"];
                    _firstIncomeStr = [NSString stringWithFormat:@"%@",_autoListModel.itemRateMin];
                    _lastIncomeStr = [NSString stringWithFormat:@"%@", _autoListModel.itemRateMax];
                }else{
                    clipCell.detailTextLabel.text = @"不限";
                }
            }else{
                clipCell.detailTextLabel.text = _incomeStr;//预期收益
            }
        }else{
            clipCell.detailTextLabel.text = [self userInvestItemType:_autoListModel.itemType];
        }
        return clipCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 180*m6Scale;
    }else{
        if (indexPath.section == 1 && indexPath.row == 1) {
            return 60*m6Scale;
        }else{
            return 100*m6Scale;
        }
    }
}
/**
 *  获取用户的标的类型
 */
- (NSString *)userInvestItemType:(NSNumber *)type{
    
    NSString *str;
    
    switch (type.integerValue) {
        case 0:
            str = @"不限";
            break;
            
        case 1:
            str = @"学车宝";
            break;
            
        case 2:
            str = @"车商宝";
            break;
            
        case 3:
            str = @"车贷宝";
            break;
            
        default:
            str = @"不限";
            break;
    }
    
    return str;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section != 3){
        return 21*m6Scale;
    }
    else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 300*m6Scale;
    }else{
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 3) {
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60 * m6Scale)];
        //前面的图片
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"autoBidSetCancle"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        _selectButton.selected = YES;
        [_selectButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:_selectButton];
        [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footView.mas_left).offset(30 * m6Scale);
            make.top.mas_equalTo(footView.mas_top).offset(30*m6Scale);
            make.size.mas_equalTo(CGSizeMake(30 * m6Scale, 30 * m6Scale));
        }];
        //锁定自动投标授权书
        UILabel *noticeLabel = [[UILabel alloc] init];
        noticeLabel.textColor = [UIColor lightGrayColor];
        noticeLabel.font = [UIFont systemFontOfSize:30*m6Scale];
        noticeLabel.userInteractionEnabled = YES;
        noticeLabel.text = @"《自动投标授权书》";
        //手势
        UITapGestureRecognizer * singleRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(autoResgister:)];
        singleRecognizer.numberOfTapsRequired = 1;
        [noticeLabel addGestureRecognizer:singleRecognizer];
        [footView addSubview:noticeLabel];
        [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_selectButton.mas_right).offset(10*m6Scale);
            make.top.mas_equalTo(footView.mas_top).offset(28*m6Scale);
        }];
        //确定按钮
        _makeSureButton = [SubmitBtn buttonWithType:UIButtonTypeCustom];
        [_makeSureButton addTarget:self action:@selector(startQuickSureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if(_autoListModel){
             [_makeSureButton setTitle:@"修改" forState:UIControlStateNormal];
        }else{
             [_makeSureButton setTitle:@"确定" forState:UIControlStateNormal];
        }
        [_makeSureButton setTitleColor:[UIColor whiteColor] forState:0];
        _makeSureButton.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
        _makeSureButton.userInteractionEnabled = NO;
        [footView addSubview:_makeSureButton];
        [_makeSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footView.mas_left).offset(30 * m6Scale);
            make.top.equalTo(footView.mas_top).offset(80 * m6Scale);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth - 60*m6Scale, 90 * m6Scale));
        }];
        //规则说明
        UILabel *rulesLabel = [[UILabel alloc] init];
        rulesLabel.textColor = ButtonColor;
        rulesLabel.font = [UIFont systemFontOfSize:30*m6Scale];
        rulesLabel.userInteractionEnabled = YES;
        rulesLabel.text = @"规则说明>>";
        //手势
        UITapGestureRecognizer * singleRe =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rulesResgister:)];
        singleRe.numberOfTapsRequired = 1;
        [rulesLabel addGestureRecognizer:singleRe];
        [footView addSubview:rulesLabel];
        [rulesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(footView.mas_centerX);
            make.top.mas_equalTo(_makeSureButton.mas_bottom).offset(40*m6Scale);
        }];
        return footView;
        
    }
    else {
        
        return nil;
    }
}
#pragma mark -didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (indexPath.section == 3 && indexPath.row == 1) {
        if (_lockSwitch.on == NO) {
            [Factory alertMes:@"开启自动投标按钮已关闭,不能选择"];
        }else{
            if (self.lockSwitch.on) {
                _makeSureButton.userInteractionEnabled = YES;
                _makeSureButton.backgroundColor = ButtonColor;
            }
            //选择器
            CCPPickerViewTwo *pickerViewTwo = [[CCPPickerViewTwo alloc] initWithpickerViewWithCenterTitle:@"投标期限" andCancel:@"取消" andSure:@"确定" andtag:0];
            
            [pickerViewTwo pickerVIewClickCancelBtnBlock:^{
                
                NSLog(@"取消");
                
            } sureBtClcik:^(NSString *leftString, NSString *rightString, NSString *leftAndRightString) {
                
                NSLog(@"%@=======%@=======%@",leftString,rightString,leftAndRightString);
                _dataStr = leftAndRightString;
                if ([leftString isEqualToString:@"自动"] && [rightString isEqualToString:@"自动"]) {
                    _firstDateStr = @"15";
                    _lastDateStr = @"360";
                }else if ([leftString isEqualToString:@"自动"] || [rightString isEqualToString:@"自动"]){
                    if ([leftString isEqualToString:@"自动"]) {
                        _firstDateStr = @"15";
                        _lastDateStr = [NSString stringWithFormat:@"%ld",(long)rightString.integerValue];
                    }else{
                        _firstDateStr = [NSString stringWithFormat:@"%ld",(long)leftString.integerValue];
                        _lastDateStr = @"360";
                    }
                }else{
                    _firstDateStr = [NSString stringWithFormat:@"%ld",(long)leftString.integerValue];
                    _lastDateStr = [NSString stringWithFormat:@"%ld",(long)rightString.integerValue];
                }
                //tableView刷新某一行数据
                [self.autoBidSetTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:3], nil] withRowAnimation:UITableViewRowAnimationNone];
                
            }];
        }
    }else if(indexPath.section == 3 && indexPath.row == 2){
        if (self.lockSwitch.on == NO) {
            [Factory alertMes:@"开启自动投标按钮已关闭,不能选择"];
        }else{
            if (self.lockSwitch.on) {
                _makeSureButton.userInteractionEnabled = YES;
                _makeSureButton.backgroundColor = ButtonColor;
            }
            CCPPickerViewTwo *pickerViewTwo = [[CCPPickerViewTwo alloc] initWithpickerViewWithCenterTitle:@"投标利率" andCancel:@"取消" andSure:@"确定" andtag:1];
            
            [pickerViewTwo pickerVIewClickCancelBtnBlock:^{
                
                NSLog(@"取消");
                
            } sureBtClcik:^(NSString *leftString, NSString *rightString, NSString *leftAndRightString) {
                
                NSLog(@"%@=======%@=======%@",leftString,rightString,leftAndRightString);
                _incomeStr = leftAndRightString;//显示的范围
                if ([leftString isEqualToString:@"自动"] && [rightString isEqualToString:@"自动"]) {
                    _firstIncomeStr = @"7";
                    _lastIncomeStr = @"15";
                }else if ([leftString isEqualToString:@"自动"] || [rightString isEqualToString:@"自动"]){
                    if ([leftString isEqualToString:@"自动"]) {
                        _firstIncomeStr = @"7";
                        _lastIncomeStr = [NSString stringWithFormat:@"%ld",(long)rightString.integerValue];
                    }else{
                        _lastIncomeStr = @"15";
                        _firstIncomeStr = [NSString stringWithFormat:@"%ld",(long)leftString.integerValue];
                    }
                }else{
                    _firstIncomeStr = [NSString stringWithFormat:@"%ld",(long)leftString.integerValue];
                    _lastIncomeStr = [NSString stringWithFormat:@"%ld",(long)rightString.integerValue];
                }
                
                NSLog(@"%ld",(long)leftString.integerValue);
                //tableView刷新某一行数据
                [self.autoBidSetTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:3], nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
    }else if(indexPath.section == 2 && indexPath.row == 0){
        if (self.lockSwitch.on) {
            _makeSureButton.userInteractionEnabled = YES;
            _makeSureButton.backgroundColor = ButtonColor;
        }
    }else if (indexPath.section == 3 && indexPath.row == 0){
        
        if (self.lockSwitch.on) {
            
            _makeSureButton.userInteractionEnabled = YES;
            _makeSureButton.backgroundColor = ButtonColor;
            
            __block NSString *type;
            __block NSString *date;
            __block NSString *rate;
            __weak typeof(self) weakSelf = self;
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"不限" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                type = @"不限";
                date = @"15天-360天";
                rate = @"7%-15%";
                weakSelf.firstDateStr = @"15";
                weakSelf.lastDateStr = @"360";
                weakSelf.firstIncomeStr = @"7";
                weakSelf.lastIncomeStr = @"15";
                weakSelf.itemType = @"0";
                //标的类型
                UITableViewCell *typeCell = (UITableViewCell *)[weakSelf.view viewWithTag:1000];
                //标的期限
                UITableViewCell *dateCell = (UITableViewCell *)[weakSelf.view viewWithTag:1001];
                //利率
                UITableViewCell *rateCell = (UITableViewCell *)[weakSelf.view viewWithTag:1002];
                
                typeCell.detailTextLabel.text = type;
                dateCell.detailTextLabel.text = date;
                rateCell.detailTextLabel.text = rate;
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"车贷宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                type = @"车贷宝";
                date = @"15天-45天";
                rate = @"7%-10%";
                weakSelf.firstDateStr = @"15";
                weakSelf.lastDateStr = @"45";
                weakSelf.firstIncomeStr = @"7";
                weakSelf.lastIncomeStr = @"10";
                weakSelf.itemType = @"3";
                //标的类型
                UITableViewCell *typeCell = (UITableViewCell *)[weakSelf.view viewWithTag:1000];
                //标的期限
                UITableViewCell *dateCell = (UITableViewCell *)[weakSelf.view viewWithTag:1001];
                //利率
                UITableViewCell *rateCell = (UITableViewCell *)[weakSelf.view viewWithTag:1002];
                
                typeCell.detailTextLabel.text = type;
                dateCell.detailTextLabel.text = date;
                rateCell.detailTextLabel.text = rate;
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"车商宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                type = @"车商宝";
                date = @"90天-360天";
                rate = @"9%-12%";
                weakSelf.firstDateStr = @"90";
                weakSelf.lastDateStr = @"360";
                weakSelf.firstIncomeStr = @"9";
                weakSelf.lastIncomeStr = @"12";
                weakSelf.itemType = @"2";
                //标的类型
                UITableViewCell *typeCell = (UITableViewCell *)[weakSelf.view viewWithTag:1000];
                //标的期限
                UITableViewCell *dateCell = (UITableViewCell *)[weakSelf.view viewWithTag:1001];
                //利率
                UITableViewCell *rateCell = (UITableViewCell *)[weakSelf.view viewWithTag:1002];
                
                typeCell.detailTextLabel.text = type;
                dateCell.detailTextLabel.text = date;
                rateCell.detailTextLabel.text = rate;
                
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"学车宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                type = @"学车宝";
                date = @"90天-360天";
                rate = @"9%-12%";
                weakSelf.firstDateStr = @"90";
                weakSelf.lastDateStr = @"360";
                weakSelf.firstIncomeStr = @"9";
                weakSelf.lastIncomeStr = @"12";
                weakSelf.itemType = @"1";
                //标的类型
                UITableViewCell *typeCell = (UITableViewCell *)[weakSelf.view viewWithTag:1000];
                //标的期限
                UITableViewCell *dateCell = (UITableViewCell *)[weakSelf.view viewWithTag:1001];
                //利率
                UITableViewCell *rateCell = (UITableViewCell *)[weakSelf.view viewWithTag:1002];
                
                typeCell.detailTextLabel.text = type;
                dateCell.detailTextLabel.text = date;
                rateCell.detailTextLabel.text = rate;
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }
}
#pragma mark - 值变换事件
- (void)switchValueChangeAction:(UISwitch *)sender {
    /**
     *  判断switch是否开启，开启存YES到沙盒，关闭则存NO存入沙盒
     */
    //sender.on = !sender.on;
    InvestCountCell *cell = (InvestCountCell *)[self.view viewWithTag:10000];
    _makeSureButton.backgroundColor = ButtonColor;
    _makeSureButton.userInteractionEnabled = YES;

    
    if (sender.on) {
        self.lockSwitch.on = YES;
//        self.dataStr = @"自动 ~ 自动";
//        self.incomeStr = @"自动 ~ 自动";
        _makeSureButton.backgroundColor = ButtonColor;
        _makeSureButton.userInteractionEnabled = YES;
        cell.investTextField.userInteractionEnabled = YES;
        if (_autoListModel) {
            
        }
        NSLog(@"关闭");
    }else {
        self.lockSwitch.on = NO;
//        _makeSureButton.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
//        _makeSureButton.userInteractionEnabled = NO;
        cell.investTextField.userInteractionEnabled = NO;
        NSLog(@"开启");
    }
}
/**
 *自动投标关闭开启接口
 */
- (void)updateStatus{
//    //新状态
//    NSString *newStatus = @"";
//    //旧状态
//    NSString *oldStatus = @"";
//    if (self.lockSwitch.on) {
//        newStatus = @"1";
//        oldStatus = @"0";
//    }else{
//        newStatus = @"0";
//        oldStatus = @"1";
//    }
    NSLog(@"%@    %@", _firstDateStr, _lastDateStr);
    //修改自动投标接口
    [DownLoadData postAutoInvestAdd:^(id obj, NSError *error) {
        if ([obj[@"result"] isEqualToString:@"success"]) {
            [Factory alertMes:@"自动投标关闭成功"];
            _makeSureButton.userInteractionEnabled = NO;
            _makeSureButton.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
            //刷新数据
            [self serviceData];
        }
    } itemUserId:[HCJFNSUser stringForKey:@"userId"] autoId:[NSString stringWithFormat:@"%@", _autoListModel.ID] itemStatus:@"0" itemRateMin:_firstIncomeStr itemRateMax:_lastIncomeStr itemDayMin:_firstDateStr itemDayMax:_lastDateStr itemAmount:_investTextField.text password:@"" salt:@"" type:0 itemType:self.itemType];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _investTextField) {
        if (range.location>=7) {
            return NO;
        }
    }
    return YES;
}
/**
 *投资总额输入监听
 */
- (void)textFiledChanged:(UITextField *)textFiled{
    _cell.detailTextLabel.text = [NSString stringWithFormat:@"当前自动投标剩余可投金额%ld元", textFiled.text.integerValue-_autoListModel.investingAmount.integerValue];
    if (textFiled.text.integerValue-_autoListModel.investingAmount.integerValue < 0) {
        _cell.detailTextLabel.text = @"当前自动投标剩余可投金额0元";
    }
    if (textFiled.text.integerValue == 0) {
        textFiled.text = @"0";
    }else{
        textFiled.text = [NSString stringWithFormat:@"%ld", textFiled.text.integerValue];
    }
}
/**
 *用户输入交易密码  调用投资接口
 */
- (void)sxyRecharge:(NSNotification *)noti{
    //加密后的交易密码
    NSString *paymentPassword = noti.userInfo[@"passWord"];
    //加密因子
    NSString *mcryptKey = noti.userInfo[@"mcryptKey"];
    //自动投标swich状态
    NSString *lockStatus = @"";
    if (self.lockSwitch.on == YES) {
        lockStatus = @"1";
    }else {
        lockStatus = @"0";
    }
    self.rechargeView.hidden = YES;
    self.rechargeView.isAllow = YES;
    self.rechargeView.myTextFiled.text = @"";
    [self.rechargeView.myTextFiled resignFirstResponder];
    NSLog(@"%@   %@", _firstDateStr, _lastDateStr);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (_autoListModel) {
        //修改接口
        [DownLoadData postAutoInvestAdd:^(id obj, NSError *error) {
            [hud setHidden:YES];
            if ([obj[@"result"] isEqualToString:@"success"]) {
                _makeSureButton.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
                _makeSureButton.userInteractionEnabled = NO;
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    sleep(0.5);
                    //回到主队列
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Factory alertMes:@"自动投标修改成功"];
                        _makeSureButton.userInteractionEnabled = NO;
                        _makeSureButton.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
                        //刷新数据
                        [self serviceData];
                    });
                });
            }else{
                //失败
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    sleep(1);
                    //回到主队列
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Factory alertMes:obj[@"messageText"]];
                    });
                });
            }
        } itemUserId:[HCJFNSUser stringForKey:@"userId"] autoId:[NSString stringWithFormat:@"%@", _autoListModel.ID] itemStatus:lockStatus itemRateMin:_firstIncomeStr itemRateMax:_lastIncomeStr itemDayMin:_firstDateStr itemDayMax:_lastDateStr itemAmount:_investTextField.text password:paymentPassword salt:mcryptKey type:0 itemType:self.itemType];
    }else{
        //添加接口
        [DownLoadData postAutoInvestAdd:^(id obj, NSError *error) {
            [hud setHidden:YES];
            if ([obj[@"result"] isEqualToString:@"success"]) {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    sleep(1.0);
                    //回到主队列
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_hud hideAnimated:YES];
                        [Factory alertMes:@"自动投标设置成功"];
                        [self serviceData];
                        [self countUsePeople];
                        _makeSureButton.userInteractionEnabled = NO;
                        _makeSureButton.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
                        //刷新数据
                        [self serviceData];
                    });
                });
            }else{
                //失败
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    sleep(1);
                    //回到主队列
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Factory alertMes:obj[@"messageText"]];
                    });
                });
            }
        } itemUserId:[HCJFNSUser stringForKey:@"userId"] autoId:[NSString stringWithFormat:@"%@", _autoListModel.ID] itemStatus:lockStatus itemRateMin:_firstIncomeStr itemRateMax:_lastIncomeStr itemDayMin:_firstDateStr itemDayMax:_lastDateStr itemAmount:_investTextField.text password:paymentPassword salt:mcryptKey type:1 itemType:self.itemType];
    }
}
/**
 *  自动投标确定按钮的点击事件
 */
- (void)makeSureButtonAction {
    NSLog(@"999-+----%@",_investTextField.text);
    if (self.lockSwitch.on == YES) {
        if ([self.dataStr isEqualToString:@"自动 ~ 自动"]){
            _firstDateStr = @"15";
            _lastDateStr = @"360";
        }
        if ([self.incomeStr isEqualToString:@"自动 ~ 自动"]){
            _firstIncomeStr = @"7";
            _lastIncomeStr = @"15";
        }
    }else {
        if ([self.dataStr isEqualToString:@"自动 ~ 自动"]){
            _firstDateStr = @"15";
            _lastDateStr = @"360";
        }
        if ([self.incomeStr isEqualToString:@"自动 ~ 自动"]){
            _firstIncomeStr = @"7";
            _lastIncomeStr = @"15";
        }
    }
    //弹出交易密码输入视图
    if (_investTextField.text.floatValue < 100) {
        [Factory addAlertToVC:self withMessage:@"自动投标金额不低于100"];
    }else{
        NSLog(@"%@   %@", _firstDateStr, _lastDateStr);
        self.rechargeView.hidden = NO;
        self.rechargeView.amountLabel.text = [NSString stringWithFormat:@"￥%.2f", _investTextField.text.floatValue];
        [self.rechargeView.myTextFiled becomeFirstResponder];
        
        [self.view endEditing:YES];
    }
}
//防止连续点击
- (void)startQuickSureBtnClicked:(id)sender
{
    if (_selectButton.selected) {
        if (self.lockSwitch.on) {
            //开启自动图标
            [self makeSureButtonAction];
        }else{
            //调用自动投标关闭接口
            [self updateStatus];
        }
    }else{
        [Factory alertMes:@"请先同意自动投标授权书"];
    }
}
/**
 *开始编辑投资总额
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _makeSureButton.userInteractionEnabled = YES;
    _makeSureButton.backgroundColor = ButtonColor;
    _index++;
    if (_index == 1) {
        textField.text = @"0";
    }
}
/**
 *  锁定自动投标协议
 */
- (void)autoResgister:(UITapGestureRecognizer *)sender
{
    ProtocolVC *protocol = [ProtocolVC new];
    self.protocol = @"0";
    protocol.strTag = @"3";
    [self presentViewController:protocol animated:YES completion:nil];
}
/**
 *  协议选择按钮
 */
- (void)selectButton:(UIButton *)sender{
    _selectButton.selected = !_selectButton.selected;
}
/**
 规则说明
 */
- (void)rulesResgister:(UITapGestureRecognizer *)sender{
    ActivityCenterVC *tempVC = [ActivityCenterVC new];
    tempVC.tag = 50;
    tempVC.strUrl = @"/html/automaticBid.html";
    tempVC.urlName = @"规则说明";
    [self.navigationController pushViewController:tempVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    if (self.protocol.integerValue) {
    //        [self.autoBidSetTableView reloadData];
    //    }
    [self.navigationController.navigationBar setBarTintColor:navigationColor];
    self.navigationController.navigationBar.hidden = NO;
    [Factory hidentabar];//隐藏tabar
    [Factory navgation:self];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
/**
 *用户开始编辑输入框
 */

/**
 移除通知
 */
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
