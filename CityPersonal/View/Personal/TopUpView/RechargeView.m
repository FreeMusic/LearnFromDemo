//
//    RechargeView.m
//    CityJinFu
//
//    Created  by  mic  on  2017/7/21.
//    Copyright  ©  2017年  yunfu.  All  rights  reserved.
//

#import "RechargeView.h"
#import "BankListModel.h"

#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height self.frame.size.height  //每一个输入框的高度等于当前view的高度

@interface  RechargeView  ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) NSMutableArray *dataSource;//用户银行卡信息数组
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点

@property (nonatomic, strong) NSMutableArray *payArr;//支付公司数组
@property (nonatomic, assign) NSInteger index;//记录被选中银行卡的下标
@property (nonatomic, assign) NSInteger isRechargeDefault;//首先判断用户isRechargeDefault字段是否有1的
@property (nonatomic, assign) NSInteger selected;//支付公司默认选中的下标

@property (nonatomic, assign) NSInteger isDefault;//首先判断用户isDefault字段是否有1的

@end

@implementation  RechargeView

-  (instancetype)initWithFrame:(CGRect)frame{
    if  (self  =  [super  initWithFrame:frame])  {
        self.backgroundColor  =  [UIColor  colorWithWhite:0.3  alpha:0.7];
        //白色背景View
        _backView  =  [[UIView  alloc]  init];
        _backView.backgroundColor  =  [UIColor  whiteColor];
        _backView.layer.cornerRadius  =  6*m6Scale;
        _backView.layer.masksToBounds  =  YES;
        [self  addSubview:_backView];
        [_backView  mas_makeConstraints:^(MASConstraintMaker  *make)  {
            make.top.mas_equalTo(257*m6Scale);
            make.left.mas_equalTo(93*m6Scale);
            make.right.mas_equalTo(-93*m6Scale);
            make.height.mas_equalTo(430*m6Scale);
        }];
        //取消按钮
        _btn  =  [UIButton  buttonWithType:0];
        [_btn setImage:[UIImage imageNamed:@"shangchu"] forState:0];
        [_btn  addTarget:self  action:@selector(buttonClick)  forControlEvents:UIControlEventTouchUpInside];
        [self  addSubview:_btn];
        [_btn  mas_makeConstraints:^(MASConstraintMaker  *make)  {
            make.left.mas_equalTo(113*m6Scale-17*m6Scale);
            make.top.mas_equalTo(287*m6Scale-17*m6Scale);
            make.size.mas_equalTo(CGSizeMake(84*m6Scale,  84*m6Scale));
        }];
        //输入交易密码标签
        _titleLabel  =  [Factory  CreateLabelWithTextColor:0  andTextFont:26  andText:@"请输入交易密码"  addSubView:_backView];
        _titleLabel.textAlignment  =  NSTextAlignmentCenter;
        [_titleLabel  mas_makeConstraints:^(MASConstraintMaker  *make)  {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(97*m6Scale);
        }];
        //单线
        UIView  *line    =  [[UIView  alloc]  init];
        line.backgroundColor  =  [UIColor  colorWithWhite:0.7  alpha:0.3];
        [_titleLabel  addSubview:line];
        [line  mas_makeConstraints:^(MASConstraintMaker  *make)  {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        //样式标签（是充值还是提现）
        _styleLabel  =  [Factory  CreateLabelWithTextColor:0.4  andTextFont:28  andText:@"充值"  addSubView:_backView];
        _styleLabel.textAlignment  =  NSTextAlignmentCenter;
        [_styleLabel  mas_makeConstraints:^(MASConstraintMaker  *make)  {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(line.mas_bottom).offset(36*m6Scale);
        }];
        //充值或者提现金额标签
        [self.amountLabel  mas_makeConstraints:^(MASConstraintMaker  *make)  {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_styleLabel.mas_bottom).offset(20*m6Scale);
        }];
        //交易密码输入框
        [self.myTextFiled  mas_makeConstraints:^(MASConstraintMaker  *make)  {
            make.left.mas_equalTo(30*m6Scale);
            make.right.mas_equalTo(- 30*m6Scale);
            make.bottom.mas_equalTo(-30);
            make.height.mas_equalTo(80*m6Scale);
        }];
        
        _isAllow = YES;
        //创建所有的小黑点
        [self initPwdTextField];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseBank:) name:@"chooseBank" object:nil];
    }
    
    return self;
}
/**
 *充值或者提现金额标签
 */
- (UILabel *)amountLabel{
    if(!_amountLabel){
        _amountLabel = [Factory CreateLabelWithTextColor:0 andTextFont:60 andText:@"￥1.00" addSubView:_backView];
        _amountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _amountLabel;
}
/**
 *用户银行卡信息数组
 */
- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
/**
 *  支付公司Arr
 */
- (NSMutableArray *)payArr{
    if(!_payArr){
        _payArr = [NSMutableArray array];
    }
    return _payArr;
}
- (PassGuardTextField *)myTextFiled{
    if(!_myTextFiled){
        _myTextFiled = [[PassGuardTextField alloc] init];
        //延迟显示
        _myTextFiled.m_isDotDelay = false;
        _myTextFiled.placeholder = @"";
        //licence
        [_myTextFiled setM_license:KeyboardKey];
        [_myTextFiled setM_iMaxLen:6];
        _myTextFiled.backgroundColor = [UIColor whiteColor];
        //输入的文字颜色为白色
        _myTextFiled.textColor = [UIColor clearColor];
        //输入框光标的颜色为白色
        _myTextFiled.tintColor = [UIColor clearColor];
        [_myTextFiled setM_mode:false];
        _myTextFiled.layer.borderColor = [[UIColor grayColor] CGColor];
        _myTextFiled.layer.borderWidth = 1;
        _myTextFiled.textAlignment = NSTextAlignmentCenter;
        [_myTextFiled addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        _myTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        _myTextFiled.font = [UIFont systemFontOfSize:50*m6Scale];
        [_backView addSubview:_myTextFiled];
    }
    return _myTextFiled;
}
/**
 * 创建所有的密码小黑蛋
 */
- (void)initPwdTextField
{
    //每个密码输入框的宽度
    CGFloat width = (kScreenWidth-186*m6Scale-60*m6Scale) / kDotCount;
    
    //生成分割线
    for (int i = 1; i < kDotCount; i++) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor grayColor];
        [self.myTextFiled addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(width*i);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(1);
        }];
    }
    
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < kDotCount; i++) {
        UIView *dotView = [[UIView alloc] init];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self.myTextFiled addSubview:dotView];
        [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((width-kDotSize.width)/2+width*i);
            make.size.mas_equalTo(kDotSize);
            make.centerY.mas_equalTo(self.myTextFiled.mas_centerY);
        }];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"text"]) {
        NSString *newStr = change[@"new"];
        for (UIView *dotView in self.dotArray) {
            dotView.hidden = YES;
        }
        for (int i = 0; i < newStr.length; i++) {
            ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
        }
        NSLog(@"newStr.length = %lu  ", (unsigned long)newStr.length);
        if (newStr.length == 6 && _isAllow == YES) {
            //获取加密因子
            [DownLoadData postGetSrandNum:^(id obj, NSError *error) {
                self.mcryptKey = [NSString stringWithFormat:@"%@", obj[@"mcryptKey"]];
                //加密因子;
                [self.myTextFiled setM_strInput1:self.mcryptKey];
                self.passWord = [self.myTextFiled getOutput1];
                if (self.style.integerValue == 0) {
                    self.style = @"0";
                }
                //
                NSNotification *notification = [[NSNotification alloc] initWithName:@"sxyRecharge" object:nil userInfo:@{@"passWord":self.passWord, @"mcryptKey":self.mcryptKey, @"style":self.style}];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }];
            _isAllow = NO;
        }else if(newStr.length < 6){
            _isAllow = YES;
        }
    }
}

/**
 *取消按钮点击事件
 */
- (void)buttonClick{
    self.hidden = YES;
    self.myTextFiled.text = @"";
    [_myTextFiled resignFirstResponder];
    self.isAllow = YES;
}

- (void)dealloc{
    [_myTextFiled removeObserver:self forKeyPath:@"text"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *暂时设定在投资页面展示银行卡列表信息 值大于零显示银行卡信息
 */
- (void)setIsShowBankList:(NSString *)isShowBankList{
    if (isShowBankList.integerValue) {
        //请求银行卡列表数据
        [self getBankList];
    }else{
        _tableView.hidden = YES;
        //重新约束交易密码输入框
        [self.myTextFiled  mas_remakeConstraints:^(MASConstraintMaker  *make)  {
            make.left.mas_equalTo(30*m6Scale);
            make.right.mas_equalTo(- 30*m6Scale);
            make.bottom.mas_equalTo(-30);
            make.height.mas_equalTo(80*m6Scale);
        }];
        //重新约束空白View
        [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(257*m6Scale);
            make.left.mas_equalTo(93*m6Scale);
            make.right.mas_equalTo(-93*m6Scale);
            make.height.mas_equalTo(410*m6Scale);
        }];
    }
}
/**
 *请求银行卡列表数据
 */
- (void)getBankList{
    [DownLoadData postGetListByUserId:^(id obj, NSError *error) {
        self.dataSource = obj[@"SUCCESS"];
        [self getDefaultBank:self.dataSource];
        _bankId = [NSString stringWithFormat:@"%@", _model.ID];
        NSNotification *noti = [[NSNotification alloc] initWithName:@"SxyGetBankId" object:nil userInfo:@{@"bankId":_bankId}];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
        
        //获取该银行卡支持的支付公司
        [self getBankListCompanny];
        
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *   获取默认的充值银行
 */
- (void)getDefaultBank:(NSArray *)dataSource{
    //首先判断用户isRechargeDefault字段是否有1的
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BankListModel *model = self.dataSource[idx];
        if (model.isRechargeDefault.integerValue) {
            _model = model;
            _index = idx;
            self.bankId  = [NSString stringWithFormat:@"%@", model.ID];
            _isRechargeDefault = 100;
            
            *stop = YES;
        }
    }];
    if (_isRechargeDefault == 0) {
        //没有1的  就优先找一个isRechargeDefault字段是0的
        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BankListModel *model = self.dataSource[idx];
            if (model.isRechargeDefault.integerValue == 0) {
                _model = model;
                _index = idx;
                self.bankId  = [NSString stringWithFormat:@"%@", model.ID];
                
                *stop = YES;
            }
        }];
    }
}
/**
 *  获取该银行卡支持的支付公司
 */
- (void)getBankListCompanny{
    
    [DownLoadData postGetSupportBankLimit:^(id obj, NSError *error) {
        
        self.payArr = obj;
        
        [self getDefaultCompany];
        
        //self.topUpModel = self.payArr[0];
        
        NSNotification *noti = [[NSNotification alloc] initWithName:@"SxyGetPayMentId" object:nil userInfo:@{@"PayMentId":self.topUpModel.paymentId}];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
        
        self.tableView.hidden = NO;
        [_backView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.amountLabel.mas_bottom).offset(10*m6Scale);
            make.height.mas_equalTo(180*m6Scale);
        }];
        //重新约束交易密码输入框
        [self.myTextFiled  mas_remakeConstraints:^(MASConstraintMaker  *make)  {
            make.left.mas_equalTo(30*m6Scale);
            make.right.mas_equalTo(- 30*m6Scale);
            make.top.mas_equalTo(self.tableView.mas_bottom).offset(10*m6Scale);
            make.height.mas_equalTo(80*m6Scale);
        }];
        //重新约束空白View
        [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(257*m6Scale);
            make.left.mas_equalTo(93*m6Scale);
            make.right.mas_equalTo(-93*m6Scale);
            make.height.mas_equalTo(180*m6Scale+410*m6Scale);
        }];
        
    } bankId:self.bankId];
}
/**
 *  获取默认的支付公司
 */
- (void)getDefaultCompany{
    //首先判断用户isRechargeDefault字段是否有1的
    [self.payArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        _topUpModel = self.payArr[idx];
        if (_topUpModel.isDefault.integerValue) {
            _selected = idx+100;
            
            _isDefault = 100;
            
            //self.paymentId = [NSString stringWithFormat:@"%@", _topUpModel.paymentId];
            
            *stop = YES;
        }
    }];
    if (_isDefault == 0) {
        //没有1的  就优先找一个isRechargeDefault字段是0的
        [self.payArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            _topUpModel = self.payArr[idx];
            if (_topUpModel.isDefault.integerValue == 0) {
                
                _selected = idx+100;
                
                //self.paymentId = [NSString stringWithFormat:@"%@", _topUpModel.paymentId];
                
                *stop = YES;
            }
        }];
    }
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row) {
        NSString *str = @"TopUpCell";
        
        TopUpCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        
        if (!cell) {
            
            cell = [[TopUpCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
            
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell cellForModel:self.topUpModel];
        
        return cell;
    }else{
        NSString *str = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.selectionStyle = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (!_imgView) {
            _imgView = [[UIImageView alloc] init];
            [cell addSubview:_imgView];
            [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20*m6Scale);
                make.size.mas_equalTo(CGSizeMake(50*m6Scale, 50*m6Scale));
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
        }
        _imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _model.bankIcon]]]];
        //获取银行卡名称和尾号
        //获取银行卡尾号
        NSLog(@"%@", _model.bankName);
        NSString *cardNo = [[_model.cardNo componentsSeparatedByString:@"*"] lastObject];
        NSString *content = [NSString stringWithFormat:@"%@储蓄卡(%@)", _model.bankName, cardNo];
        if (!_textLabel) {
            _textLabel = [Factory CreateLabelWithTextColor:0.2 andTextFont:28 andText:content addSubView:cell];
            [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_imgView.mas_right).offset(25*m6Scale);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
        }
        _textLabel.text = content;
        for (int i = 0; i < 2; i++) {
            UIView *line = [UIView new];
            line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
            [cell addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(30*m6Scale);
                make.right.mas_equalTo(-30*m6Scale);
                make.height.mas_equalTo(1);
                if (i) {
                    make.bottom.mas_equalTo(0);
                }else{
                    make.top.mas_equalTo(0);
                }
            }];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*m6Scale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.skipToBankListView) {
        self.skipToBankListView(indexPath.row, self.dataSource, self.payArr, _index, _selected);
    }
}

- (void)setModel:(BankListModel *)model{
    _imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.bankIcon]]]];
    NSString *cardNo = [[model.cardNo componentsSeparatedByString:@"*"] lastObject];
    NSString *content = [NSString stringWithFormat:@"%@(%@)", model.bankName, cardNo];
    NSLog(@"%@", content);
    _textLabel.text = content;
}

- (void)chooseBank:(NSNotification *)noti{
    
    BankListModel *model = noti.userInfo[@"model"];
    
    NSString *bankId = [NSString stringWithFormat:@"%@", model.ID];
    
    [DownLoadData postGetSupportBankLimit:^(id obj, NSError *error) {
        
        self.payArr = obj;
        
        [self getDefaultCompany];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
        
        NSLog(@"%@", self.topUpModel.paymentId);
        
        NSNotification *noti = [[NSNotification alloc] initWithName:@"SxyGetPayMentId" object:nil userInfo:@{@"PayMentId":self.topUpModel.paymentId}];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
        
    } bankId:bankId];
}

@end
