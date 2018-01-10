//
//  InviteFriendModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteFriendModel : NSObject

@property (nonatomic,strong) NSNumber *inviteCode;//邀请码
@property (nonatomic,strong) NSNumber *inviteRewards;//获得奖励
@property (nonatomic,strong) NSNumber *invitePersons;//邀请好友的人数
@property (nonatomic, strong) NSNumber *inviteInvestAmount;//佣金奖励
@property (nonatomic, strong) NSNumber *invitePersonReward;//邀请奖励

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
