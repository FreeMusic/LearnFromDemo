//
//  InsuranceVC.m
//  CityJinFu
//
//  Created by hanling on 16/10/28.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "InsuranceVC.h"
#import "SXYImage.h"

@interface InsuranceVC ()<UIScrollViewDelegate>
{
    double _y;
    double _height;
}
@property (nonatomic, strong) UIScrollView *bottomScroll;//scrollView滚动
@property (nonatomic, strong) UIImageView *bottomImg;//底部图片

@end

@implementation InsuranceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.view.backgroundColor = backGroundColor;
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"安全保护"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(clickLeftItem) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.bottomScroll];//安全保护图片保护
    [self addImages];//添加图片
    //底部图片
    [self bottomScrollView];
}
/**
 滚动
 */
- (UIScrollView *)bottomScroll{
    if (!_bottomScroll) {
       _bottomScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight)];
        _bottomScroll.backgroundColor = backGroundColor;
        _bottomScroll.showsVerticalScrollIndicator = NO;
        _bottomScroll.delegate = self;
        _bottomScroll.pagingEnabled = YES;
        _bottomScroll.showsHorizontalScrollIndicator = NO;
    }
    return _bottomScroll;
}
/**
 *底部图片
 */
- (void)bottomScrollView{
    _bottomImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiala"]];
    [self. view addSubview:_bottomImg];
    [_bottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(135*m6Scale, 68*m6Scale));
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}
/**
 添加图片
 */
- (void)addImages{
    NSArray *array = @[@"safe_1",@"safe_2",@"safe_3",@"safe_4",@"safe_5",@"safe_6"];
    self.bottomScroll.contentSize = CGSizeMake(kScreenWidth, array.count*(kScreenHeight-NavigationBarHeight));
    for (int i = 0; i < array.count; i ++) {//300/1.8
        
        UIImageView *backGroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, i*(kScreenHeight-NavigationBarHeight), kScreenWidth, kScreenHeight-NavigationBarHeight)];
        backGroundImage.image = [SXYImage imageNamed:array[i]];//添加图片
        backGroundImage.clipsToBounds = YES;
        [self.bottomScroll addSubview:backGroundImage];
    }
}
/**
 *  返回
 */
- (void)clickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.y/(kScreenHeight-NavigationBarHeight);
    if (index == 5) {
        _bottomImg.hidden = YES;
    }else{
        _bottomImg.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [Factory hidentabar];
    [Factory navgation:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
