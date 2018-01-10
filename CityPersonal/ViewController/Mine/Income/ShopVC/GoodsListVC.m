//
//  GoodsListVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "GoodsListVC.h"
#import "MyOrderVC.h"
#import "MyAddressVC.h"
#import "SDCycleScrollView.h"
#import "ShopBannerVC.h"
#import "ShopBannerModel.h"
#import "GoosListHeaderCell.h"
#import "GoodsListTypeCell.h"
#import "PictureCell.h"
#import "IntegralShopVC.h"
#import "AlertImageView.h"
#import "NewSignVC.h"

@interface GoodsListVC ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerImgView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;//轮播图
@property (nonatomic, strong) NSArray *cycleArr;//轮播图数组
@property (nonatomic, strong) NSArray *recommendArr;//推荐商品数组
@property (nonatomic, strong) NSArray *goodsArr;//商品数组
@property (nonatomic, strong) NSArray *nameArr;//商品名称数组
@property (nonatomic, strong) NSArray *picArr;//商品背景图数组
@property (nonatomic, strong) AlertImageView *imageAlert;
@end

@implementation GoodsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.view.backgroundColor = backGroundColor;
    //
    [self.view addSubview:self.tableView];
    //锁投有礼首页全部商品
    [self getallGoods];
    //提醒用户登录的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alterUser) name:@"alterUser" object:nil];
}
/**
 *锁投有礼首页全部商品
 */
- (void)getallGoods{
    //锁投有礼首页全部商品
    [DownLoadData postGetAllGoods:^(id obj, NSError *error) {
        self.goodsArr = obj[@"goodsArr"];
        self.nameArr = obj[@"nameArr"];
        self.picArr = obj[@"typeArr"];
        
        [self.tableView reloadData];
    } pageNum:@"1" pageSize:@"10"];
    //锁投全部滚动图
    [DownLoadData postGetLockAutoPicture:^(id obj, NSError *error) {
        self.cycleArr = obj[@"SUCCESS"];
        [self getImageData:self.cycleArr];
        [self.tableView reloadData];
    }];
    //推荐商品列表
    [DownLoadData postGetRecommendGoods:^(id obj, NSError *error) {
        self.recommendArr = obj[@"SUCCESS"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
/**
 根据返回的model获取到对应的图片路径以及点击事件
 
 @param modelArray model数组
 */
- (void)getImageData:(NSArray *)modelArray{
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    for (ShopBannerModel *model in modelArray) {
        [imageArray addObject:model.picturePath];
    }
    self.cycleScrollView.imageURLStringsGroup = imageArray;
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-90*m6Scale-NavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = backGroundColor;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderHeight = 0*m6Scale;
        _tableView.sectionFooterHeight = 20*m6Scale;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}
/**
 广告滚动页
 */
- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 300 * m6Scale) delegate:self placeholderImage:[UIImage imageNamed:@"750x300"]];
        _cycleScrollView.autoScroll = YES;
        // _cycleScrollView.pageControlBottomOffset = 30 * m6Scale;
    }
    return _cycleScrollView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1+self.goodsArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else{
        return 2;
    }
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        NSString *str = @"GoosListHeaderCell";
        GoosListHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[GoosListHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.array = self.recommendArr;
        
        return cell;
    }else{
        if (indexPath.row) {
            NSString *str = @"GoodsListTypeCell";
            GoodsListTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[GoodsListTypeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
            }
            NSArray *goodsArr = self.goodsArr[indexPath.section-1];
            [cell cellForGoodsArr:goodsArr TypeName:self.nameArr[indexPath.section-1]];
            
            return cell;
        }else{
            NSString *str = @"UITableViewCell";
            PictureCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[PictureCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
            }
            NSString *imgName = self.picArr[indexPath.section-1];
            [cell.picImgView sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:[UIImage imageNamed:@"750x240"]];
            
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 302*m6Scale;
    }else{
        if (indexPath.row) {
            return 316*m6Scale;
        }else{
            return 240*m6Scale;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section) {
        return nil;
    }else{
        CGFloat width = kScreenWidth/4;
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        
        [backView addSubview:self.cycleScrollView];
        NSArray *array = @[@"我的订单", @"我的地址", @"规则说明", @"联系客服"];
        for (int i = 0; i < array.count; i++) {
            //图标
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((width-75*m6Scale)/2+width*i, 322*m6Scale, 75*m6Scale, 75*m6Scale)];
            imgView.image = [UIImage imageNamed:array[i]];
            [backView addSubview:imgView];
            //标题
            UILabel *titleLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:array[i] addSubView:backView];
            titleLabel.textColor = UIColorFromRGB(0x686868);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(width*i);
                make.top.mas_equalTo(412*m6Scale);
                make.width.mas_equalTo(width);
            }];
            //空白按钮
            UIButton *btn = [UIButton buttonWithType:0];
            btn.frame = CGRectMake(width*i, 300*m6Scale, width, 162*m6Scale);
            btn.tag = 100+i;
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:btn];
        }
        
        return backView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == self.goodsArr.count) {
        UIView *footerView = [UIView new];
        //没有喜欢的标签
        UILabel *likeLabel = [Factory CreateLabelWithTextColor:0 andTextFont:28 andText:@"没有喜欢的" addSubView:footerView];
        likeLabel.textColor = UIColorFromRGB(0xa0a0a0);
        likeLabel.userInteractionEnabled = YES;
        likeLabel.textAlignment = NSTextAlignmentCenter;
        likeLabel.layer.cornerRadius = 5*m6Scale;
        likeLabel.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        likeLabel.layer.borderWidth = 1;
        [likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(246*m6Scale, 62*m6Scale));
            make.centerX.mas_equalTo(footerView.mas_centerX);
            make.centerY.mas_equalTo(footerView.mas_centerY);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [likeLabel addGestureRecognizer:tap];
        
        return footerView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.goodsArr.count) {
        return 114*m6Scale;
    }else{
        return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        if (indexPath.row == 0) {
            NSNotification *notification = [[NSNotification alloc] initWithName:@"sxyMoveToPage" object:nil userInfo:@{@"index":[NSString stringWithFormat:@"%ld", indexPath.section]}];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }
}
/**
 *手势点击
 */
- (void)tapAction{
    if ([HCJFNSUser stringForKey:@"userId"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        //兑吧免登陆接口
        [DownLoadData postLogFreeUrl:^(id obj, NSError *error) {
            [hud hideAnimated:YES];
            IntegralShopVC *tempVC = [IntegralShopVC new];
            tempVC.strUrl = obj[@"ret"];
            [self.navigationController pushViewController:tempVC animated:YES];
        } userId:[HCJFNSUser stringForKey:@"userId"] redicrect:@""];
    }else{
        //弹出登录注册界面
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UINavigationController *navi = [delegate.leveyTabBarController.viewControllers firstObject];
        UIViewController *vc = [navi.viewControllers firstObject];
        NewSignVC *signVC = [[NewSignVC alloc] init];
        signVC.presentTag = @"0";
        [vc presentViewController:signVC animated:YES completion:^{
            
        }];
    }
}
/**
 广告栏的点击事件
 
 @param cycleScrollView 轮播图
 @param index 索引
 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ShopBannerModel *model = self.cycleArr[index];
    ShopBannerVC *tempVC = [ShopBannerVC new];
    tempVC.strUrl = [NSString stringWithFormat:@"%@", model.pictureUrl];
    tempVC.pictureName = [NSString stringWithFormat:@"%@", model.pictureName];
    NSLog(@"%@", tempVC.strUrl);
    if (tempVC.strUrl == nil || [tempVC.strUrl isEqual:[NSNull null]] || [tempVC.strUrl isEqualToString:@"null"] || [tempVC.strUrl isEqualToString:@""]) {
        
    }else{
        [self.navigationController pushViewController:tempVC animated:YES];
    }
}
/**
 *  按钮点击事件
 */
- (void)buttonClick:(UIButton *)sender{
    switch (sender.tag) {
        case 100:{
            //我的订单
            if ([HCJFNSUser stringForKey:@"userId"]) {
                MyOrderVC *tempVC = [MyOrderVC new];
                [self.navigationController pushViewController:tempVC animated:YES];
            }else{
                [Factory alertMes:@"请您先登录"];
            }
            break;
        }
        case 101:{
            //我的地址
            if ([HCJFNSUser stringForKey:@"userId"]) {
                MyAddressVC *tempVC = [MyAddressVC new];
                tempVC.style = 1;
                [self.navigationController pushViewController:tempVC animated:YES];
            }else{
                [Factory alertMes:@"请您先登录"];
            }
            break;
        }
        case 102:
            //规则说明
        {
            // [Factory addAlertToVC:self withMessage:@"*锁定投资，即平台为用户自动按月投资30天8.8%标的即N（月）*30天标的。\n*用户选定投资周期，成功投资后，以标的复审通过之日起计息，按月派息，到期后返还本金。\n*锁定投资成功后，不得取消。\n*锁定投资后，留下收货人姓名、收货地址、联系方式。\n*礼品发放：锁定投资成功后3-5个工作日内安排礼品发放。\n*本次活动与平台其他活动不得共享。"];
            self.imageAlert = [[AlertImageView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
            [[UIApplication sharedApplication].keyWindow addSubview:self.imageAlert];
            __weak typeof(self.imageAlert) openSelf = self.imageAlert;
            [self.imageAlert setButtonAction:^(NSInteger tag) {
                [openSelf removeFromSuperview];
            }];
        }
            
            break;
        case 103:
            //联系客服
            [Factory resgisterInViewController:self];
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section) {
        return 0.01;
    }else{
        return 462*m6Scale;
    }
}
/**
 *提醒用户登录
 */
- (void)alterUser{
    [Factory alertMes:@"请您先登录"];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //self.navigationController.navigationBar.barTintColor = navigationColor;
}

@end
