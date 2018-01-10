//
//  NewItemModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/15.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewItemModel : NSObject
@property (nonatomic, strong) NSNumber *ID;//项目id
@property (nonatomic, strong) NSString *itemName;//名称
@property (nonatomic, strong) NSNumber *itemAccount;//总额
@property (nonatomic, strong) NSNumber *itemOngoingAccount;//投资中的金额
@property (nonatomic, strong) NSNumber *itemRate;//利率
@property (nonatomic, strong) NSNumber *itemAddRate;//增加利率
@property (nonatomic, strong) NSNumber *itemCycle;//期限
@property (nonatomic, strong) NSNumber *itemCycleUnit;//周期单位 1-天、2-月、3-季、4-年
@property (nonatomic, strong) NSNumber *itemSingleMinInvestment;//起投金额
@property (nonatomic, strong) NSNumber *itemStatus;//标的状态


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
