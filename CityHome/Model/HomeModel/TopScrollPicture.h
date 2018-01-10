//
//  TopScrollPicture.h
//  xiaoxiaolicai
//
//  Created by mic on 16/4/12.
//  Copyright © 2016年 mic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopScrollPicture : NSObject
@property (nonatomic ,strong) NSString *pictureName;
@property (nonatomic ,strong) NSString *picturePath;
@property (nonatomic ,strong) NSNumber *ID;
@property (nonatomic ,strong) NSNumber *addtime;
@property (nonatomic ,strong) NSString *pictureUrl;
@property (nonatomic ,strong) NSNumber *pictureType;
@property (nonatomic ,strong) NSString *addip;
@property (nonatomic ,strong) NSNumber *sequence;//根据sequence进行排序
@property (nonatomic ,strong) NSNumber *isNeedLogin;//是否需要登录
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
