//
//  FatherVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/8.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "WelfareFatherVC.h"
#define DCScreenW    [UIScreen mainScreen].bounds.size.width
#define DCScreenH    [UIScreen mainScreen].bounds.size.height

@interface WelfareFatherVC ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIButton *oldBtn;
@property(nonatomic,strong)NSArray *VCArr;
@property (nonatomic, weak) UIScrollView *topBar;
@property(nonatomic,assign) CGFloat btnW ;

@property (nonatomic, weak) UIView *slider;

@end

@implementation WelfareFatherVC
-(UIColor *)sliderColor
{
    if(_sliderColor == nil)
    {
        _sliderColor = [UIColor purpleColor];
    }
    return  _sliderColor;
}
-(UIColor *)btnTextNomalColor
{
    if(_btnTextNomalColor == nil)
    {
        _btnTextNomalColor = [UIColor blackColor];
    }
    return _btnTextNomalColor;
}
-(UIColor *)btnTextSeletedColor
{
    if(_btnTextSeletedColor == nil)
    {
        _btnTextSeletedColor = [UIColor redColor];
    }
    return _btnTextSeletedColor;
}
-(UIColor *)topBarColor
{
    if(_topBarColor == nil)
    {
        _topBarColor = [UIColor whiteColor];
    }
    return _topBarColor;
}
-(instancetype)initWithSubViewControllers:(NSArray *)subViewControllers
{
    if(self = [super init])
    {
        _VCArr = subViewControllers;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加上面的导航条
    [self addTopBar];
    //添加子控制器
    [self addVCView];
    //添加滑块
    [self addSliderView];
}

-(void)addSliderView
{
    if(self.VCArr.count == 0) return;
    
    UIView *slider = [[UIView alloc]initWithFrame:CGRectMake(0,42,self.btnW, 2)];
    slider.backgroundColor = UIColorFromRGB(0xEB5A2D);
    [self.topBar addSubview:slider];
    self.slider = slider;
}
-(void)addTopBar
{
    if(self.VCArr.count == 0) return;
    NSUInteger count = self.VCArr.count;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DCScreenW, 44)];
    scrollView.backgroundColor = self.topBarColor;
    self.topBar = scrollView;
    //    self.topBar.bounces = NO;
    [self.view addSubview:self.topBar];
    
    if(count <= 5)
    {
        self.btnW = DCScreenW / count;
    }else
    {
        self.btnW = DCScreenW / 5.0;
    }
    //添加button
    for (int i=0; i<count; i++)
    {
        UIViewController *vc = self.VCArr[i];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*self.btnW, 0, self.btnW, 44)];
        UIView *point = [[UIView alloc] init];
        point.tag = 1000+i;
        if (i) {
            point.backgroundColor = [UIColor redColor];
            point.layer.cornerRadius = 5*m6Scale;
            point.layer.masksToBounds = YES;
            
            [self.topBar addSubview:point];
            [point mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(10*m6Scale, 10*m6Scale));
                make.centerY.mas_equalTo(self.topBar.mas_centerY);
                make.right.mas_equalTo(self.btnW*(i+1)-30*m6Scale);
            }];
        }
        btn.tag = 10000+i;
        [btn setTitleColor:UIColorFromRGB(0x393939) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xEB5A2D) forState:UIControlStateSelected];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.topBar addSubview:btn];
        if(i == 0)
        {
            btn.selected = YES;
            //默认one文字放大
            btn.transform = CGAffineTransformMakeScale(1, 1);
            self.oldBtn = btn;
        }
    }
    self.topBar.contentSize = CGSizeMake(self.btnW *count, 0);
}
-(void)addVCView
{
    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0+44, DCScreenW, DCScreenH -44)];
    self.contentView = contentView;
    self.contentView.bounces = NO;
    contentView.delegate = self;
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    NSUInteger count = self.VCArr.count;
    for (int i=0; i<count; i++) {
        UIViewController *vc = self.VCArr[i];
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(i*DCScreenW, 0, DCScreenW, DCScreenH -44);
        [contentView addSubview:vc.view];
    }
    contentView.contentSize = CGSizeMake(count*DCScreenW, DCScreenH-44);
    contentView.pagingEnabled = YES;
}
-(void)click:(UIButton *)sender
{
    if(sender.selected) return;
    self.oldBtn.selected = NO;
    sender.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.contentOffset = CGPointMake((sender.tag - 10000)*DCScreenW, 0);
        sender.transform = CGAffineTransformMakeScale(1, 1);
    }];
    self.oldBtn.transform = CGAffineTransformIdentity;
    self.oldBtn = sender;
    if (sender.tag == 10001) {
        [DownLoadData postReadReward:^(id obj, NSError *error) {
            
            if ([obj[@"result"] isEqualToString:@"success"]) {
                
                UIView *point = (UIView *)[self.view viewWithTag:1001];
                point.hidden = YES;
                
            }
            
        } userId:[HCJFNSUser stringForKey:@"userId"] key:@"ticket"];
    }else if(sender.tag == 10002){
        [DownLoadData postReadReward:^(id obj, NSError *error) {
            
            if ([obj[@"result"] isEqualToString:@"success"]) {
                
                UIView *point = (UIView *)[self.view viewWithTag:1002];
                point.hidden = YES;
                
            }
            
        } userId:[HCJFNSUser stringForKey:@"userId"] key:@"experienceGold"];
    }else{
        [DownLoadData postReadReward:^(id obj, NSError *error) {
            
            if ([obj[@"result"] isEqualToString:@"success"]) {
                
                UIView *point = (UIView *)[self.view viewWithTag:1000];
                point.hidden = YES;
                
            }
            
        } userId:[HCJFNSUser stringForKey:@"userId"] key:@"coupon"];
    }
    
    //判断导航条是否需要移动
    CGFloat maxX = CGRectGetMaxX(self.slider.frame);
    if(maxX >=DCScreenW  && sender.tag != self.VCArr.count + 10000 - 1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.topBar.contentOffset = CGPointMake(maxX - DCScreenW + self.btnW, 0);
        }];
    }else if(maxX < DCScreenW)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.topBar.contentOffset = CGPointMake(0, 0);
        }];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //滑动导航条
    self.slider.frame = CGRectMake(scrollView.contentOffset.x / DCScreenW *self.btnW , 42, self.btnW, 2);
}
//判断是否切换导航条按钮的状态
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offX =  scrollView.contentOffset.x;
    int tag = (int)(offX /DCScreenW + 0.5) + 10000;
    UIButton *btn = [self.view viewWithTag:tag];
    if(tag != self.oldBtn.tag)
    {
        [self click:btn];
    }
}

- (void)setButtonPoint:(NSInteger)coupon ticket:(NSInteger)ticket experienceGold:(NSInteger)experienceGold{
    
    NSLog(@"%ld    %ld   %ld", coupon, ticket, experienceGold);
    
    for (int i = 0; i < 3; i++) {
        
        UIView *point = (UIView *)[self.view viewWithTag:1000+i];
        
        if (i == 1) {
        
            if (ticket) {
                
                point.hidden = NO;
                
            }else{
                
                point.hidden = YES;
                
            }
            
        }else if (i == 2){
            
            if (experienceGold) {
                
                point.hidden = NO;
                
            }else{
                
                point.hidden = YES;
                
            }
            
        }else{
            if (coupon) {
                
                point.hidden = NO;
                
            }else{
                
                point.hidden = YES;
                
            }
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //navigationBar延展性并设置透明
    self.navigationController.navigationBar.translucent = NO;
}

@end
