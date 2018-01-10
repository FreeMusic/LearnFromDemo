//
//  MyAddressModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/21.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAddressModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *address;//收货地址
@property (nonatomic, strong) NSString *userName;//姓名
@property (nonatomic, strong) NSNumber *mobile;//联系方式

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
