//
//  FinalDecisionVC.m
//  CityJinFu
//
//  Created by mic on 2017/11/28.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "FinalDecisionVC.h"
#import "AuthenticationVC.h"

@interface FinalDecisionVC ()

@end

@implementation FinalDecisionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"审核结果"];
    //返回按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = backGroundColor;
    //创建审核结果UI页面
    [self createFinalDecisionUI];
}
/**
 *  创建审核结果UI页面
 */
- (void)createFinalDecisionUI{
    //审核结果图标
    NSString *path = [self getDecisionImage:_decision];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_decision == FinalDecision_Wait) {
            make.size.mas_equalTo(CGSizeMake(110*m6Scale, 182*m6Scale));
        }else if (_decision == FinalDecision_Success){
            make.size.mas_equalTo(CGSizeMake(139*m6Scale, 183*m6Scale));
        }else{
            make.size.mas_equalTo(CGSizeMake(140*m6Scale, 183*m6Scale));
        }
        make.top.mas_equalTo(223*m6Scale+NavigationBarHeight);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];

    if (_decision == FinalDecision_Failure) {
        //重试按钮
        UIButton *button = [Factory ButtonWithTitle:@"重试" andTitleColor:[UIColor whiteColor] andButtonbackGroundColor:navigationYellowColor andCornerRadius:5 addTarget:self action:@"tryAgainButtonClick" addSubView:self.view];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(585*m6Scale, 88*m6Scale));
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(imageView.mas_bottom).offset(165*m6Scale);
        }];
        //描述文字
        NSString *describeString = @"1、请提交本人手持身份证正面照；\n2、请保持照片清晰，光线明亮。";
        UILabel *label = [Factory CreateLabelWithColor:UIColorFromRGB(0x999999) andTextFont:26 andText:describeString addSubView:self.view];
        label.numberOfLines = 0;
        [Factory changeLineSpaceForLabel:label WithSpace:4];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(585*m6Scale);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(button.mas_bottom).offset(125*m6Scale);
        }];
    }else{
        //认证成功
        UILabel *label = [Factory CreateLabelWithColor:UIColorFromRGB(0x626262) andTextFont:28 andText:@"" addSubView:self.view];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(imageView.mas_bottom).offset(95*m6Scale);
        }];
        if (_decision == FinalDecision_Success) {
            label.text = @"恭喜您身份认证成功~";
        }else{
            //审核中
            label.text = @"手持身份证已提交，请等待审核结果\n我们会在1-2个工作日内，通知您";
        }
    }
}
/**
 *  获取审核状态图片
 */
- (NSString *)getDecisionImage:(FinalDecision)decision{
    NSString *path;
    
    switch (decision) {
        case FinalDecision_Success:
            path = [[NSBundle mainBundle] pathForResource:@"FinalDescion_成功@2x" ofType:@"png"];
            break;
        case FinalDecision_Failure:
            path = [[NSBundle mainBundle] pathForResource:@"FinalDescion_失败@2x" ofType:@"png"];
            break;
        case FinalDecision_Wait:
            path = [[NSBundle mainBundle] pathForResource:@"LargeAmountRechange_时间@2x" ofType:@"png"];
            break;
            
        default:
            break;
    }
    
    return path;
}
/**
 *  获取
 */

/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  重试按钮的点击事件
 */
- (void)tryAgainButtonClick{
    AuthenticationVC *tempVC = [[AuthenticationVC alloc] init];
    tempVC.bizNo = _bizNo;//人脸识别因子
    tempVC.reviewType = NeedReview_YES;
    [self.navigationController pushViewController:tempVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [Factory hidentabar];
    
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
