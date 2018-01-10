//
//  NewMyBillVC.h
//  CityJinFu
//
//  Created by mic on 2017/10/17.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMyBillVC : UIViewController
//@property (nonatomic,strong) BillAcountModel *billAcountModel;//累计投资Model
//@property (nonatomic,strong) BillIndexModel *billIndexModel;//本月总览Model
//@property (nonatomic,strong) BillDataModel *billDataModel;//起始日期Model
//@property (nonatomic,strong) MyBillHeaderCell *myBillHeaderCell;
@property (nonatomic,strong) NSMutableArray *investArr;//投资记录
@property (nonatomic,strong) NSMutableArray *incomeArr;//回款记录
@property (nonatomic, strong) NSMutableArray *componentOneArr;//年份条件
@property (nonatomic, strong) NSMutableArray *componentTwoArr;//月份条件
@property (nonatomic,strong) UIButton *timeBtn;//时间按钮
@property (nonatomic, strong) NSString *result1;//选中的年
@property (nonatomic, strong) NSString *result2;//选中的月
@property (nonatomic,strong) NSString *result;//选择到的年月
@property (nonatomic, strong) UIPickerView *datePicker;//年月选择器
@property (nonatomic, strong) NSArray *pickerData;//年月选择器
@property (nonatomic, copy) NSString *typeStr;//筛选类型
@property (nonatomic, copy) NSString *nowDateStr;//当前时间
@property (nonatomic, copy) NSString *checkDate;//账单时间
@property (nonatomic, strong) UIView *dateBackView;//日期选择蒙板
@property (nonatomic, strong) UILabel *dateLabel;//年份显示lab
@property (nonatomic, assign) BOOL firstTime;//是否是第一次出现

@end
