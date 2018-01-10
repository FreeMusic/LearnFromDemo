//
//  InvestDetailsModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/16.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvestDetailsModel : NSObject

@property (nonatomic,strong) NSString *cash;//账户可投金额
@property (nonatomic,strong) NSNumber *ID;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
