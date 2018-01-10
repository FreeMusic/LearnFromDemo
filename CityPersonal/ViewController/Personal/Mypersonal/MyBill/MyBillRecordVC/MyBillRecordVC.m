//
//  MyBillRecordVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/7.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyBillRecordVC.h"
#import "MyBillRecordCell.h"
#import "BillInvestModel.h"
#import "BillIncomeModel.h"
#import "ActivityCenterVC.h"

#define Blue [UIColor colorWithRed:100.0 / 255.0 green:166.0 / 255.0 blue:248.0/255.0 alpha:1.0]
#define DIC_EXPANDED @"expanded" //是否是展开 0收缩 1展开
#define DIC_ARARRY @"array" //存放数组
#define DIC_TITILESTRING @"title"


@interface MyBillRecordVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,  strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *DataArray;
@property (nonatomic, strong) BillInvestModel *investModel;//投资接口数据
@property (nonatomic, strong) BillIncomeModel *incomeModel;//回款接口数据
@property (nonatomic, strong) NSMutableArray *mutaArr;//付息表数据
@property (nonatomic, strong) NSString *itemID;//investID
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, assign) NSInteger collectStatus;//交易状态：0-还款中 1-已还款

@end

@implementation MyBillRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    if (_section == 2) {
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"投资记录"];
    }else{
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"回款记录"];
    }
    self.view.backgroundColor = Colorful(241, 242, 243);
    //左边返回按钮
    UIButton *leftBtn = [Factory addLeftbottonToVC:self];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableView];
    //请求数据
    [self serviceData];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
    }
    return _tableView;
}
/**
 * 返回
 */
- (void)leftBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *请求数据
 */
- (void)serviceData{
    if (_section == 2) {
        //获取单个投资详情
        [DownLoadData postGetInvestDetails:^(id obj, NSError *error) {
            _investModel = obj[@"Model"];
            self.itemID = [NSString stringWithFormat:@"%@", _investModel.ID];
            //付息表数据请求
            [self initDataSource];
            [self.tableView reloadData];
        } investId:self.investID];
    }else{
        //获取单个回款记录详情
        [DownLoadData postGetCollectDetails:^(id obj, NSError *error) {
            _incomeModel = obj[@"Model"];
            self.itemID = [NSString stringWithFormat:@"%@", _incomeModel.investId];
            //付息表数据请求
            [self initDataSource];
            [self.tableView reloadData];
        } collectId:self.investID];
    }
}

- (NSMutableArray *)DataArray{
    if(!_DataArray){
        _DataArray = [NSMutableArray array];
    }
    return _DataArray;
}
/**
 *付息表模型数组
 */
- (NSMutableArray *)mutaArr{
    if(!_mutaArr){
        _mutaArr = [NSMutableArray array];
    }
    return _mutaArr;
}
/**
 *标题标签
 */
- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:32*m6Scale];
    }
    return _titleLabel;
}
//初始化数据
- (void)initDataSource{
    //付息表数据请求
    [DownLoadData postGetCollectListByinvestId:^(id obj, NSError *error) {
        self.mutaArr = obj[@"SUCCESS"];
        for (int i = 0 ; i < 5; i++) {
            
            NSMutableArray *array=[[NSMutableArray alloc] init];
            
            for (int j = 0; j < 5;j++) {
                
                NSString *string=[NSString stringWithFormat:@"%i组-%i行",i,j];
                
                [array addObject:string];
                
            }
            
            //创建一个字典 包含数组，分组名，是否展开的标示
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:array,DIC_ARARRY,[NSNumber numberWithInt:0],DIC_EXPANDED,nil];
            //将字典加入数组
            [self.DataArray addObject:dic];
        }
        [self.tableView reloadData];
    } investId:self.itemID];    //创建一个数组
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        if (_section == 2) {
            return 6;
        }else{
            return 5;
        }
    }else if (section == 2){
        return 2;
    }else if(section == 3){
        NSMutableDictionary *dic = nil;
        if (self.DataArray.count) {
            dic = [_DataArray objectAtIndex:section];
        }
        //        NSArray *array = [dic objectForKey:DIC_ARARRY];
        //判断是收缩还是展开
        if ([[dic objectForKey:DIC_EXPANDED] intValue]) {
            if (self.mutaArr.count) {
                return self.mutaArr.count+1;
            }else{
                return 0;
            }
        }else{
            return 0;
        }
    }else{
        return 1;
    }
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        static NSString *reuse = @"MyBillRecordCell";
        MyBillRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[MyBillRecordCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        }
        if (indexPath.row > 0) {
            if (self.mutaArr.count>0) {
                [cell cellForModel:self.mutaArr[indexPath.row-1] IndexPath:indexPath];
            }
        }
        
        return cell;
    }else{
        static NSString *reuse = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        }
        cell.selectionStyle = NO;
        [self cellForContentWithCell:cell andIndexPath:indexPath];
        
        return cell;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        //背景图
        UIView *sectionView = [[UIView alloc] init];
        //橙色竖线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = Colorful(248, 175, 105);
        [sectionView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25*m6Scale);
            make.centerY.mas_equalTo(sectionView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(2, 35*m6Scale));
        }];
        //标题
        [sectionView addSubview:self.titleLabel];
        if (_section == 2) {
            if (_investModel.itemName == nil) {
                self.titleLabel.text = @"";
            }else{
                self.titleLabel.text = [NSString stringWithFormat:@"%@", _investModel.itemName];
            }
        }else{
            if (_incomeModel.itemName == nil) {
                self.titleLabel.text = @"";
            }else{
                self.titleLabel.text = [NSString stringWithFormat:@"%@", _incomeModel.itemName];
            }
        }
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line.mas_right).offset(15*m6Scale);
            make.centerY.mas_equalTo(sectionView.mas_centerY);
        }];
        //还款中
        UILabel *statusLabel = [Factory CreateLabelWithTextRedColor:100 GreenColor:166 BlueColor:248 andTextFont:28 andText:@"" addSubView:sectionView];
        NSString *status = @"";
        if (_section == 2) {
            //(投资状态 -1审核中 0-投资成功 1投资成功 2投资失败 3-投资成功)
            switch (_investModel.investStatus.integerValue) {
                case -1:
                    status = @"审核中";
                    break;
                case 0:
                    status = @"投资成功";
                    break;
                case 1:
                    status = @"投资成功";
                    break;
                case 2:
                    status = @"投资失败";
                    break;
                case 3:
                    status = @"投资成功";
                    break;
                    
                default:
                    status = @"审核中";
                    break;
            }
            statusLabel.textColor = Colorful(251, 65, 39);
        }else{
            //交易状态：0-还款中 1-已还款
            switch (_incomeModel.collectStatus.integerValue) {
                case 0:
                    status = @"还款中";
                    break;
                case 1:
                    status = @"已还款";
                    break;
                    
                default:
                    status = @"还款中";
                    break;
            }
        }
        statusLabel.text = status;
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30*m6Scale);
            make.centerY.mas_equalTo(sectionView.mas_centerY);
        }];
        
        return sectionView;
    }else if(section == 3 ){
        UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, 490*m6Scale/6)];
        hView.backgroundColor = [UIColor whiteColor];
        UIButton* eButton = [[UIButton alloc] init];
        //按钮填充整个视图
        eButton.frame = hView.frame;
        [eButton addTarget:self action:@selector(expandButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        //把节号保存到按钮tag，以便传递到expandButtonClicked方法
        eButton.tag = section;
        //设置图标
        //根据是否展开，切换按钮显示图片
        if ([self isExpanded:section]){
            
            [eButton setImage: [UIImage imageNamed: @"arrow_right_grey" ]forState:UIControlStateNormal];
        } else {
            
            [eButton setImage: [UIImage imageNamed: @"arrow_down_grey" ]forState:UIControlStateNormal];
        }
        NSString *str = @"付息表";
        [eButton setTitle:str forState:0];
        [eButton setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
        eButton.titleLabel.font = [UIFont systemFontOfSize:26*m6Scale];
        //设置button的图片和标题的相对位置
        //4个参数是到上边界，左边界，下边界，右边界的距离
        eButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [eButton setTitleEdgeInsets:UIEdgeInsetsMake(5,12*m6Scale, 0,0)];//标题
        [eButton setImageEdgeInsets:UIEdgeInsetsMake(5,self.view.bounds.size.width - 25, 0,0)];//图片
        [hView addSubview: eButton];
        
        return hView;
    }else{
        return nil;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 4) {
        UIView *footerView = [UIView new];
        UILabel *phonelab = [[UILabel alloc]init];
        phonelab.text = @"如有疑问请联系客服: 400-0571-909";
        phonelab.font = [UIFont systemFontOfSize:30*m6Scale];
        phonelab.textAlignment = NSTextAlignmentCenter;
        phonelab.textColor = [UIColor lightGrayColor];
        phonelab.userInteractionEnabled = YES;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:phonelab.text attributes:nil];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:86.0/255.0 green:196.0/255.0 blue:254.0/255.0 alpha:1.0] range:[phonelab.text rangeOfString:@"400-0571-909"]];
        phonelab.attributedText = att;
        //手势
        UITapGestureRecognizer * singleRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resgister)];
        singleRecognizer.numberOfTapsRequired = 1;
        [phonelab addGestureRecognizer:singleRecognizer];
        [footerView addSubview:phonelab];
        [phonelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footerView.mas_centerX);
            make.centerY.equalTo(footerView.mas_centerY);
        }];
        return footerView;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150*m6Scale;
    }else if (indexPath.section == 1){
        return 334*m6Scale/5;
    }else if (indexPath.section == 2){
        return 204*m6Scale/3;
    }else if (indexPath.section == 4){
        return 100*m6Scale;
    }else {
        if (self.mutaArr.count) {
            return 490*m6Scale/6;
        }else{
            return 0.01;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 93*m6Scale;
    }else if (section == 3){
        
        return 100*m6Scale;
        
    }else if (section == 4){
        return 2*m6Scale;
    }else {
        return 20 *m6Scale;
    }
}
#pragma mark-didSelectRowAtIndexPath
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
       ActivityCenterVC *tempVC = [ActivityCenterVC new];
        if (_section == 2) {
            tempVC.strUrl = _investModel.contractUrl;

        }else{
            tempVC.strUrl = _incomeModel.contractUrl;

        }
        tempVC.tag = 20;
        tempVC.urlName = @"项目合同";
        if (tempVC.strUrl&&tempVC.strUrl!=nil) {
            [self.navigationController pushViewController:tempVC animated:YES];
        }
        else{
            [Factory alertMes:@"暂无合同"];
        }
    }
}
- (void)expandButtonClicked:(id)sender{
    
    UIButton* btn = (UIButton *)sender;
    
    NSInteger section= btn.tag;//取得tag知道点击对应哪个块
    
    [self collapseOrExpand:section];
    
    //刷新tableview
    [_tableView reloadData];
    
}
#pragma mark - Action
- (int)isExpanded:(NSInteger)section{
    if (self.DataArray.count) {
        if (section == 3) {
            NSDictionary *dic = nil;
            dic = [_DataArray objectAtIndex:section];
            
            int expanded = [[dic objectForKey:DIC_EXPANDED] intValue];
            
            return expanded;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
//对指定的节进行“展开/折叠”操作,若原来是折叠的则展开，若原来是展开的则折叠
- (void)collapseOrExpand:(NSInteger)section{
    
    if (section == 3) {
        NSMutableDictionary *dic;
        dic = [_DataArray objectAtIndex:section];
        
        int expanded=[[dic objectForKey:DIC_EXPANDED] intValue];
        
        if (expanded) {
            
            [dic setValue:[NSNumber numberWithInt:0] forKey:DIC_EXPANDED];
            
        }else {
            [dic setValue:[NSNumber numberWithInt:1] forKey:DIC_EXPANDED];
        }
    }else{
        
    }
}
/**
 *UITableViewCell的内容部分
 */
- (void)cellForContentWithCell:(UITableViewCell *)cell andIndexPath:(NSIndexPath *)indexPath{
    cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:28*m6Scale];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:28*m6Scale];
    if (indexPath.section == 0) {
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (_section == 2) {
            if (_investModel) {
                cell.textLabel.text = [NSString stringWithFormat:@"预期收益：%.2f\n\n=预期利息 + 加息券", _investModel.collectInterest.floatValue];
                [Factory NSMutableAttributedStringWithString:cell.textLabel.text andChangeColorString:[NSString stringWithFormat:@"预期收益：%.2f",  _investModel.collectInterest.floatValue] andLabel:cell.textLabel];
            }else{
                cell.textLabel.text = @"预期收益：133.75\n\n= 预期利息 + 加息券";
                [Factory NSMutableAttributedStringWithString:cell.textLabel.text andChangeColorString:@"预期收益：133.75" andLabel:cell.textLabel];
            }
        }else{
            if (_incomeModel) {
                cell.textLabel.text = [NSString stringWithFormat:@"预期收益：%.2f\n\n=预期利息 + 加息券", _incomeModel.collectInterest.floatValue];
                [Factory NSMutableAttributedStringWithString:cell.textLabel.text andChangeColorString:[NSString stringWithFormat:@"预期收益：%.2f",  _incomeModel.collectInterest.floatValue] andLabel:cell.textLabel];
            }else{
                cell.textLabel.text = @"回款收益：133.75\n\n= 回款利息 + 加息利息";
                [Factory NSMutableAttributedStringWithString:cell.textLabel.text andChangeColorString:@"回款收益：133.75" andLabel:cell.textLabel];
            }
        }
    }else if (indexPath.section == 1){
        NSArray *arr = nil;
        NSMutableArray *detailsArr;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        if (_section == 2) {
            //投资记录
            arr = @[@"投资类型", @"往期年化收益", @"项目期限", @"投资金额",@"红包金额", @"项目还款方式"];
            if (_investModel) {
                //投资记录数据
                detailsArr = [self GetInvestArrData];
                cell.textLabel.text = arr[indexPath.row];
                cell.detailTextLabel.text = detailsArr[indexPath.row];
            }else{
                NSArray *tempArr = @[@"锁定自动投标",@"8.8%",@"30天",@"1000.00元",@"100.00元", @"先息后本"];
                detailsArr = [[NSMutableArray alloc] initWithArray:tempArr];
                cell.textLabel.text = arr[indexPath.row];
                cell.detailTextLabel.text = detailsArr[indexPath.row];
            }
            
        }else{
            //回款记录
            arr = @[@"投资类型", @"往期年化收益", @"项目期限", @"回款本金",@"项目还款方式"];
            if (_incomeModel) {
                //回款记录数据
                detailsArr = [self GetIncomeArrData];
            }else{
                NSArray *tempArr = @[@"锁定自动投标",@"8.8%",@"30天",@"1000.00元",@"先息后本"];
                detailsArr = [[NSMutableArray alloc] initWithArray:tempArr];
            }
            cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
            cell.textLabel.text = arr[indexPath.row];
            cell.detailTextLabel.text = detailsArr[indexPath.row];
        }
    }else if(indexPath.section == 2){
        NSArray *arr = @[@"投资日期", @"起息日期"];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        NSMutableArray *detailsArr;
        if (_section == 2) {
            //投资记录
            if (_investModel) {
                detailsArr = [NSMutableArray array];
                //投资日期
                NSString *beginStr = [Factory stdTimeyyyyMMddFromNumer:_investModel.addtime andtag:100];
                [detailsArr addObject:beginStr];
                //起息日期
                NSString *fullTime = nil;
                if (_investModel.fullTime == nil) {
                    fullTime = @"未起息";
                }else{
                    fullTime = [Factory stdTimeyyyyMMddFromNumer:_investModel.fullTime andtag:53];
                }
                [detailsArr addObject:fullTime];
            }else{
                NSArray *array = @[@"2017-05-26 14:22:33",@"2017-05-26"];
                detailsArr = [[NSMutableArray alloc] initWithArray:array];
            }
        }else{
            //回款记录
            if (_incomeModel) {
                detailsArr = [NSMutableArray array];
                //投资日期
                NSString *beginStr = [Factory stdTimeyyyyMMddFromNumer:_incomeModel.investTime andtag:100];
                [detailsArr addObject:beginStr];
                //起息日期
                NSString *fullTime = nil;
                if (_incomeModel.collectTime == nil) {
                    fullTime = @"未起息";
                }else{
                    fullTime = [Factory stdTimeyyyyMMddFromNumer:_incomeModel.collectTime andtag:53];
                }
                [detailsArr addObject:fullTime];
            }else{
                NSArray *array = @[@"2017-05-26 14:22:33",@"2017-05-26"];
                detailsArr = [[NSMutableArray alloc] initWithArray:array];
            }
        }
        cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        cell.textLabel.text = arr[indexPath.row];
        cell.detailTextLabel.text = detailsArr[indexPath.row];
    }else if(indexPath.section == 4){
        cell.textLabel.text = @"项目合同";
        cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 20*m6Scale;
    }else if(section == 4){
        return 180*m6Scale;
    }else{
        return 0;
    }
}
/**
 *回款记录部分数组赋值
 */
- (NSMutableArray *)GetIncomeArrData{
    NSMutableArray *dataArr = [NSMutableArray array];
    //投资类型
    NSString *incomeType;
    if (![Factory theidTypeIsNull:_incomeModel.investType]) {
        incomeType = [self GetInvestTypeByType:_incomeModel.investType.integerValue];
    }
    else{
        incomeType = [NSString stringWithFormat:@"%@", @"暂无"];
    }

    [dataArr addObject:incomeType];
    //往期年化收益
    NSString *rate;
    if (_incomeModel.itemAddRate.floatValue) {
        rate = [NSString stringWithFormat:@"%.1f%@+%.1f%@", _incomeModel.itemRate.floatValue, @"%", _incomeModel.itemAddRate.floatValue, @"%"];
    }else{
        rate = [NSString stringWithFormat:@"%.1f%@", _incomeModel.itemRate.floatValue, @"%"];
    }
    [dataArr addObject:rate];
    ///项目期限
    ///首先确定项目期限单位
    NSString *unit = [Factory dataUnitByItemCycleUnit:_incomeModel.itemCycleUnit];
    NSString *date;
    if (_incomeModel.itemCycle.integerValue) {
        date = [NSString stringWithFormat:@"%@%@", _incomeModel.itemCycle, unit];
    }else{
        date = @"0天";
    }
    [dataArr addObject:date];
    //回款本金
    NSString *account = [NSString stringWithFormat:@"%.2f元", _incomeModel.collectPrincipal.floatValue];
    [dataArr addObject:account];
    //还款方式
    NSString *type;
    if (![_incomeModel.itemRepayMethod isEqual:[NSNull null]]&&_incomeModel.itemRepayMethod.integerValue) {
        type = [self GetRepayMethodByMethod:_incomeModel.itemRepayMethod.integerValue];
    }else{
        type = @"先息后本";
    }
    
    [dataArr addObject:type];
    
    return dataArr;
}
/**
 *投资记录部分数组赋值
 */
- (NSMutableArray *)GetInvestArrData{
    NSMutableArray *dataArr = [NSMutableArray array];
    //获得投资类型
    NSString *investType ;//= [self GetInvestTypeByType:_investModel.itemType.integerValue];
    if (![Factory theidTypeIsNull:_investModel.investType]) {
        investType = [self GetInvestTypeByType:_investModel.investType.integerValue];
    }
    else{
        investType = [NSString stringWithFormat:@"%@", @"暂无"];
    }
    //投资类型
    [dataArr addObject:investType];
    NSString *rate;
    if (_investModel.itemAddRate.doubleValue) {
        //往期年化收益
        rate = [NSString stringWithFormat:@"%.1f%@+%.1f%@", _investModel.itemRate.floatValue, @"%", _investModel.itemAddRate.floatValue, @"%"];
    }else{
        rate = [NSString stringWithFormat:@"%.1f%@", _investModel.itemRate.floatValue, @"%"];
    }
    [dataArr addObject:rate];
    //项目期限
    //项目时间单位
    NSString *unit;
    NSString *data;
    if (_investModel.itemCycleUnit.integerValue) {
        unit = [Factory dataUnitByItemCycleUnit:_investModel.itemCycleUnit];
    }else{
        unit = @"天";
    }
    if (_investModel.itemCycle.integerValue) {
        data = [NSString stringWithFormat:@"%@%@", _investModel.itemCycle, unit];
    }else{
        data = @"0";
    }
    [dataArr addObject:data];
    //投资金额
    NSString *amount = [NSString stringWithFormat:@"%ld元", _investModel.investDealAmount.integerValue];
    [dataArr addObject:amount];
    //红包金额
    NSString *red = [NSString stringWithFormat:@"%ld元", _investModel.couponAmount.integerValue];
    [dataArr addObject:red];
    //还款的方式
    //还款方式 1-一次性还款 2-等额本息 3-先息后本 4-每日付息
    NSString *type = [self GetRepayMethodByMethod:_investModel.itemRepayMethod.integerValue];
    [dataArr addObject:type];
    return dataArr;
}
/**
 *获得投资类型
 */
- (NSString *)GetInvestTypeByType:(NSInteger)type{
    NSString *investType = @"PC";
    //投资类型（1-PC 2-APP端3-WAP端 4-微信端-5-自动投标 6-体验金使用 7.iOS端 8.安卓端 9-锁定自动投标 10-非锁定自动投标） 如果类型为6则查看合同无效，点击无效
    switch (type) {
        case 1:
            //PC
            investType = @"PC";
            break;
        case 2:
            //PC
            investType = @"App端";
            break;
        case 3:
            //WAP端
            investType = @"WAP端";
            break;
        case 4:
            //微信端
            investType = @"微信端";
            break;
        case 5:
            //自动投标
            investType = @"自动投标";
            break;
        case 6:
            //体验金使用
            investType = @"体验金使用";
            break;
        case 7:
            //iOS端
            investType = @"iOS端";
            break;
        case 8:
            //安卓端
            investType = @"安卓端";
            break;
        case 9:
            //锁定自动投标
            investType = @"锁定自动投标";
            break;
        case 10:
            //非锁定自动投标
            investType = @"非锁定自动投标";
            break;
        case 11:
            //非锁定自动投标
            investType = @"魔库端投资";
            break;
            
        default:
            investType = @"PC";
            break;
    }
    
    return investType;
}
/**
 *还款方式
 */
- (NSString *)GetRepayMethodByMethod:(NSInteger)method{
    //还款方式 1-一次性还款 2-等额本息 3-先息后本 4-每日付息
    NSString *type = nil;
    switch (method) {
        case 1:
            type = @"一次性还款";
            break;
        case 2:
            type = @"等额本息";
            break;
        case 3:
            type = @"先息后本";
            break;
        case 4:
            type = @"每日付息";
            break;
            
        default:
            type = @"一次性还款";
            break;
    }
    
    return type;
}
/**
 客户电话
 */
- (void)resgister{
    //呼叫客服
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"客服时间:9:00-17:30\n400-0571-909" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *str = @"tel://400-0571-909";
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
