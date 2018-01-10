//
//  RulerAlterVC.m
//  CityJinFu
//
//  Created by mic on 2017/8/10.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "RulerAlterVC.h"

@interface RulerAlterVC ()

@property (nonatomic, strong) UILabel *ruleLabel;//规则说明标签
@property (nonatomic, strong) UIScrollView *scrollView;//滑动视图

@end

@implementation RulerAlterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backGroundColor;
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"规则说明"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.scrollView];
    //规则说明标签
    [self.ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*m6Scale);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth-20*m6Scale);
    }];
    //表格的创建
    
}
/**
 *规则说明标签
 */
- (UILabel *)ruleLabel{
    if(!_ruleLabel){
        _ruleLabel = [Factory CreateLabelWithTextColor:0 andTextFont:26 andText:@"自动投标的规则说明:\n自动投标规则自动投标功能是一种系统代理投标功能，开启自动投标功能后，会根据您开启的时间先后顺序以及您设置的规则进行排队投标，方便用户抢标。\n1、开启自动投标后，用户可修改投资总额，即时生效\n2、自动投标总额投完后，客户可选择关闭，则还款后不会再投资\n3、如客户在自动投标完成后，未关闭功能，则在客户回款后，账户余额符合设置自动投标条件时，会继续投标\n4、如客户在未回款的情况下充值（自动投标未关闭），不会发起自动投标，需提高设定金额才能投标成功。\n自动投标设置规则说明投资总额设置：\n设置自动投标的总额就好比一个额度，您设置以后可以在这个额度内循环进行投标（比如新充值或者其他资金到期时）您就可以根据您的需要提高这个额度，来实现自动投标。例：客户设置金额为1万，已投成功，客户继续充值1万，则需要将自动投标金额设置为2万，才能进行自动投标。\n投标标的期限设置：用户可按照自己的投资习惯对投资标的期限进行设置，标的目前期限全部以天为单位。例如设置30-30天，即表示30天标，设置15-30天，即表示15天到30天标的（包含15天和30天的标的） \n投标标的利率设置：用户可按照自己的投资习惯对投资标的利率进行设置，目前利率均为年化利率。例如设置9%-9%天，即表示年化为9%的标，设置8%-9%天，即表示年化8%到年化9%的标的（包含年化8%和年化9%的标的）自动投标排队规则说明每个用户都只有一条自动投标规则，第一次开启自动投标规则后即会产生一个唯一的规则序号，不论用户修改还是关闭投标规则，都会重新进行排序。一旦平台有发新的标的，系统会自动先抓取符合当前自动投标设置条件用户，然后在符合条件的用户中按照序号排名先后进行排队投标。一轮结束后，如中途产生新的用户开启规则并产生新的规则序号，则自动列入下一轮投资队列的序号中的排序。第一轮已自动投标过的客户会自动排尾，进行下一轮投标。自动投标文字说明当前排名：指用户当前自动投标的规则名次累计在投：指用户当前已经通过自动投标进行投资的在投项目的本金投资总额：指用户希望通过自动投标进行投资的一个额度剩余可投：指用户填写设置投资总额时，根据当前累计自动投标金额，判断提示用户现有账户余额中还可以自动投标金额，例子如下：" addSubView:self.scrollView];
        _ruleLabel.textAlignment = NSTextAlignmentLeft;
        _ruleLabel.numberOfLines = 0;
    }
    return _ruleLabel;
}
/**
 *scrollView懒加载
 */
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight)];
    }
    return _scrollView;
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *表格的创建
 */
- (void)formView{
    
}
@end
