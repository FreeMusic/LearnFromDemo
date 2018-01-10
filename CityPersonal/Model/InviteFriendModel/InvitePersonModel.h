//
//  InvitePersonModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvitePersonModel : NSObject

@property (nonatomic,strong) NSString *realName;//名字
@property (nonatomic,strong) NSString *mobile;//手机号
@property (nonatomic,strong) NSNumber *addtime;//时间
@property (nonatomic, strong) NSString *isBindCard;//是否绑卡
@property (nonatomic, strong) NSString *isInvest;//是否投资

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
