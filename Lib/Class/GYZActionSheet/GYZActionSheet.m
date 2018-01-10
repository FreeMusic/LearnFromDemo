//
//  GYZActionSheet.m
//  GYZCustomActionSheet
//  ActionSheet视图
//  Created by GYZ on 16/6/20.
//  Copyright © 2016年 GYZ. All rights reserved.
//

#import "GYZActionSheet.h"
#import "GYZSheetView.h"
#import "GYZCommon.h"

#define kPushTime 0.3
#define kDismissTime 0.3
//125px
#define kCellH (135 * m6Scale)
#define kMW (kScreenWidth-2*kMargin)
#define kCornerRadius 0
#define kMargin 0
#define kSheetViewMaxH (kScreenHeight * 0.7)


@interface GYZActionSheet()<GYZSheetViewDelegate>

//RGB为半透明黑的背景button
@property (strong, nonatomic) UIButton *bgButton;
//title和sheetView的容器View
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) GYZSheetView *sheetView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *imageView;
//取消按钮View
@property (strong, nonatomic) UIButton *footButton;
@property (strong, nonatomic) UIView *marginView;
//白色区域的view高
@property (assign, nonatomic) CGFloat contentVH;
@property (assign, nonatomic) CGFloat contentViewY;
@property (assign, nonatomic) CGFloat footViewY;

@property (strong, nonatomic) NSIndexPath *selectIndex;
@property (strong, nonatomic) SelectIndexBlock selectBlock;
//itemTitles
@property (strong, nonatomic) NSArray *dataSource;
//imageViews
@property (strong, nonatomic) NSArray *dataSourceImages;
@property (assign, nonatomic) GYZSheetStyle sheetStyle;
@end

@implementation GYZActionSheet

- (id)initSheetWithTitle:(NSString *)title
                   image:(UIImage *)image
                   style:(GYZSheetStyle)style
              imageViews:(NSArray *)imageViews
              itemTitles:(NSArray *)itemTitles
{
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]]) {
        
        //默认，微信还是tableView样式
        self.sheetStyle = style;
        self.dataSource = itemTitles;
        self.dataSourceImages = imageViews;
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        //半透明背景按钮
        self.bgButton = [[UIButton alloc] init];
        [self addSubview:self.bgButton];
        self.bgButton.backgroundColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:0.68];
        //title和sheetView的容器View
        self.contentView = [[UIView alloc] init];
        [self addSubview:self.contentView];
        //取消按钮View
        self.footButton = [[UIButton alloc]initWithFrame:CGRectZero];
        self.footButton.backgroundColor = [UIColor whiteColor];
        [self.footButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.footButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateNormal];
//        [self.footButton setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateHighlighted];

        self.footButton.titleLabel.font = [UIFont systemFontOfSize:34*m6Scale];
        [self addSubview:self.footButton];
        
        //选择TableView
        self.sheetView = [[GYZSheetView alloc]initWithFrame:CGRectZero];
        self.sheetView.cellHeight = kCellH;
        self.sheetView.delegate = self;
        self.sheetView.dataSource = self.dataSource;
        self.sheetView.dataSourceImages = self.dataSourceImages;
        [self.contentView addSubview:self.sheetView];
        
        //选择样式
//        if (style == GYZSheetStyleDefault) {
            [self upDefaultStyeWithItems:itemTitles title:title imageViews:imageViews image:image];
            [self pushDefaultStyeSheetView];
//        }
//        else if (style == GYZSheetStyleWeiChat) {
//            [self upWeiChatStyeWithItems:itemTitles title:title];
//            [self pushWeiChatStyeSheetView];
//        }
//        else if (style == GYZSheetStyleTable) {
//            [self upTableStyeWithItems:itemTitles title:title];
//            [self pushTableStyeSheetView];
//        }
    }
    return self;
}

///初始化默认样式
- (void)upDefaultStyeWithItems:(NSArray *)itemTitles title:(NSString *)title imageViews:(NSArray *)imageViews image:(UIImage *)image
{
    //半透明背景按钮
    [self.bgButton addTarget:self action:@selector(dismissDefaulfSheetView) forControlEvents:UIControlEventTouchUpInside];
    self.bgButton.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    //标题
    BOOL isTitle = NO;
    if (title.length > 0) {
        //title
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-10, 0, kScreenWidth/2, kCellH)];
        self.titleLabel.text = title;
        self.titleLabel.backgroundColor = [UIColor whiteColor];
//        self.titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];

        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        isTitle = YES;
        [self.contentView addSubview:self.titleLabel];
        //imageView
        self.imageView = [[UIImageView alloc]init];
        self.imageView.image = image;
        [self.contentView addSubview:self.imageView];
        
    }
    //布局子控件
    int cellCount = (int)itemTitles.count;
    self.contentVH = kCellH * (cellCount + isTitle);
    if (self.contentVH > kSheetViewMaxH) {
        self.contentVH = kSheetViewMaxH;
        self.sheetView.tableView.scrollEnabled = YES;
    } else {
        self.sheetView.tableView.scrollEnabled = NO;
    }
    
    self.footViewY = kScreenHeight - kCellH - kMargin;
    self.footButton.frame = CGRectMake(kMargin, kScreenHeight + self.contentVH + kMargin, kMW, kCellH);
    self.contentViewY = kScreenHeight - CGRectGetHeight(self.footButton.frame) - self.contentVH - kMargin * 2;
    self.contentView.frame = CGRectMake(kMargin, kScreenHeight, kMW, self.contentVH);
    
    CGFloat sheetY = 0;
    CGFloat sheetH = CGRectGetHeight(self.contentView.frame);
    if (isTitle) {
        sheetY = CGRectGetHeight(self.titleLabel.frame);
        sheetH = CGRectGetHeight(self.contentView.frame);
    }
    self.sheetView.frame = CGRectMake(0, sheetY, kMW, sheetH);
    //设置圆角
    ViewRadius(self.contentView, kCornerRadius);
    ViewRadius(self.footButton, kCornerRadius);
    [self.footButton addTarget:self action:@selector(dismissDefaulfSheetView) forControlEvents:UIControlEventTouchUpInside];
}

/////初始化微信样式
//- (void)upWeiChatStyeWithItems:(NSArray *)itemTitles title:(NSString *)title
//{
//    [self.bgButton addTarget:self action:@selector(dismissWeiChatStyeSheetView) forControlEvents:UIControlEventTouchUpInside];
//    self.bgButton.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    [self.footButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.footButton.titleLabel.font = [UIFont systemFontOfSize:18];
//    if (kScreenHeight == 667) {
//        self.footButton.titleLabel.font = [UIFont systemFontOfSize:20];
//    }else if (kScreenHeight > 667) {
//        self.footButton.titleLabel.font = [UIFont systemFontOfSize:21];
//    }
//    
//    //中间空隙
//    self.marginView = [[UIView alloc] init];
//    self.marginView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
//    self.marginView.alpha = 0.0;
//    [self addSubview:self.marginView];
//    
//    //标题
//    BOOL isTitle = NO;
//    if (title.length > 0) {
//        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellH)];
//        self.titleLabel.text = title;
//        self.titleLabel.backgroundColor = [UIColor whiteColor];
//        self.titleLabel.textColor = [UIColor darkGrayColor];
//        self.titleLabel.font = [UIFont systemFontOfSize:18];
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        isTitle = YES;
//        [self.contentView addSubview:self.titleLabel];
//    }
//    //布局子控件
//    int cellCount = (int)itemTitles.count;
//    self.contentVH = kCellH * (cellCount + isTitle);
//    if (self.contentVH > kSheetViewMaxH) {
//        self.contentVH = kSheetViewMaxH;
//        self.sheetView.tableView.scrollEnabled = YES;
//    } else {
//        self.sheetView.tableView.scrollEnabled = NO;
//    }
//    
//    self.footViewY = kScreenHeight - kCellH;
//    self.footButton.frame = CGRectMake(0, self.footViewY + self.contentVH, kScreenWidth, kCellH);
//    
//    self.contentViewY = kScreenHeight - CGRectGetHeight(self.footButton.frame) - self.contentVH - kMargin;
//    self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.contentVH);
//    
//    CGFloat sheetY = 0;
//    CGFloat sheetH = CGRectGetHeight(self.contentView.frame);
//    if (isTitle) {
//        sheetY = CGRectGetHeight(self.titleLabel.frame);
//        sheetH = CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(self.titleLabel.frame);
//    }
//    self.sheetView.frame = CGRectMake(0, sheetY, kScreenWidth, sheetH);
//    self.marginView.frame = CGRectMake(0, kScreenHeight + sheetH, kScreenWidth, kMargin);
//    
//    [self.footButton addTarget:self action:@selector(dismissWeiChatStyeSheetView) forControlEvents:UIControlEventTouchUpInside];
//}
//
/////初始化TableView样式
//- (void)upTableStyeWithItems:(NSArray *)itemTitles title:(NSString *)title
//{
//    if (self.footButton) {
//        [self.footButton removeFromSuperview];
//    }
//    [self.bgButton addTarget:self action:@selector(dismissTableStyeSheetView) forControlEvents:UIControlEventTouchUpInside];
//    self.bgButton.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    
//    //标题
//    BOOL isTitle = NO;
//    if (title.length > 0) {
//        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellH)];
//        self.titleLabel.text = title;
//        self.titleLabel.textAlignment = NSTextAlignmentLeft;
//        self.titleLabel.backgroundColor = [UIColor whiteColor];
//        self.titleLabel.textColor = [UIColor darkGrayColor];
//        self.titleLabel.font = [UIFont systemFontOfSize:18];
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        isTitle = YES;
//        [self.contentView addSubview:self.titleLabel];
//    }
//    self.sheetView.cellTextColor = [UIColor blackColor];
//    self.sheetView.cellTextStyle = NSTextStyleLeft;
//    self.sheetView.tableView.scrollEnabled = YES;
//    self.sheetView.showTableDivLine = YES;
//    
//    //布局子控件
//    int cellCount = (int)itemTitles.count;
//    self.contentVH = kCellH * (cellCount + isTitle);
//    if (self.contentVH > kSheetViewMaxH) {
//        self.contentVH = kSheetViewMaxH;
//    }
//    
//    self.contentViewY = kScreenHeight - self.contentVH;
//    self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.contentVH);
//    
//    CGFloat sheetY = 0;
//    CGFloat sheetH = CGRectGetHeight(self.contentView.frame);
//    if (isTitle) {
//        sheetY = CGRectGetHeight(self.titleLabel.frame);
//        sheetH = CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(self.titleLabel.frame);
//    }
//    self.sheetView.frame = CGRectMake(0, sheetY, kScreenWidth, sheetH);
//}
//显示默认样式
- (void)pushDefaultStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kPushTime animations:^{
        weakSelf.contentView.frame = CGRectMake(kMargin, weakSelf.contentViewY, kMW, weakSelf.contentVH);
        weakSelf.footButton.frame = CGRectMake(kMargin, weakSelf.footViewY, kMW, kCellH);
        weakSelf.bgButton.alpha = 0.68;
    }];

}

//显示像微信的样式
- (void)pushWeiChatStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kPushTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, weakSelf.contentViewY, kScreenWidth, weakSelf.contentVH);
        weakSelf.footButton.frame = CGRectMake(0, weakSelf.footViewY, kScreenWidth, kCellH);
        weakSelf.marginView.frame = CGRectMake(0, weakSelf.footViewY - kMargin, kScreenWidth, kMargin);
        weakSelf.bgButton.alpha = 0.35;
        weakSelf.marginView.alpha = 1.0;
    }];
}

//显示TableView的样式
- (void)pushTableStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kPushTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, weakSelf.contentViewY, kScreenWidth, weakSelf.contentVH);
        weakSelf.bgButton.alpha = 0.35;
    }];
}

//显示
- (void)show
{
    if (_sheetStyle == GYZSheetStyleDefault) {
        [self pushDefaultStyeSheetView];
    }
    else if (_sheetStyle == GYZSheetStyleWeiChat) {
        [self pushWeiChatStyeSheetView];
    }
    else if (_sheetStyle == GYZSheetStyleTable) {
        [self pushTableStyeSheetView];
    }
}


//消失默认样式
- (void)dismissDefaulfSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDismissTime animations:^{
        weakSelf.contentView.frame = CGRectMake(kMargin, kScreenHeight, kMW, weakSelf.contentVH);
        weakSelf.footButton.frame = CGRectMake(kMargin, kScreenHeight + weakSelf.contentVH, kMW, kCellH);
        weakSelf.bgButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.contentView removeFromSuperview];
        [weakSelf.footButton removeFromSuperview];
        [weakSelf.bgButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

//消失微信样式
- (void)dismissWeiChatStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDismissTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.contentVH);
        weakSelf.footButton.frame = CGRectMake(0, weakSelf.footViewY + weakSelf.contentVH, kScreenWidth, kCellH);
        weakSelf.marginView.frame = CGRectMake(0, kScreenHeight + CGRectGetHeight(weakSelf.contentView.frame) + CGRectGetHeight(weakSelf.titleLabel.frame), kScreenWidth, kMargin);
        weakSelf.bgButton.alpha = 0.0;
        weakSelf.marginView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.contentView removeFromSuperview];
        [weakSelf.footButton removeFromSuperview];
        [weakSelf.marginView removeFromSuperview];
        [weakSelf.bgButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

//消失TableView样式
- (void)dismissTableStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDismissTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, weakSelf.contentVH);
        weakSelf.bgButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.contentView removeFromSuperview];
        [weakSelf.bgButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

- (void)setTitleTextFont:(UIFont *)titleTextFont
{
    _titleLabel.font = titleTextFont;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor
{
    _titleLabel.textColor = titleTextColor;
    
}

- (void)setItemTextFont:(UIFont *)itemTextFont
{
    _sheetView.cellTextFont = itemTextFont;
    
}

- (void)setItemTextColor:(UIColor *)itemTextColor
{
    _sheetView.cellTextColor = itemTextColor;
}

- (void)setCancleTextFont:(UIFont *)cancleTextFont
{
    if (cancleTextFont) {
        [_footButton.titleLabel setFont:cancleTextFont];
    }
}

- (void)setCancleTextColor:(UIColor *)cancleTextColor
{
    if (cancleTextColor) {
        [_footButton setTitleColor:cancleTextColor forState:UIControlStateNormal];
    }
}

- (void)setCancleTitle:(NSString *)cancleTitle
{
    if (cancleTitle) {
        [_footButton setTitle:cancleTitle forState:UIControlStateNormal];
    }
}

- (void)setIsUnifyCancleAction:(BOOL)isUnifyCancleAction
{
    if (isUnifyCancleAction) {
        [self.footButton addTarget:self action:@selector(footButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)didFinishSelectIndex:(SelectIndexBlock)block
{
    _selectBlock = block;
}

//把取消按钮的点击加入TableView的事件中统一处理
- (void)footButtonAction:(id)sender
{
    NSInteger indexsCount = (NSInteger)self.dataSource.count;
    if (indexsCount) {
        [self sheetViewDidSelectIndex:indexsCount selectTitle:_footButton.titleLabel.text selectImage:_footButton.imageView.image];
    }
}

//点击了TableView的哪行
- (void)sheetViewDidSelectIndex:(NSInteger)Index selectTitle:(NSString *)title selectImage:(UIImage *)image
{
    if (_selectBlock) {
        _selectBlock(Index,title);
    }
    
    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectIndex:title:image:)]) {
        [self.delegate sheetViewDidSelectIndex:Index title:title image:image];
    }
    
    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectIndex:title:image:sender:)]) {
        [self.delegate sheetViewDidSelectIndex:Index title:title image:image sender:self];
    }
    if (_sheetStyle == GYZSheetStyleDefault) {
        [self dismissDefaulfSheetView];
    }
    else if (_sheetStyle == GYZSheetStyleWeiChat) {
        [self dismissWeiChatStyeSheetView];
    }
    else if (_sheetStyle == GYZSheetStyleTable) {
        [self dismissTableStyeSheetView];
    }
}

@end
