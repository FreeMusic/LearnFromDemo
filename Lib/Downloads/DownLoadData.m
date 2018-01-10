
//
//  DownLoadData.m
//  007AFN的使用
//

#import "DownLoadData.h"
#import "AFAppDotNetAPIClient.h"
#import "AFHTTPSessionManager.h"
#import "MyBillModel.h"
#import "RedModel.h"
#import "TicketModel.h"
#import "RecordModel.h"
#import "ItemModel.h"
#import "AutoListModel.h"
#import "MessageModel.h"
#import "ActivityModel.h"
#import "ContractModel.h"
#import "AutoBidRecodeModel.h"
#import "PartInvestModel.h"
#import "PartIncomeModel.h"
#import "InvitePersonModel.h"
#import "AwardDetailsModel.h"
#import "IphoneModel.h"
#import "GoodsKindsModel.h"
#import "TopScrollPicture.h"
#import "NewItemModel.h"
#import "ItemListModel.h"
#import "MoneyListModel.h"
#import "ItemDetailsModel.h"
#import "InvestDetailsModel.h"
#import "BillInvestModel.h"
#import "BillIncomeModel.h"
#import "CollectListModel.h"
#import "NoticeLIstModel.h"
#import "MyAddressModel.h"
#import "MyOrderModel.h"
#import "OrderDetailsModel.h"
#import "NoticeTrendsModel.h"
#import "LogisticsInfoModel.h"
#import "IntergralModel.h"
#import "MoreStrategyModel.h"
#import "PlanModel.h"
#import "MyPlanModel.h"
#import "BankListModel.h"
#import "ShopBannerModel.h"
#import "RecommendModel.h"
#import "AutoRecordModel.h"
#import "GoodsRecomondModel.h"
#import "CalendarListModel.h"
#import "TopUpModel.h"
#import "NewMyBillModel.h"

static AFAppDotNetAPIClient * sharedClient = nil;

@implementation DownLoadData
/**
 token
 */
+ (NSURLSessionDataTask *)postappToken:(void (^) (id obj, NSError *error))block andMykey:(NSString *)myKey andUUID:(NSString *)uuid{
    
    NSString *url = @"/mobile/appToken";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:myKey forKey:@"secretKey"];
    [dic setValue:uuid forKey:@"uuid"];
    //结果返回
    return [[AFAppDotNetAPIClient sharedClient] POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"!!!!!!!!!!%@",dic1);
        
        if (block) {
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getIcon" object:nil];
        
        [Factory showNoDataHud];
    }];
}
//验证码
+ (NSURLSessionDataTask *)postVaildPhoneCode:(void (^) (id obj, NSError *error))block andvaildPhoneCode:(NSString *)phoneCode andmobile:(NSString *)mobile andtag:(NSInteger)tag stat:(NSString *)stat
{
    NSString *url = @"";
    
    switch (tag) {
        case 0:
            url = RegisterSendSms;//注册
            sharedClient = [Factory accessToken];//普通token
            break;
        case 1:
            url = @"/mobile/user/doLoginSendSms";//登录
            sharedClient = [Factory accessToken];//普通token
            break;
        case 2:
            url = @"/mobile/user/oldModifyMobileSms";//修改绑定旧手机短信
            sharedClient = [Factory userToken];//登录后的token
            break;
        case 3:
            url = @"/mobile/user/newModifyMobileSms";//修改绑定新手机短信
            sharedClient = [Factory userToken];//登录后的token
            break;
        case 4:
            url = @"/mobile/user/backPasswordSms";//找回密码短信
            sharedClient = [Factory accessToken];//普通token
            break;
        case 5:
            url = @"/mobile/user/backPatternLockSms";//修改手势密码
            sharedClient = [Factory userToken];//登录后的token
            break;
        case 6:
            url = @"/mobile/user/loginBandingSms";//第三方绑定登录
            sharedClient = [Factory accessToken];//普通token
            break;
        default:
            break;
    }
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:phoneCode forKey:@"vaildPhoneCode"];
    if (tag == 2 || tag == 5) {
        [dic setValue:mobile forKey:@"userId"];
    }else {
        [dic setValue:mobile forKey:@"mobile"];
    }
    [dic setValue:stat forKey:@"stat"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"!!!!!!!!!!%@",dic1);
        
        if (block) {
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
//注册
+ (NSURLSessionDataTask *)postRegister:(void (^) (id obj, NSError *error))block andmobile:(NSString *)mobile andpassword:(NSString *)password andinputCode:(NSString *)inputCode andjsCode:(NSString *)jsCode andvalidPhoneExpiredTime:(NSString *)validTime openId:(NSString *)openId type:(NSString *)type andidfa:(NSString *)idfa
{
    NSString *url = Register;
    sharedClient = [Factory accessToken];//普通token
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:openId forKey:@"openId"];//第三方
    [dic setValue:type forKey:@"type"];//注册类型
    [dic setValue:mobile forKey:@"mobile"];//手机号
    [dic setValue:password forKey:@"inviteCode"];//邀请码或者邀请人手机号
    [dic setValue:inputCode forKey:@"inputRandomCode"];//输入验证码
    [dic setValue:jsCode forKey:@"jsCode"];//验证码
    [dic setValue:validTime forKey:@"validPhoneExpiredTime"];//过期时间
    [dic setValue:@"iOS" forKey:@"referer"];//来源
    [dic setValue:idfa forKey:@"idfa"];//设备号
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"!!!!!!!!!!%@",dic1);
        
        if (block) {
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  注册
 */
+ (NSURLSessionDataTask *)postRegister:(void (^) (id obj, NSError *error))block andmobile:(NSString *)mobile andpassword:(NSString *)password andinputCode:(NSString *)inputCode andjsCode:(NSString *)jsCode andvalidPhoneExpiredTime:(NSString *)validTime openId:(NSString *)openId type:(NSString *)type andidfa:(NSString *)idfa version:(NSString *)version invitePerson:(NSString *)invitePerson{
    NSString *url = Register;
    sharedClient = [Factory accessToken];//普通token
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:openId forKey:@"openId"];//第三方
    [dic setValue:type forKey:@"type"];//注册类型
    [dic setValue:mobile forKey:@"mobile"];//手机号
    [dic setValue:inputCode forKey:@"inputRandomCode"];//输入验证码
    [dic setValue:jsCode forKey:@"jsCode"];//验证码
    [dic setValue:validTime forKey:@"validPhoneExpiredTime"];//过期时间
    [dic setValue:@"iOS" forKey:@"referer"];//来源
    [dic setValue:idfa forKey:@"idfa"];//设备号
    [dic setValue:password forKey:@"password"];//密码
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    [dic setValue:currentVersion forKey:@"version"];//版本号
    [dic setValue:invitePerson forKey:@"inviteCode"];//邀请码或者邀请人手机号
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"!!!!!!!!!!%@",dic1);
        
        if (block) {
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  注册-密码选填
 */
+ (NSURLSessionDataTask *)postRegisterSecond:(void (^) (id obj, NSError *error))block andmobile:(NSString *)mobile andpassword:(NSString *)password
{
    NSString *url = AddByPasswordByMobile;
    sharedClient = [Factory accessToken];//普通token
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:mobile forKey:@"mobile"];
    [dic setValue:password forKey:@"password"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"!!!!!!!!!!%@",dic1);
        
        if (block) {
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
//登录
+ (NSURLSessionDataTask *)postWetherSign:(void (^) (id obj, NSError *error))block andusername:(NSString *)username andpassword:(NSString *)password andclientId:(NSString *)clientId{
    
    NSString *url = @"/mobile/login";
    sharedClient = [Factory accessToken];//普通token
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:username forKey:@"username"];
    [dic setValue:password forKey:@"password"];
    if (clientId == nil) {
        
    }else{
        [dic setValue:clientId forKey:@"clientId"];
    }
    //2先获取当前工程项目版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    [dic setValue:currentVersion forKey:@"version"];
    
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"!!!!!!!!!!%@",dic1);
        
        if (block) {
            block(dic1,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,error);
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  快捷登录
 */
+ (NSURLSessionDataTask *)postQuickSign:(void (^) (id obj, NSError *error))block andmobile:(NSString *)mobile andinputCode:(NSString *)inputCode andjsCode:(NSString *)jsCode andvalidPhoneExpiredTime:(NSString *)validTime andclientId:(NSString *)clientId
{
    NSString *url = @"/mobile/quickLogin";
    sharedClient = [Factory accessToken];//普通token
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:mobile forKey:@"mobile"];
    [dic setValue:inputCode forKey:@"inputRandomCode"];
    [dic setValue:jsCode forKey:@"jsCode"];
    [dic setValue:validTime forKey:@"validPhoneExpiredTime"];
    if (clientId == nil) {
        
    }else{
        [dic setValue:clientId forKey:@"clientId"];
    }
    //2先获取当前工程项目版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    [dic setValue:currentVersion forKey:@"version"];
    
    NSLog(@"%@", dic);
    
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"!!!!!!!!!!%@",dic1);
        
        if (block) {
            block(dic1,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
        }
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  判断用户是否存在
 */
+ (NSURLSessionDataTask *)postUsername:(void (^) (id obj, NSError *error))block andusername:(NSString *)username{
    NSString *url = GetUserByMobile;
    sharedClient = [Factory accessToken];//普通token
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:username forKey:@"mobile"];
    
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"!!!!!!!!!!%@",dic1);
        
        if (block) {
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}

//找回密码
+ (NSURLSessionDataTask *)postBackPassword:(void (^)(id, NSError *))block mobileStr:(NSString *)mobileStr vaildPhoneCode:(NSString *)phoneCode JSCode:(NSString *)JSCode newPassword:(NSString *)newPassword validPhoneExpiredTime:(NSString *)validPhoneExpiredTime {
    
    
    NSString *url = ModifyByPasswordByMobile;
    sharedClient = [Factory accessToken];//普通token
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:phoneCode forKey:@"inputCode"];
    [dic setValue:JSCode forKey:@"sessionCode"];
    [dic setValue:mobileStr forKey:@"mobile"];
    [dic setValue:validPhoneExpiredTime forKey:@"validPhoneExpiredTime"];
    [dic setValue:newPassword forKey:@"password"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"!!!!!!!!!!%@",dic1);
        
        if (block) {
            block(dic1,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}

//签名
+ (NSURLSessionDataTask *)postSignature:(void (^)(id, NSError *))block userId:(NSString *)userId {
    
    NSString *url = @"/mobile/user/addSign";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"!!!!!!!!!!%@",dic1);
        
        if (block) {
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  收益
 */
+ (NSURLSessionDataTask *)postIncome:(void (^) (id obj, NSError *error))block userId:(NSString *)userId{
    
    NSString *url = AccountPage;
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    
    NSLog(@"请求数据了%@", dic);
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"收益 = %@", dic1);
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        //[Factory showNoDataHud];
        //[Factory alertMes:@"请在账户设置中退出重试"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZyyQuitLogin" object:nil];//通知退出登录
    }];
}
/**
 *  我的账单
 */
+ (NSURLSessionDataTask *)postMyBill:(void (^)(id, NSError *))block userId:(NSString *)userId pageNum:(int)pageNum andpageSize:(int)pageSize andMonth:(NSString *)queryMonth andType:(NSString *)type{
    
    NSString *url = @"/mobile/account/bill";
    sharedClient = [Factory userToken];//userToken
    
    NSString * str = [NSString stringWithFormat:@"%d",pageNum];
    NSString * str1 = [NSString stringWithFormat:@"%d",pageSize];
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:str forKey:@"pageNum"];
    [dic setValue:str1 forKey:@"pageSize"];
    [dic setValue:queryMonth forKey:@"queryMonth"];
    [dic setValue:type forKey:@"type"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary * dicData = [NSMutableDictionary dictionary];
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        NSArray *newArray = dic[@"amountLogList"][@"list"];
        NSLog(@"myBill:%li",(unsigned long)newArray.count);
        
        NSMutableArray *newM = [NSMutableArray array];
        [newArray enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
            
            MyBillModel *model = [[MyBillModel alloc] initWithDictionary:obj];
            
            [newM addObject:model];
        }];
        
        [dicData setValue:newM forKey:@"SUCCESS"];
        [dicData setValue:dic[@"amountLogResponse"] forKey:@"amountLogResponse"];
        [dicData setValue:dic[@"days"] forKey:@"days"];
        [dicData setValue:dic[@"nowDate"] forKey:@"nowDate"];
        [dicData setValue:dic[@"amountLogList"][@"paginator"] forKey:@"paginator"];
        if (block) {
            
            block(dicData,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  资产明细
 */
+ (NSURLSessionDataTask *)postAccountPage:(void (^) (id obj, NSError *error))block userId:(NSString *)userId
{
    NSString *url = @"/mobile/account/accountPage";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
                NSLog(@"!!!!!!!!!!%@",dic1);
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  用户个人信息
 */
+ (NSURLSessionDataTask *)postUserInformation:(void (^) (id obj, NSError *error))block userId:(NSString *)userId
{
    NSString *url = @"/mobile/user/information";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"!!!!!!!!!!用户个人信息  %@",dic1);
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  修改绑定手机
 */
+ (NSURLSessionDataTask *)postModifyMobile:(void (^) (id obj, NSError *error))block mobile:(NSString *)mobile inputRandomCode:(NSString *)inputCode jsCode:(NSString *)jsCode validPhoneExpiredTime:(NSString *)validPhoneExpiredTime oldMobile:(NSString *)oldMobile{
    
    NSString *url = @"/mobile/user/modifyMobile";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:mobile forKey:@"mobile"];
    [dic setValue:inputCode forKey:@"inputRandomCode"];
    [dic setValue:jsCode forKey:@"jsCode"];
    [dic setValue:validPhoneExpiredTime forKey:@"validPhoneExpiredTime"];
    [dic setValue:oldMobile forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"!!!!!!!!!!%@",dic1);
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  校验验证码
 */
+ (NSURLSessionDataTask *)postCheckMobile:(void (^) (id obj, NSError *error))block inputRandomCode:(NSString *)inputCode jsCode:(NSString *)jsCode validPhoneExpiredTime:(NSString *)validPhoneExpiredTime
{
    NSString *url = @"/mobile/user/checkMobile";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:inputCode forKey:@"inputRandomCode"];
    [dic setValue:jsCode forKey:@"jsCode"];
    [dic setValue:validPhoneExpiredTime forKey:@"validPhoneExpiredTime"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"!!!!!!!!!!%@",dic1);
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  充值加签
 */
+ (NSURLSessionDataTask *)postRechargeSignature:(void (^)(id obj, NSError *error))block userId:(NSString *)userId amount:(NSString *)amount{
    
    NSString *url = @"/mobile/account/rechargeAddSign";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:amount forKey:@"amount"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  获取银行卡信息
 */
+ (NSURLSessionDataTask *)postBankMessage:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = RealNameCheck;
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"获取银行卡信息 %@", dic1);
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  提现显示账户余额
 */
+ (NSURLSessionDataTask *)postRemainCount:(void (^)(id obj, NSError *error))block userId:(NSString *)userId {
    
    NSString *url = @"/mobile/account/cashData";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  提现
 */
+ (NSURLSessionDataTask *)postWithdraw:(void (^)(id obj, NSError *error))block userId:(NSString *)userId cashAmount:(NSString *)cashAmount bankId:(NSString *)bankId password:(NSString *)password mcryptKey:(NSString *)mcryptKey routeFlag:(NSString *)routeFlag{
    
    NSString *url = Cash;
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:password forKey:@"password"];
    [dic setValue:cashAmount forKey:@"cashAmount"];
    [dic setValue:bankId forKey:@"bankId"];
    [dic setValue:mcryptKey forKey:@"mcryptKey"];
    [dic setValue:routeFlag forKey:@"routeFlag"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"提现 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
    
}

/**
 *  红包、加息劵、体验金
 */
+ (NSURLSessionDataTask *)postCouponTicketGold:(void (^)(id obj, NSError *error))block userId:(NSString *)userId andpageSize:(NSString *)size andpageNum:(NSString *)num andtype:(NSInteger)tag
{
    NSString *url = @"";
    if (tag == 0) {
        //红包
        url = @"/mobile/coupon/list";
    }else if (tag == 1){
        //加息券
        url = @"/mobile/ticket/list";
    }else{
        //体验金
        url = @"/mobile/gold/list";
    }
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:size forKey:@"pageSize"];
    [dic setValue:num forKey:@"pageNum"];
    
    NSLog(@"%@%@     %@", Localhost,url,dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"红包、加息劵、体验金 = %@    %ld",dic1, tag);
        NSArray *array = dic1[@"list"];//参数
        NSDictionary *diction = dic1[@"paginator"];//分页
        NSMutableArray *muArray = [NSMutableArray array];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (tag == 0 || tag == 2) {
                NSLog(@"%@",obj);
                RedModel *model = [[RedModel alloc]initWithDictionary:obj];
                [muArray addObject:model];//红包
            }else if(tag == 1){
                TicketModel *ticket = [[TicketModel alloc]initWithDictionary:obj];
                [muArray addObject:ticket];//加息劵
            }
        }];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:muArray forKey:@"SUCCESS"];
        [dictionary setValue:diction forKey:@"SUCCESS1"];
        NSLog(@"112345684848---+++???%@",dic1[@"paginator"]);
        if (block) {
            
            block(dictionary,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
    
}
/**
 *  投资时显示红包
 */
+ (NSURLSessionDataTask *)postShowRedMessage:(void (^) (id obj, NSError *error))block amount:(NSString *)amount userId:(NSString *)userId anditemCycle:(NSString *)itemCycle andbalance:(NSString *)balance {
    
    NSString *url = @"/mobile/invest/coupon";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:userId forKey:@"userId"];//用户ID
    [dic setValue:amount forKey:@"amount"];//金额
    [dic setValue:itemCycle forKey:@"cycle"];//时间
    [dic setValue:balance forKey:@"balance"];//项目可投金额
    NSLog(@"%@",dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"投资时显示红包 %@", dic);
        NSMutableArray *muArray = [NSMutableArray array];
        
        [dic[@"list"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RedModel *model = [[RedModel alloc]initWithDictionary:obj];
            [muArray addObject:model];//红包
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:muArray forKey:@"SUCCESS"];
        NSLog(@"%@",dic);
        if (block) {
            
            block(dictionary,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  投资时显示加息券
 */
+ (NSURLSessionDataTask *)postShowTicketMessage:(void (^) (id obj, NSError *error))block amount:(NSString *)amount userId:(NSString *)userId anditemCycle:(NSString *)itemCycle andbalance:(NSString *)balance {
    
    NSString *url = @"/mobile/invest/ticket";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:userId forKey:@"userId"];//用户ID
    [dic setValue:amount forKey:@"amount"];//金额
    [dic setValue:itemCycle forKey:@"cycle"];//期限
    [dic setValue:balance forKey:@"balance"];//项目余额
    NSLog(@"%@",dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"投资时显示加息券%@", dic);
        NSMutableArray *muArray = [NSMutableArray array];
        
        [dic[@"list"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            TicketModel *ticket = [[TicketModel alloc]initWithDictionary:obj];
            [muArray addObject:ticket];//加息劵
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:muArray forKey:@"SUCCESS"];
        
        if (block) {
            
            block(dictionary,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  项目的购买
 */
+ (NSURLSessionDataTask *)postBuyProject:(void (^) (id obj, NSError *error))block amount:(NSString *)amount userId:(NSString *)userId itemId:(NSString *)itemId couponId:(NSString *)couponId ticketId:(NSString *)ticketId {
    
    NSString *url = @"/mobile/invest/buy";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)amount.integerValue] forKey:@"amount"];
    [dic setValue:itemId forKey:@"itemId"];
    [dic setValue:couponId forKey:@"couponId"];
    [dic setValue:ticketId forKey:@"ticketId"];
    [dic setValue:@"7" forKey:@"investType"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
    
}
/**
 *  登录状态的项目的信息
 */
+ (NSURLSessionDataTask *)postProjectMessage:(void (^) (id obj, NSError *error))block userId:(NSString *)userId itemId:(NSString *)itemId {
    
    NSString *url = @"/mobile/item/information";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:itemId forKey:@"itemId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  实名认证(开户)
 */
+ (NSURLSessionDataTask *)postRealName:(void (^) (id obj, NSError *error))block userId:(NSString *)userId realName:(NSString *)realname identifyCard:(NSString *)identifyCard {
    
    NSString *url = RealName;
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:userId forKey:@"userId"];//用户ID
    [dic setValue:realname forKey:@"bizType"];//用户类型 ：01-投资用户，02-借款用户，06-借款/投资混合用户
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  添加银行卡
 */
+ (NSURLSessionDataTask *)postAddBank:(void (^) (id obj, NSError *error))block userId:(NSString *)userId {
    
    NSString *url = [NSString stringWithFormat:@"/mobile/account/addBank"];
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  实名成功后的信息
 */
+ (NSURLSessionDataTask *)postrealName:(void (^) (id obj, NSError *error))block userId:(NSString *)userId
{
    NSString *url = @"/mobile/user/realNameInformation";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  投资记录
 */
+ (NSURLSessionDataTask *)postItemInformation:(void (^) (id obj, NSError *error))block itemId:(NSString *)itemId andpageSize:(NSString *)pageSize andpageNum:(NSString *)pageNum{
    
    NSString *url = @"/mobile/item/investList";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:itemId forKey:@"itemId"];
    [dic setValue:pageSize forKey:@"pageSize"];
    [dic setValue:pageNum forKey:@"pageNum"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic1[@"list"];//参数
        NSDictionary *diction = dic1[@"paginator"];//分页
        NSMutableArray *muArray = [NSMutableArray array];
        NSLog(@"%@",dic1);
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RecordModel *model = [[RecordModel alloc]initWithDictionary:obj];
            [muArray addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        if (diction != nil) {
            [dictionary setValue:diction forKey:@"SUCCESS1"];
        }
        [dictionary setValue:muArray forKey:@"SUCCESS"];
        
        if (block) {
            
            block(dictionary,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  首页数据
 */
+ (NSURLSessionDataTask *)postHome:(void (^) (id obj, NSError *error))block itemType:(NSString *)itemType pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize {
    
    NSString *url = @"/mobile/index";
    sharedClient = [Factory accessToken];//token
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    NSString *num = [NSString stringWithFormat:@"%li",(long)pageNum];
    NSString *size = [NSString stringWithFormat:@"%li",(long)pageSize];
    [dic setValue:itemType forKey:@"itemType"];
    [dic setValue:num forKey:@"pageNum"];
    [dic setValue:size forKey:@"pageSize"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  收益计算
 */
+ (NSURLSessionDataTask *)postcalCulator:(void (^) (id obj, NSError *error))block andamount:(NSString *)amount anditemId:(NSString *)itemId andticketId:(NSString *)ticketId{
    NSLog(@"88888+++++%ld",(long)amount.integerValue);
    NSString *url = @"/mobile/invest/calculator";
    sharedClient = [Factory accessToken];//token
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)amount.integerValue] forKey:@"amount"];
    [dic setValue:itemId forKey:@"itemId"];
    [dic setValue:ticketId forKey:@"ticketId"];
    
    NSLog(@"%@", dic);
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  自动投标
 */
+ (NSURLSessionDataTask *)postAutoAdd:(void (^) (id obj, NSError *error))block anduserId:(NSString *)userId anditemStatus:(NSString *)itemStatus anditemAmountType:(NSString *)AmountType anditemAmount:(NSString *)itemAmount anditemRateMin:(NSString *)rateMin anditemRateMax:(NSString *)rateMax anditemRateStatus:(NSString *)rateStatus anditemDayMin:(NSString *)daymin anditemDayMax:(NSString *)dayMax anditemDayStatus:(NSString *)dayStatus anditemLockStatus:(NSString *)lockStatus anditemLockCycle:(NSString *)lockCycle anditemAddRate:(NSString *)addRate andjsCode:(NSString *)jsCode andinputCode:(NSString *)inputCode andvalidPhoneExpiredTime:(NSString *)validPhoneExpiredTime andgoodsName:(NSString *)goodsName andautoId:(NSString *)autoId{
    
    NSLog(@"5555----%lu-----9999---%@",(unsigned long)goodsName.length,autoId);
    
    NSString *url = @"";
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    if (goodsName.length == 0 && autoId.length != 0) {
        url = @"/mobile/user/modifyAuto";
        [dic setValue:autoId forKey:@"id"];
    }else{
        url = @"/mobile/user/autoAdd";
    }
    sharedClient = [Factory userToken];//userToken
    
    
    [dic setValue:userId forKey:@"itemUserId"];
    [dic setValue:itemStatus forKey:@"itemStatus"];
    [dic setValue:AmountType forKey:@"itemAmountType"];
    [dic setValue:itemAmount forKey:@"itemAmount"];
    [dic setValue:rateMin forKey:@"itemRateMin"];
    [dic setValue:rateMax forKey:@"itemRateMax"];
    [dic setValue:rateStatus forKey:@"itemRateStatus"];
    [dic setValue:daymin forKey:@"itemDayMin"];
    [dic setValue:dayMax forKey:@"itemDayMax"];
    [dic setValue:dayStatus forKey:@"itemDayStatus"];
    [dic setValue:lockStatus forKey:@"itemLockStatus"];
    [dic setValue:lockCycle forKey:@"itemLockCycle"];
    [dic setValue:addRate forKey:@"itemAddRate"];
    [dic setValue:jsCode forKey:@"jsCode"];
    [dic setValue:inputCode forKey:@"inputCode"];
    [dic setValue:validPhoneExpiredTime forKey:@"validPhoneExpiredTime"];
    [dic setValue:goodsName forKey:@"goodsName"];
    NSLog(@"999999-------%@",dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  体验金
 */
+ (NSURLSessionDataTask *)postExperienceGlod:(void (^) (id obj, NSError *error))block userId:(NSString *)userId{
    
    NSString *url = @"/admin/experiencedGold/useExperiencedGold";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"体验金 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory alertMes:@"该体验金已失效"];
    }];
}
/**
 *  充值
 */
+ (NSURLSessionDataTask *)postApplyRecharge:(void (^) (id obj, NSError *error))block userId:(NSString *)userId amount:(NSString *)amount bankId:(NSString *)bankId password:(NSString *)password mcryptKey:(NSString *)mcryptKey paymentId:(NSString *)paymentId{
    
    NSString *url = ApplyRecharge;
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];//用户ID
    [dic setValue:amount forKey:@"amount"];//金额
    [dic setValue:bankId forKey:@"bankId"];
    [dic setValue:password forKey:@"password"];//
    [dic setValue:mcryptKey forKey:@"mcryptKey"];//
    [dic setValue:paymentId forKey:@"paymentId"];
    
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"充值  %@   %@", dic1, dic1[@"messageText"]);
        if (block) {
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  用户系统设置
 */
+ (NSURLSessionDataTask *)postWithSystem:(void (^) (id obj, NSError *error))block userId:(NSMutableDictionary *)muDic andtag:(NSInteger)tag{
    
    NSString *url = @"";
    switch (tag) {
        case 0:
            url = @"/mobile/user/getAppSettingsByUserId";//获取用户系统设置
            break;
        case 1:
            url = @"/mobile/user/appSetting";//修改用户系统设置
            break;
        case 2:
            url = @"/mobile/user/hasPatternLock";//手势密码是否开启
            break;
        case 3:
            url = @"/mobile/user/matchPatternLock";//用户设置的手势密码
            break;
        case 4:
            url = @"/mobile/user/updatePatternLock";//用户修改了手势密码
            break;
        default:
            break;
    }
    sharedClient = [Factory userToken];//userToken
    NSLog(@"%@",muDic);
    //结果返回
    return [sharedClient POST:url parameters:muDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  直接登录
 */
+ (NSURLSessionDataTask *)postInstantLogin:(void (^) (id obj, NSError *error))block mobile:(NSString *)mobile clientId:(NSString *)clientId {
    
    NSString *url = @"/mobile/getUserId";
    sharedClient = [Factory accessToken];//token
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:mobile forKey:@"mobile"];
    if (clientId == nil) {
        
    }else{
        [dic setValue:clientId forKey:@"clientId"];
    }
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  自动投标查询
 */
+ (NSURLSessionDataTask *)postGetAuto:(void (^) (id obj, NSError *error))block userId:(NSString *)userId{
    
    NSString *url = GetByUserId;
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"自动投标查询%@", dic1);
        AutoListModel *model = nil;
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        if ([dic1[@"auto"] isEqual:[NSNull null]]) {
            
        }else{
            model = [[AutoListModel alloc] initWithDictionary:dic1[@"auto"]];
            [dictionary setValue:model forKey:@"model"];
        }
        
        if (block) {
            
            block(dictionary,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  自动投标记录
 */
+ (NSURLSessionDataTask *)postGetAutoRecode:(void (^) (id obj, NSError *error))block userId:(NSString *)userId
{
    NSString *url = @"/mobile/user/getInvestAuto";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic1[@"list"];//参数
        NSDictionary *diction = dic1[@"paginator"];//分页
        NSMutableArray *muArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            AutoBidRecodeModel *ticket = [[AutoBidRecodeModel alloc]initWithDictionary:obj];
            [muArray addObject:ticket];//自动投标记录列表
        }];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:muArray forKey:@"SUCCESS"];
        [dictionary setValue:diction forKey:@"SUCCESS1"];
        
        NSLog(@"99999----%@",dic1);
        if (block) {
            
            block(dictionary,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  自动投标短信
 */
+ (NSURLSessionDataTask *)postAutoSms:(void (^) (id obj, NSError *error))block userId:(NSString *)userId andvaildPhoneCode:(NSString *)vaildPhoneCode{
    
    NSString *url = @"/mobile/user/autoSms";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:vaildPhoneCode forKey:@"vaildPhoneCode"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
//修改密码
+ (NSURLSessionDataTask *)postChange_passwordRecord:(void (^) (id obj, NSError *error))block andLoginName:(NSString *)LoginName andnewPassword:(NSString *)newPassword andphoneCode:(NSString *)phoneCode andjsCode:(NSString *)jsCode andimageTime:(NSString *)imageTime
{
    NSString *str = [NSString stringWithFormat:@"/mobile/modifyByPasswordByMobile"];
    sharedClient = [Factory userToken];//userToken
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:LoginName forKey:@"mobile"];
    [dic setValue:newPassword forKey:@"password"];
    [dic setValue:phoneCode forKey:@"inputCode"];
    [dic setValue:jsCode forKey:@"sessionCode"];
    [dic setValue:imageTime forKey:@"validPhoneExpiredTime"];
    
    return [sharedClient POST:str parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
//短信验证码(找回密码)
+ (NSURLSessionDataTask *)PostWithVerificationUserCode:(void (^) (id obj, NSError *error))block vaildPhoneCode:(NSString *)vaildPhoneCode userId:(NSString *)userId
{
    NSString *str = @"/mobile/user/modifyPasswordSms";
    sharedClient = [Factory userToken];//userToken
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:vaildPhoneCode forKey:@"vaildPhoneCode"];
    [dic setValue:userId forKey:@"mobile"];
    
    return [sharedClient POST:str parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"短信验证码(找回密码) == %@", dic1);
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
//消息中心
+ (NSURLSessionDataTask *)postSiteMail:(void (^)(id obj, NSError *error))block userId:(NSString *)userId andpageSize:(NSString *)size andpageNum:(NSString *)num
{
    NSString *url = @"/mobile/user/sitemail";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:size forKey:@"pageSize"];
    [dic setValue:num forKey:@"pageNum"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic1[@"list"];//参数
        NSLog(@"%@",dic1);
        NSDictionary *diction = dic1[@"paginator"];//分页
        NSMutableArray *muArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MessageModel *message = [[MessageModel alloc]initWithDictionary:obj];
            [muArray addObject:message];//消息中心
        }];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:muArray forKey:@"SUCCESS"];
        [dictionary setValue:diction forKey:@"SUCCESS1"];
        NSLog(@"112345684848---+++???%@",dic1[@"list"]);
        if (block) {
            
            block(dictionary,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 * 获取用户系统设置
 */
+ (NSURLSessionDataTask *)postUserSystemSetting:(void (^)(id object, NSError *error))block userId:(NSString *)userId {
    
    NSString *url = @"/mobile/user/getAppSettingsByUserId";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,error);
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  修改系统设置
 */
+ (NSURLSessionDataTask *)postChangeSystemSetting:(void (^)(id obj, NSError *error))block userId:(NSString *)userId gesture:(NSString *)gesture touchID:(NSString *)touchID accountProtect:(NSString *)accountProtect {
    
    NSString *url = @"/mobile/user/appSetting";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:gesture forKey:@"whetherPatternLock"];
    [dic setValue:touchID forKey:@"whetherTouchIdLock"];
    [dic setValue:accountProtect forKey:@"whetherAccountProtect"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  查看手势密码是否存在
 */
+ (NSURLSessionDataTask *)postGestureExist:(void (^)(id obj, NSError *error))block userId:(NSString *)userId {
    
    NSString *url = @"/mobile/user/hasPatternLock";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  更新手势密码
 */
+ (NSURLSessionDataTask *)postUpdateGesture:(void (^)(id obj, NSError *error))block userId:(NSString *)userId newGesture:(NSString *)newGesture {
    
    NSString *url = @"/mobile/user/updatePatternLock";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:newGesture forKey:@"newPatternLock"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  验证手势密码
 */
+ (NSURLSessionDataTask *)postMatchGesture:(void (^)(id obj, NSError *error))block userId:(NSString *)userId gestureStr:(NSString *)gestureStr {
    
    
    NSString *url = @"/mobile/user/matchPatternLock";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:gestureStr forKey:@"oldPatternLock"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}

/**
 更新头像
 */
+ (NSURLSessionDataTask *)postUpdateIcon:(void (^)(id obj, NSError *error))block userId:(NSString *)userId {
    
    NSString *url = @"/mobile/user/getAvatar";
    sharedClient = [Factory userToken];//userToken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 充值记录
 */
+ (NSURLSessionDataTask *)postTopupRecorde:(void (^)(id obj, NSError *error))block userId:(NSString *)userId pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize {
    
    NSString *url = GetRechargeListByUserId;
    sharedClient = [Factory userToken];//userToken
    
    NSString *num = [NSString stringWithFormat:@"%li",(long)pageNum];
    NSString *size = [NSString stringWithFormat:@"%li",(long)pageSize];
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:num forKey:@"pageNum"];
    [dic setValue:size forKey:@"pageSize"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 提现记录
 */
+ (NSURLSessionDataTask *)postWithdrawRecorde:(void (^)(id obj, NSError *error))block userId:(NSString *)userId pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize {
    
    NSString *url = GetCashListByUserId;
    sharedClient = [Factory userToken];//userToken
    NSString *num = [NSString stringWithFormat:@"%li",(long)pageNum];
    NSString *size = [NSString stringWithFormat:@"%li",(long)pageSize];
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:num forKey:@"pageNum"];
    [dic setValue:size forKey:@"pageSize"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}

/**
 合同查看
 */
+ (NSURLSessionDataTask *)postContractsList:(void (^)(id obj, NSError *error))block userId:(NSString *)userId pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize{
    
    
    NSString *url = @"/mobile/user/contractsList";
    sharedClient = [Factory userToken];//userToken
    NSString *num = [NSString stringWithFormat:@"%li",(long)pageNum];
    NSString *size = [NSString stringWithFormat:@"%li",(long)pageSize];
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:num forKey:@"pageNum"];
    [dic setValue:size forKey:@"pageSize"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *modelArr = [NSMutableArray array];
        
        for (NSDictionary *modelDic in dic1[@"list"]) {
            
            ContractModel *model = [[ContractModel alloc] initWithDictionary:modelDic];
            [modelArr addObject:model];
        }
        NSDictionary *clipDic = @{
                                  @"modelArr" : modelArr,
                                  @"paginator" : dic1[@"paginator"]
                                  };
        
        NSLog(@"%@",clipDic);
        if (block) {
            
            block(clipDic,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"下载文档数据请求失败");
        block(nil, error);
    }];
}

/**
 *  修改手势密码验证码校验
 */
+ (NSURLSessionDataTask *)postCheckOutGesture:(void (^)(id obj, NSError *error))block mobile:(NSString *)mobile inputCode:(NSString *)inputCode validTime:(NSString *)validTime jsCode:(NSString *)jsCode {
    
    NSString *url = @"/mobile/matchVaildPhoneCode";
    sharedClient = [Factory userToken];//userToken
    
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:mobile forKey:@"mobile"];
    [dic setValue:inputCode forKey:@"inputRandomCode"];
    [dic setValue:jsCode forKey:@"jsCode"];
    [dic setValue:validTime forKey:@"validPhoneExpiredTime"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
    
}
/*
 投资记录详情
 */
+ (NSURLSessionDataTask *)postInvestDetail:(void (^)(id obj, NSError *error))block andInvestId:(NSString *)investId
{
    NSString *url = @"/mobile/item/investDetail";
    sharedClient = [Factory accessToken];//token
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:investId forKey:@"investId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/*
 活动页面
 */
+ (NSURLSessionDataTask *)postActivity:(void (^)(id obj, NSError *error))block {
    
    NSString *url = @"/mobile/selected/activity";
    sharedClient = [Factory accessToken];//token
    //参数
    return [sharedClient POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *clipArr = [NSMutableArray array];
        for (NSDictionary *clipDic in dic1[@"list"]) {
            
            ActivityModel *model = [[ActivityModel alloc] initWithDictionary:clipDic];
            
            [clipArr addObject:model];
        }
        
        NSLog(@"555++++%@",dic1);
        if (block) {
            
            block(clipArr,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"活动数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 修改自动投标
 */
+ (NSURLSessionDataTask *)postModifyAuto:(void (^)(id obj, NSError *error))block andUserId:(NSString *)userId andId:(NSString *)Id andvalidPhoneExpiredTime:(NSString *)validPhoneExpiredTime andjsCode:(NSString *)jsCode andinputCode:(NSString *)inputCode anditemStatus:(NSString *)itemStatus{
    
    NSString *url = @"/mobile/user/modifyAuto";
    sharedClient = [Factory userToken];//usertoken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"itemUserId"];
    [dic setValue:Id forKey:@"id"];
    [dic setValue:itemStatus forKey:@"itemStatus"];
    [dic setValue:validPhoneExpiredTime forKey:@"validPhoneExpiredTime"];
    [dic setValue:jsCode forKey:@"jsCode"];
    [dic setValue:inputCode forKey:@"inputCode"];
    [dic setValue:@"0" forKey:@"itemLockStatus"];
    NSLog(@"999++%@",dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}

/**
 第三方登录
 */
+ (NSURLSessionDataTask *)postLoginWithOtherSelector:(void (^)(id obj, NSError *error))block openId:(NSString *)openId type:(NSString *)type clientId:(NSString *)clientId nickname:(NSString *)nickname {
    
    NSString *url = @"/mobile/thirdpartLogin";
    sharedClient = [Factory accessToken];//token
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:openId forKey:@"openId"];
    [dic setValue:type forKey:@"type"];
    if (clientId == nil) {
        
    }else{
        [dic setValue:clientId forKey:@"clientId"];
    }
    [dic setValue:nickname forKey:@"nickname"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
    
}
/**
 第三方绑定登录
 */
+ (NSURLSessionDataTask *)postRelevanceLogin:(void (^)(id obj, NSError *error))block openId:(NSString *)openId type:(NSString *)type mobile:(NSString *)mobile clientId:(NSString *)clientId inputRandomCode:(NSString *)inputRandomCode jsCode:(NSString *)jsCode validPhoneExpiredTime:(NSString *)validPhoneExpiredTime nickname:(NSString *)nickname {
    
    NSString *url = @"/mobile/thirdpartBandingLogin";
    sharedClient = [Factory accessToken];//token
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:openId forKey:@"openId"];
    [dic setValue:type forKey:@"type"];
    if (clientId == nil) {
        
    }else{
        [dic setValue:clientId forKey:@"clientId"];
    }
    [dic setValue:mobile forKey:@"mobile"];
    [dic setValue:inputRandomCode forKey:@"inputRandomCode"];
    [dic setValue:jsCode forKey:@"jsCode"];
    [dic setValue:validPhoneExpiredTime forKey:@"validPhoneExpiredTime"];
    [dic setValue:nickname forKey:@"nickname"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}

/**
 获取微信用户openId
 */
+ (NSURLSessionDataTask *)getWechatMessage:(void (^)(id obj,NSError *error))block code:(NSString *)code {
    
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxe288f2e30492370f&secret=c39195e79d9197ba6079a9f2892d8f87&code=%@&grant_type=authorization_code",code];
    sharedClient = [Factory accessToken];//token
    
    return [sharedClient GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"555++++%@",dic1);
        if (block) {
            
            block(dic1,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"微信openId数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 获取微信用户个人信息
 */
+ (NSURLSessionDataTask *)getWechatUserInfo:(void (^)(id obj,NSError *error))block token:(NSString *)token openId:(NSString *)openId {
    
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openId];
    sharedClient = [Factory accessToken];//token
    
    return [sharedClient GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"555++++%@",dic1);
        if (block) {
            
            block(dic1,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"微信openId数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 合同的查看
 */
+ (NSURLSessionDataTask *)postContractsSee:(void (^)(id obj,NSError *error))block orderNo:(NSString *)orderNo{
    
    NSString *url = @"/mobile/user/getContracts";
    sharedClient = [Factory userToken];//usertoken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:orderNo forKey:@"orderNo"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 邀请好友信息数据
 */
+ (NSURLSessionDataTask *)postInviteUserMessage:(void (^)(id obj, NSError *error))block userId:(NSString *)userId {
    
    NSString *url = @"/mobile/user/getRealName";
    sharedClient = [Factory userToken];//usertoken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
    
}
/**
 删除自动投标
 */
+ (NSURLSessionDataTask *)postDeleteAuto:(void (^)(id obj, NSError *error))block autoId:(NSString *)autoId{
    NSString *url = @"/mobile/user/deleteAuto";
    sharedClient = [Factory userToken];//usertoken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:autoId forKey:@"autoId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
    
}
/**
 活动页数据
 */
+ (NSURLSessionDataTask *)postActivityScreen:(void (^)(id obj, NSError * error))block {
    
    
    NSString *url = @"/mobile/index/getScreenPic";
    sharedClient = [Factory accessToken];//token
    //参数
    
    //结果返回
    return [sharedClient POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"活动页数据 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(task,error);
        NSLog(@"数据请求失败");
        
    }];
    
    
}
/**
 分享回调
 */
+ (NSURLSessionDataTask *)postShareMessage:(void (^)(id obj, NSError *error))block userId:(NSString *)userId {
    
    NSString *url = @"/mobile/user/shareBid";
    sharedClient = [Factory userToken];//usertoken
    //参数
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
    
}
/**
 服务器是否处于对账期
 */
+ (NSURLSessionDataTask *)postServeTime:(void (^)(id obj, NSError *error))block {
    
    NSString *url = @"/mobile/account/getServerTime";
    sharedClient = [Factory userToken];//usertoken
    
    //结果返回
    return [sharedClient POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
    
}

/**
 项目剩余可投金额
 */
+ (NSURLSessionDataTask *)postItemRemainAccount:(void (^)(id obj, NSError *error))block itemId:(NSString *)itemId {
    
    
    NSString *url = @"/mobile/item/itemInfo";
    sharedClient = [Factory accessToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:itemId forKey:@"itemId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 根据月份获取起止日
 */
+ (NSURLSessionDataTask *)postGetStartAndEndByMonth:(void (^)(id obj, NSError *error))block queryMonth:(NSString *)queryMonth{
    NSString *url = @"/mobile/bill/getStartAndEndByMonth";
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:queryMonth forKey:@"queryMonth"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 累计投资和累计收益（总的）
 */
+ (NSURLSessionDataTask *)postBillCount:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = @"/mobile/bill/billCount";      sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"累计投资  累计收益数据请求 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 我的账单首页
 */
+ (NSURLSessionDataTask *)postBillIndex:(void (^)(id obj, NSError *error))block userId:(NSString *)userId queryMonth:(NSString *)queryMonth{
    NSString *url = @"/mobile/bill/index";
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:queryMonth forKey:@"queryMonth"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"我的账单首页 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 充值提现界面数据展示
 */
+ (NSURLSessionDataTask *)postData:(void (^)(id obj, NSError *error))block userId:(NSString *)userId type:(NSInteger)tag{
    NSString *url = @"";
    sharedClient = [Factory userToken];//token
    if (tag == 0) {
        url = RechargeData;//充值
    }else{
        url = CashData;//提现
    }
    
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 用户本月部分投资记录
 */
+ (NSURLSessionDataTask *)postGetInvestListAllByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId queryMonth:(NSString *)queryMonth{
    NSString *url = GetInvestListAllByUserId;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:queryMonth forKey:@"queryMonth"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"用户本月部分投资记录 == %@", dic1);
        
        NSArray *arr = dic1[@"lists"];
        NSMutableArray *mutaArr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PartInvestModel *model = [[PartInvestModel alloc] initWithDictionary:obj];
            [mutaArr addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:mutaArr forKey:@"SUCCESS"];
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 充值提现界面数据详情展示
 */
+ (NSURLSessionDataTask *)postDetailsData:(void (^)(id obj, NSError *error))block userId:(NSString *)userId rechargeId:(NSString *)rechargeId type:(NSInteger)tag{
    NSString *url = @"";
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (tag == 0) {
        url = RechargeDetails;//充值
        [dic setValue:rechargeId forKey:@"rechargeId"];//充值记录id
    }else{
        url = CashDetails;//提现
        [dic setValue:rechargeId forKey:@"cashId"];//提现记录id
    }
    
    [dic setValue:userId forKey:@"userId"];//用户ID
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 提现/充值单条记录进度数据展示
 */
+ (NSURLSessionDataTask *)postRechargeDetails:(void (^)(id obj, NSError *error))block userId:(NSString *)userId rechargeId:(NSString *)rechargeId type:(NSInteger)tag{
    NSString *url = nil;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    if (tag == 0) {
        //充值记录
        url = RechargeDetails;
        [dic setValue:rechargeId forKey:@"rechargeId"];
    }else{
        //提现记录
        url = CashDetails;
        [dic setValue:rechargeId forKey:@"cashId"];
    }
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"提现/充值单条记录进度数据展示 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 用户本月部分回款记录
 */
+ (NSURLSessionDataTask *)postGetCollectListByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId queryMonth:(NSString *)queryMonth{
    NSString *url = GetCollectListAllByUserId;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:queryMonth forKey:@"queryMonth"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        NSArray *arr = dic1[@"lists"];
        NSMutableArray *mutaArr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PartIncomeModel *model = [[PartIncomeModel alloc] initWithDictionary:obj];
            [mutaArr addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:mutaArr forKey:@"SUCCESS"];
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 用户本月所有投资记录
 */
+ (NSURLSessionDataTask *)postGetInvestListByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId queryMonth:(NSString *)queryMonth{
    NSString *url = GetInvestListAllByUserId;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:queryMonth forKey:@"queryMonth"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        NSArray *arr = dic1[@"lists"];
        NSMutableArray *mutaArr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PartInvestModel *model = [[PartInvestModel alloc] initWithDictionary:obj];
            [mutaArr addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:mutaArr forKey:@"SUCCESS"];
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 用户本月所有回款记录
 */
+ (NSURLSessionDataTask *)postGetCollectListAllByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId queryMonth:(NSString *)queryMonth{
    NSString *url = GetCollectListAllByUserId;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:queryMonth forKey:@"queryMonth"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        NSArray *arr = dic1[@"lists"];
        NSMutableArray *mutaArr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PartIncomeModel *model = [[PartIncomeModel alloc] initWithDictionary:obj];
            [mutaArr addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:mutaArr forKey:@"SUCCESS"];
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 邀请好友首页
 */
+ (NSURLSessionDataTask *)postInviteFriendByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = InviteFriend;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"邀请好友首页 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}

/**
 奖励明细
 */
+ (NSURLSessionDataTask *)postGetRewardLists:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = GetRewardLists;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        NSArray *arr = dic1[@"lists"];
        NSMutableArray *mutaArr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AwardDetailsModel *model = [[AwardDetailsModel alloc] initWithDictionary:obj];
            [mutaArr addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:mutaArr forKey:@"SUCCESS"];
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 邀请人列表
 */
+ (NSURLSessionDataTask *)postGetInviteInfoLists:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = GetInviteInfoLists;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"邀请人列表 == %@", dic1);
        NSArray *arr = dic1[@"lists"];
        NSMutableArray *mutaArr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            InvitePersonModel *model = [[InvitePersonModel alloc] initWithDictionary:obj];
            [mutaArr addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:mutaArr forKey:@"SUCCESS"];
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 锁投有礼首页商品类型
 */
+ (NSURLSessionDataTask *)postGetGoodsTypeList:(void (^)(id obj, NSError *error))block{
    NSString *url = GetGoodsTypeList;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"锁投有礼首页商品类型 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 某个类目下的商品列表
 */
+ (NSURLSessionDataTask *)postGetGoodsTypeList:(void (^)(id obj, NSError *error))block pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize userId:(NSString *)userId typeId:(NSString *)typeId{
    NSString *url = GetGoodsListByType;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:pageNum forKey:@"pageNum"];
    [dic setValue:pageSize forKey:@"pageSize"];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:typeId forKey:@"typeId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        NSArray *arr = dic1[@"list"];
        NSDictionary *diction = dic1[@"paginator"];
        NSMutableArray *array = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            IphoneModel *model = [[IphoneModel alloc] initWithDictionary:obj];
            [array addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:array forKey:@"SUCCESS"];
        [dictionary setValue:diction forKey:@"SUCCESS1"];
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 某个类目下的商品所有列表
 */
+ (NSURLSessionDataTask *)postGetGoodsListAllByType:(void (^)(id obj, NSError *error))block userId:(NSString *)userId typeId:(NSString *)typeId{
    NSString *url = GetGoodsListAllByType;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:typeId forKey:@"typeId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        NSArray *arr = dic1[@"lists"];
        NSMutableArray *array = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            IphoneModel *model = [[IphoneModel alloc] initWithDictionary:obj];
            [array addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:array forKey:@"SUCCESS"];
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 单个商品点击进入详情页
 */
+ (NSURLSessionDataTask *)postGetGoodsDetails:(void (^)(id obj, NSError *error))block goodsId:(NSString *)goodsId{
    NSString *url = GetGoodsDetails;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:goodsId forKey:@"goodsId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"单个商品点击进入详情页 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 根据商品id查询期限种类
 */
+ (NSURLSessionDataTask *)postGetGoodsKinds:(void (^)(id obj, NSError *error))block goodsId:(NSString *)goodsId{
    NSString *url = GetGoodsKinds;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:goodsId forKey:@"goodsId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"根据商品id查询期限种类 == %@", dic1);
        NSArray *arr = dic1[@"lists"];
        NSMutableArray *mutaArr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GoodsKindsModel *model = [[GoodsKindsModel alloc] initWithDictionary:obj];
            [mutaArr addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:mutaArr forKey:@"SUCCESS"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 锁投有礼首页全部商品
 */
+ (NSURLSessionDataTask *)postGetAllGoods:(void (^)(id obj, NSError *error))block pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize{
    NSString *url = GetAllGoods;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"锁投有礼首页全部商品 %@", dic1);
        NSArray *arr = dic1[@"lists"];
        NSLog(@"%@", arr);
        NSMutableArray *goodsArr = [NSMutableArray array];
        NSMutableArray *typeArr = [NSMutableArray array];
        NSMutableArray *nameArr = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++) {
            NSArray *array = arr[i][@"goodsList"];
            NSLog(@"%@", array);
            NSMutableArray *muArr = [NSMutableArray array];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IphoneModel *model = [[IphoneModel alloc] initWithDictionary:obj];
                [muArr addObject:model];
            }];
            NSLog(@"%@", muArr);
            NSString *typeIcon = [NSString stringWithFormat:@"%@", arr[i][@"typeIcon"]];//商品类型背景图
            NSString *typeName = [NSString stringWithFormat:@"%@", arr[i][@"typeName"]];//商品名称
            NSLog(@"%@    %@", typeIcon, typeName);
            [typeArr addObject:typeIcon];
            [nameArr addObject:typeName];
            [goodsArr addObject:muArr];
        }
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:typeArr forKey:@"typeArr"];
        [dictionary setValue:nameArr forKey:@"nameArr"];
        [dictionary setValue:goodsArr forKey:@"goodsArr"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 库存及限购校验
 */
+ (NSURLSessionDataTask *)postCheckCountAndRemainder:(void (^)(id obj, NSError *error))block kindId:(NSString *)kindId num:(NSString *)num userId:(NSString *)userId{
    NSString *url = CheckCountAndRemainder;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:kindId forKey:@"kindId"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:userId forKey:@"userId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"库存及限购校验 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 商品详情的商品详情
 */
+ (NSURLSessionDataTask *)postGetGoodsDescription:(void (^)(id obj, NSError *error))block goodsId:(NSString *)goodsId{
    NSString *url = GetGoodsDescription;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:goodsId forKey:@"goodsId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"商品详情的商品详情 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 商品详情页立即投资
 */
+ (NSURLSessionDataTask *)postInvest:(void (^)(id obj, NSError *error))block kindId:(NSString *)kindId num:(NSString *)num userId:(NSString *)userId{
    NSString *url = Invest;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:kindId forKey:@"kindId"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 首页获取数据
 */
+ (NSURLSessionDataTask *)postIndex:(void (^)(id obj, NSError *error))block{
    NSString *url = HomeIndex;
    
    sharedClient = [Factory accessToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *response;
        // 取得http状态码
        NSLog(@"%ld",(long)[response statusCode]);
        
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        //首页轮播图数组
        NSArray *bannerArr = dic1[@"pictureList"];
        NSMutableArray *banner = [NSMutableArray array];
        if (bannerArr.count) {
            [bannerArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TopScrollPicture *model = [[TopScrollPicture alloc] initWithDictionary:obj];
                [banner addObject:model];
            }];
        }
        //注册人数及资金
        NSString *account = dic1[@"investAmount"];
        NSString *userNum = dic1[@"userNum"];
        NSLog(@"%@", dic1[@"newItem"]);
        NewItemModel *model = nil;
        if ([dic1[@"newItem"] isEqual:[NSNull null]]) {
            
        }else{
            //新手标
            model = [[NewItemModel alloc] initWithDictionary:dic1[@"newItem"]];
        }
        //首页列表
        NSArray *listArr = dic1[@"recommendItemList"];
        NSLog(@"%ld", listArr.count);
        NSMutableArray *listData = [NSMutableArray array];
        if (listArr.count < 1) {
            
        }else{
            [listArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ItemListModel *model = [[ItemListModel alloc] initWithDictionary:obj];
                [listData addObject:model];
            }];
        }
        //返回字典
        NSMutableDictionary *dictionaty = [NSMutableDictionary dictionary];
        //首页banner图
        [dictionaty setValue:banner forKey:@"banner"];
        [dictionaty setValue:account forKey:@"account"];
        [dictionaty setValue:userNum forKey:@"userNum"];
        [dictionaty setValue:model forKey:@"model"];
        [dictionaty setValue:listData forKey:@"list"];
        
        if (block) {
            
            block(dictionaty,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,error);
            
        }
        
        
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 理财列表
 */
+ (NSURLSessionDataTask *)postList:(void (^)(id obj, NSError *error))block pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize itemStatus:(NSString *)itemStatus itemType:(NSString *)itemType{
    NSString *url = MoneyList;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:pageNum forKey:@"pageNum"];
    [dic setValue:pageSize forKey:@"pageSize"];
    [dic setValue:itemStatus forKey:@"itemStatus"];
    [dic setValue:itemType forKey:@"itemType"];
    [dic setValue:[defaults objectForKey:@"userId"] forKey:@"userId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        NSArray *array = dic1[@"list"];
        NSDictionary *diction = dic1[@"paginator"];
        NSMutableArray *mutableArr = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MoneyListModel *model = [[MoneyListModel alloc] initWithDictionary:obj];
            [mutableArr addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:mutableArr forKey:@"SUCCESS"];
        [dictionary setValue:diction forKey:@"SUCCESS1"];
        NSLog(@"%@",dictionary);
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%ld", error.code);
        NSNotification *noti = [[NSNotification alloc] initWithName:@"stopRefresh" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 项目详情
 */
+ (NSURLSessionDataTask *)postItemDocuments:(void (^)(id obj, NSError *error))block  itemId:(NSString *)itemId{
    NSString *url = ItemDocuments;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:itemId forKey:@"itemId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@" 项目详情 == %@", dic1);
        NSDictionary *diction = dic1[@"item"];
        ItemDetailsModel *model = [[ItemDetailsModel alloc] initWithDictionary:diction];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:model forKey:@"model"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 登录状态的项目信息
 */
+ (NSURLSessionDataTask *)postInformation:(void (^)(id obj, NSError *error))block itemId:(NSString *)itemId userId:(NSString *)userId{
    NSString *url = Information;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:itemId forKey:@"itemId"];
    [dic setValue:userId forKey:@"userId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"登录状态的项目信息 == %@", dic1);
        NSDictionary *dictionItem = dic1[@"item"];
        NSDictionary *dictionInvest = dic1[@"account"];
        ItemDetailsModel *model = [[ItemDetailsModel alloc] initWithDictionary:dictionItem];
        InvestDetailsModel *investDetailsModel = nil;
        NSLog(@"%@", dictionInvest);
        if ([dictionInvest isEqual:@"<null>"]) {
            
        }else{
            investDetailsModel = [[InvestDetailsModel alloc] initWithDictionary:dictionInvest];
        }
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:model forKey:@"ItemDetailsModel"];
        [dictionary setValue:investDetailsModel forKey:@"InvestDetailsModel"];
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 投资
 */
+ (NSURLSessionDataTask *)postBuy:(void (^)(id obj, NSError *error))block amount:(NSString *)amount userId:(NSString *)userId couponId:(NSString *)couponId ticketId:(NSString *)ticketId investType:(NSString *)investType itemId:(NSString *)itemId paymentPassword:(NSString *)paymentPassword mcryptKey:(NSString *)mcryptKey{
    NSString *url = Buy;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:amount forKey:@"amount"];//金额
    [dic setValue:userId forKey:@"userId"];//用户ID
    [dic setValue:couponId forKey:@"couponId"];//红包ID
    [dic setValue:ticketId forKey:@"ticketId"];//加息劵id
    [dic setValue:@"7" forKey:@"investType"];//7 ios  8 安卓
    [dic setValue:itemId forKey:@"itemId"];//项目ID
    [dic setValue:paymentPassword forKey:@"paymentPassword"];//加密后的交易密码
    [dic setValue:mcryptKey forKey:@"mcryptKey"];//加密因子
    NSLog(@"%@",dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"投资 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 获取单个投资详情
 */
+ (NSURLSessionDataTask *)postGetInvestDetails:(void (^)(id obj, NSError *error))block investId:(NSString *)investId{
    NSString *url = GetInvestDetails;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:investId forKey:@"investId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"获取单个投资详情 == %@", dic1);
        BillInvestModel *model = [[BillInvestModel alloc] initWithDictionary:dic1];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:model forKey:@"Model"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 获取单个回款记录详情
 */
+ (NSURLSessionDataTask *)postGetCollectDetails:(void (^)(id obj, NSError *error))block collectId:(NSString *)collectId{
    NSString *url = GetCollectDetails;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:collectId forKey:@"collectId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"回款=%@",dic1);
        BillIncomeModel *model = [[BillIncomeModel alloc] initWithDictionary:dic1];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:model forKey:@"Model"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 付息表
 */
+ (NSURLSessionDataTask *)postGetCollectListByinvestId:(void (^)(id obj, NSError *error))block investId:(NSString *)investId{
    NSString *url = GetCollectListByinvestId;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:investId forKey:@"investId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@" 付息表 == %@", dic1);
        NSArray *arr = dic1[@"list"];
        NSMutableArray *dataArr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CollectListModel *model = [[CollectListModel alloc] initWithDictionary:obj];
            [dataArr addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:dataArr forKey:@"SUCCESS"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 查看合同
 */
+ (NSURLSessionDataTask *)postGetContracts:(void (^)(id obj, NSError *error))block investId:(NSString *)investId{
    NSString *url = GetContracts;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:investId forKey:@"investId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 活动图列表
 */
+ (NSURLSessionDataTask *)postActivityList:(void (^)(id obj, NSError *error))block{
    NSString *url = Activitylist;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"活动图列表 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 公告列表
 */
+ (NSURLSessionDataTask *)postGetNoticeList:(void (^)(id obj, NSError *error))block{
    NSString *url = GetNoticeList;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        NSArray *arr = dic1[@"noticeList"];
        NSMutableArray *mutaArr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NoticeLIstModel *modle = [[NoticeLIstModel alloc] initWithDictionary:obj];
            [mutaArr addObject:modle];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:mutaArr forKey:@"SUCCESS"];
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 公告动态
 */
+ (NSURLSessionDataTask *)postGetAnnouncementList:(void (^)(id obj, NSError *error))block pageSize:(NSString *)pageSize pageNum:(NSString *)pageNum{
    NSString *url = GetAnnouncementList;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:pageSize forKey:@"pageSize"];
    [dic setValue:pageNum forKey:@"pageNum"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        NSArray *arr = dic1[@"list"];
        NSDictionary *diction = dic1[@"paginator"];
        NSMutableArray *dataArr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NoticeTrendsModel *model = [[NoticeTrendsModel alloc] initWithDictionary:obj];
            [dataArr addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:dataArr forKey:@"SUCCESS"];
        [dictionary setValue:diction forKey:@"SUCCESS1"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 自动投标排名
 */
+ (NSURLSessionDataTask *)postGetRankByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = GetRankByUserId;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"自动投标排名dic1 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 自动投标累计在投
 */
+ (NSURLSessionDataTask *)postCountInvestingByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = CountInvestingByUserId;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"自动投标累计在投dic1 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 自动投标累计开启人数
 */
+ (NSURLSessionDataTask *)postCountUsePeople:(void (^)(id obj, NSError *error))block{
    NSString *url = CountUsePeople;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"自动投标累计开启人数dic1 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 自动投标统计余额
 */
+ (NSURLSessionDataTask *)postCountBalance:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = CountBalance;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"自动投标统计余额dic1 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 设置自动投标验证码
 */
+ (NSURLSessionDataTask *)postCountBalance:(void (^)(id obj, NSError *error))block userId:(NSString *)userId vaildPhoneCode:(NSString *)vaildPhoneCode{
    NSString *url = AutoSms;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:vaildPhoneCode forKey:@"vaildPhoneCode"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 添加自动投标
 */
+ (NSURLSessionDataTask *)postAutoInvestAdd:(void (^)(id obj, NSError *error))block itemUserId:(NSString *)itemUserId autoId:(NSString *)autoId itemStatus:(NSString *)itemStatus itemRateMin:(NSString *)itemRateMin itemRateMax:(NSString *)itemRateMax itemDayMin:(NSString *)itemDayMin itemDayMax:(NSString *)itemDayMax itemAmount:(NSString *)itemAmount password:(NSString *)password salt:(NSString *)salt type:(NSInteger)type itemType:(NSString *)itemType{
    NSString *url = @"";
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (type) {
        //添加自动投标
        url = Add;
    }else{
        //修改自动投标
        url = ModifyAuto;
        NSLog(@"%@", autoId);
        [dic setValue:autoId forKey:@"id"];
    }
    sharedClient = [Factory userToken];//token
    
    [dic setValue:itemUserId forKey:@"itemUserId"];
    [dic setValue:itemStatus forKey:@"itemStatus"];
    [dic setValue:itemRateMin forKey:@"itemRateMin"];
    [dic setValue:itemRateMax forKey:@"itemRateMax"];
    [dic setValue:itemDayMin forKey:@"itemDayMin"];
    [dic setValue:itemDayMax forKey:@"itemDayMax"];
    [dic setValue:password forKey:@"password"];
    [dic setValue:salt forKey:@"salt"];
    [dic setValue:itemAmount forKey:@"itemAmount"];
    [dic setValue:itemType forKey:@"itemType"];
    
    NSLog(@"%@", dic);
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@    %@   %ld", dic1, dic1[@"messageText"], type);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 获取二维码
 */
+ (NSURLSessionDataTask *)postGetUserQrCode:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = GetUserQrCode;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"获取二维码 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 用户免密投资授权与否校验
 */
+ (NSURLSessionDataTask *)postCheckAuthority:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = CheckAuthority;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 检查用户账户可提是否够订单金额
 */
+ (NSURLSessionDataTask *)postCheckAccountCash:(void (^)(id obj, NSError *error))block orderNo:(NSString *)orderNo{
    NSString *url = CheckAccountCash;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:orderNo forKey:@"orderNo"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 订单支付
 */
+ (NSURLSessionDataTask *)postOrderPay:(void (^)(id obj, NSError *error))block orderNo:(NSString *)orderNo address:(NSString *)address receiveName:(NSString *)receiveName receiveMobile:(NSString *)receiveMobile password:(NSString *)password salt:(NSString *)salt{
    NSString *url = OrderPay;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:orderNo forKey:@"orderNo"];
    [dic setValue:address forKey:@"address"];
    [dic setValue:receiveName forKey:@"receiveName"];
    [dic setValue:receiveMobile forKey:@"receiveMobile"];
    [dic setValue:password forKey:@"password"];
    [dic setValue:salt forKey:@"salt"];
    NSLog(@"%@", dic) ;
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 我的订单列表
 */
+ (NSURLSessionDataTask *)postGetMyOrderLists:(void (^)(id obj, NSError *error))block pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize status:(NSString *)status userId:(NSString *)userId{
    NSString *url = GetMyOrderLists;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:pageNum forKey:@"pageNum"];
    [dic setValue:pageSize forKey:@"pageSize"];
    [dic setValue:status forKey:@"status"];
    [dic setValue:userId forKey:@"userId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        NSArray *arr = dic1[@"list"];
        NSDictionary *diction = dic1[@"paginator"];
        NSMutableArray *dataArr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyOrderModel *model = [[MyOrderModel alloc] initWithDictionary:obj];
            [dataArr addObject:model];
        }];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:dataArr forKey:@"SUCCESS"];
        [dictionary setValue:diction forKey:@"SUCCESS1"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 统计未完成订单数量
 */
+ (NSURLSessionDataTask *)postCountUnCompleteOrder:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = CountUnCompleteOrder;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 获取用户名
 */
+ (NSURLSessionDataTask *)postGetUserName:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = GetUserName;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 用户查询收货地址
 */
+ (NSURLSessionDataTask *)postQueryAddressByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = QueryAddressByUserId;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        MyAddressModel *model = nil;
        if ([dic1[@"address"] isEqual:[NSNull null]]) {
            
        }else{
            model = [[MyAddressModel alloc] initWithDictionary:dic1[@"address"]];
        }
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:model forKey:@"model"];
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 (type 是0 用户添加收货地址)(type 是1 用户修改收货地址)
 */
+ (NSURLSessionDataTask *)postModifyAddress:(void (^)(id obj, NSError *error))block userId:(NSString *)userId mobile:(NSString *)mobile address:(NSString *)address userName:(NSString *)userName type:(NSInteger)type addressId:(NSString *)addressId{
    NSString *url = @"";
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (type) {
        //用户修改收货地址
        url = ModifyAddress;
        [dic setValue:addressId forKey:@"id"];
    }else{
        //用户添加收货地址
        url = AddAddress;
    }
    sharedClient = [Factory userToken];//token
    
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:mobile forKey:@"mobile"];
    [dic setValue:address forKey:@"address"];
    [dic setValue:userName forKey:@"userName"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        if (block) {
            
            block(dic1, nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 用户点击订单查看订单详情
 */
+ (NSURLSessionDataTask *)postGetOrderDetails:(void (^)(id obj, NSError *error))block orderNo:(NSString *)orderNo{
    NSString *url = GetOrderDetails;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:orderNo forKey:@"orderNo"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"用户点击订单查看订单详情dic1 == %@", dic1);
        OrderDetailsModel *model = [[OrderDetailsModel alloc] initWithDictionary:dic1];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:model forKey:@"model"];
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 取消订单
 */
+ (NSURLSessionDataTask *)postOrderCancel:(void (^)(id obj, NSError *error))block orderNo:(NSString *)orderNo{
    NSString *url = OrderCancel;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:orderNo forKey:@"orderNo"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 物流信息查询
 */
+ (NSURLSessionDataTask *)postQueryLogisticsByNo:(void (^)(id obj, NSError *error))block userId:(NSString *)userId logisticsNo:(NSString *)logisticsNo logisticsType:(NSString *)logisticsType{
    NSString *url = QueryLogisticsByNo;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:logisticsNo forKey:@"logisticsNo"];
    [dic setValue:logisticsType forKey:@"logisticsType"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        NSArray *array = dic1[@"ret"][@"datas"];
        NSMutableArray *dataArr = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LogisticsInfoModel *model = [[LogisticsInfoModel alloc] initWithDictionary:obj];
            [dataArr addObject:model];
        }];
        NSString *status = [NSString stringWithFormat:@"%@", dic1[@"ret"][@"status"]];
        if ([status isEqualToString:@"signed"]) {
            status = @"已签收";
        }else{
            status = @"运输中";
        }
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:dataArr forKey:@"SUCCESS"];
        [dictionary setValue:status forKey:@"status"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 用户授权
 */
+ (NSURLSessionDataTask *)postMobileAuthorization:(void (^)(id obj, NSError *error))block userId:(NSString *)userId grantList:(NSString *)grantList{
    NSString *url = MobileAuthorization;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:grantList forKey:@"grantList"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 获取消息列表
 */
+ (NSURLSessionDataTask *)postGetSiteMailList:(void (^)(id obj, NSError *error))block userId:(NSString *)userId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize type:(NSString *)type{
    NSString *url = GetSiteMailList;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:pageNum forKey:@"pageNum"];
    [dic setValue:pageSize forKey:@"pageSize"];
    [dic setValue:type forKey:@"type"];
    
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        
        NSArray *array = dic1[@"list"];
        NSDictionary *diction = dic1[@"paginator"];
        NSMutableArray *dataArr = [NSMutableArray array];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MessageModel *model = [[MessageModel alloc] initWithDictionary:obj];
            [dataArr addObject:model];
        }];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:dataArr forKey:@"SUCCESS"];
        [dictionary setValue:diction forKey:@"SUCCESS1"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 根据手机号码修改密码
 */
+ (NSURLSessionDataTask *)postModifyByPasswordByMobile:(void (^)(id obj, NSError *error))block mobile:(NSString *)mobile password:(NSString *)password{
    NSString *url = ModifyByPasswordByMobile;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:mobile forKey:@"mobile"];
    [dic setValue:password forKey:@"password"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 实名认证
 */
+ (NSURLSessionDataTask *)postUserRealName:(void (^)(id obj, NSError *error))block userId:(NSString *)userId bizType:(NSString *)bizType{
    NSString *url = RealName;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:bizType forKey:@"bizType"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 点击单条消息（读消息）
 */
+ (NSURLSessionDataTask *)postReadSiteMail:(void (^)(id obj, NSError *error))block siteMailId:(NSString *)siteMailId{
    NSString *url = ReadSiteMail;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:siteMailId forKey:@"siteMailId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 全部已读
 */
+ (NSURLSessionDataTask *)postReadAllSiteMail:(void (^)(id obj, NSError *error))block{
    NSString *url = ReadAllMail;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[defaults objectForKey:@"userId"] forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}

/**
 投资返回查询投资状态
 */
+ (NSURLSessionDataTask *)postGetInvestResult:(void (^)(id obj, NSError *error))block orderId:(NSString *)orderId{
    NSString *url = GetInvestResult;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:orderId forKey:@"orderId"];
    NSLog(@"%@", orderId);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 自动投标记录
 */
+ (NSURLSessionDataTask *)postGetLists:(void (^)(id obj, NSError *error))block pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize userId:(NSString *)userId investType:(NSString *)investType queryMonth:(NSString *)queryMonth{
    NSString *url = GetLists;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:pageNum forKey:@"pageNum"];//分页参数
    [dic setValue:pageSize forKey:@"pageSize"];//分页参数
    [dic setValue:userId forKey:@"userId"];//用户ID
    [dic setValue:investType forKey:@"investType"];//(自动投标10，锁定9)
    [dic setValue:queryMonth forKey:@"queryMonth"];//查询日期，格式yyyy年MM月
    NSLog(@"自动投标记录 %@     %@", dic, dic[@"queryMonth"]);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        NSArray *array = dic1[@"list"];
        NSDictionary *diction = dic1[@"paginator"];
        NSMutableArray *dataSource = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AutoBidRecodeModel *model = [[AutoBidRecodeModel alloc] initWithDictionary:obj];
            [dataSource addObject:model];
        }];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:diction forKey:@"SUCCESS1"];
        [dictionary setValue:dataSource forKey:@"SUCCESS"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 根据itemId获得风险评估模板
 */
+ (NSURLSessionDataTask *)postGetRiskTemplet:(void (^)(id obj, NSError *error))block itemId:(NSString *)itemId{
    NSString *url = GetRiskTemplet;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:itemId forKey:@"itemId"];//
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 查看存管账户
 */
+ (NSURLSessionDataTask *)postMobileAccountInfoManage:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = MobileAccountInfoManage;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];//分页参数
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 会员首页
 */
+ (NSURLSessionDataTask *)postGetGradeAndIntegral:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = GetGradeAndIntegral;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];//分页参数
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 会员权益模块
 */
+ (NSURLSessionDataTask *)postGetPrivileges:(void (^)(id obj, NSError *error))block{
    NSString *url = GetPrivileges;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"会员权益模块 dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 根据会员等级和权益id查询会员可享受权益
 */
+ (NSURLSessionDataTask *)postGetConfigByIdAndGrade:(void (^)(id obj, NSError *error))block privilegeId:(NSString *)privilegeId grade:(NSString *)grade{
    NSString *url = GetConfigByIdAndGrade;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:privilegeId forKey:@"privilegeId"];//ID
    [dic setValue:grade forKey:@"grade"];//会员等级
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"根据会员等级和权益id查询会员可享受权益 dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 根据会员等级查询该等级可享权益列表
 */
+ (NSURLSessionDataTask *)postGetConfigsByGrade:(void (^)(id obj, NSError *error))block grade:(NSString *)grade{
    NSString *url = GetConfigsByGrade;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:grade forKey:@"grade"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"根据会员等级查询该等级可享权益列表 dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 查询单个权益模块不同会员等级可享权益
 */
+ (NSURLSessionDataTask *)postGetConfigById:(void (^)(id obj, NSError *error))block privilegeId:(NSString *)privilegeId{
    NSString *url = GetConfigById;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:privilegeId forKey:@"privilegeId"];//ID
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"查询单个权益模块不同会员等级可享权益 dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 不同等级需要年化门槛
 */
+ (NSURLSessionDataTask *)postGetMemberGrade:(void (^)(id obj, NSError *error))block{
    NSString *url = GetMemberGrade;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"不同等级需要年化门槛  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 用户积分记录
 */
+ (NSURLSessionDataTask *)postGetIntegralLogs:(void (^)(id obj, NSError *error))block userId:(NSString *)userId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize{
    NSString *url = GetIntegralLogs;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:pageNum forKey:@"pageNum"];
    [dic setValue:pageSize forKey:@"pageSize"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"用户积分记录  dic1 == %@", dic1);
        NSArray *array = dic1[@"list"];
        NSDictionary *diction = dic1[@"paginator"];
        NSMutableArray *mutableArr = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            IntergralModel *model = [[IntergralModel alloc] initWithDictionary:obj];
            //该记录是否展示给用户：1展示，0不展示
            NSInteger isDelete = model.isDelete.integerValue;
            if (isDelete) {
                [mutableArr addObject:model];
            }
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:mutableArr forKey:@"SUCCESS"];
        [dictionary setValue:diction forKey:@"SUCCESS1"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 根据用户id和任务类型查询任务列表
 */
+ (NSURLSessionDataTask *)postGetMissions:(void (^)(id obj, NSError *error))block userId:(NSString *)userId type:(NSString *)type{
    NSString *url = GetMissions;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:type forKey:@"type"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"根据用户id和任务类型查询任务列表  dic1 == %@", dic1);
        NSArray *array = dic1[@"lists"];
        NSMutableArray *mutableArr = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MoreStrategyModel *model = [[MoreStrategyModel alloc] initWithDictionary:obj];
            //该记录是否展示给用户：1展示，0不展示
            NSInteger isDelete = model.isDelete.integerValue;
            if (isDelete) {
                [mutableArr addObject:model];
            }
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:mutableArr forKey:@"SUCCESS"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 会员中心推荐任务列表
 */
+ (NSURLSessionDataTask *)postGetRecommendMission:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = GetRecommendMission;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"会员中心推荐任务列表  dic1 == %@", dic1);
        NSArray *array = dic1[@"lists"];
        NSMutableArray *mutableArr = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MoreStrategyModel *model = [[MoreStrategyModel alloc] initWithDictionary:obj];
            //该记录是否展示给用户：1展示，0不展示
            NSInteger isDelete = model.isDelete.integerValue;
            if (isDelete) {
                [mutableArr addObject:model];
            }
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:mutableArr forKey:@"SUCCESS"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 理财计划列表
 */
+ (NSURLSessionDataTask *)postGetWalletLists:(void (^)(id obj, NSError *error))block isDelete:(NSString *)isDelete{
    NSString *url = GetWalletLists;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"0" forKey:@"isDelete"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"理财计划列表  dic1 == %@", dic1);
        NSArray *array = dic1[@"lists"];
        NSMutableArray *dataArr = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PlanModel *model = [[PlanModel alloc] initWithDictionary:obj];
            [dataArr addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:dataArr forKey:@"SUCCESS"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 我的计划规则统计
 */
+ (NSURLSessionDataTask *)postCountPlans:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = CountPlans;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"我的计划规则统计  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 计划中我的规则列表
 */
+ (NSURLSessionDataTask *)postMyPlans:(void (^)(id obj, NSError *error))block userId:(NSString *)userId isDelete:(NSString *)isDelete{
    NSString *url = MyPlans;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:isDelete forKey:@"isDelete"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"计划中我的规则列表  dic1 == %@", dic1);
        NSMutableArray *threeArr = [NSMutableArray array];
        NSMutableArray *sixArr = [NSMutableArray array];
        NSMutableArray *yearArr = [NSMutableArray array];
        NSArray *three_month = dic1[@"ret"][@"three_month"];
        NSArray *six_month = dic1[@"ret"][@"six_month"];
        NSArray *twelve_month = dic1[@"ret"][@"twelve_month"];
        [three_month enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyPlanModel *model = [[MyPlanModel alloc] initWithDictionary:obj];
            [threeArr addObject:model];
        }];
        [six_month enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyPlanModel *model = [[MyPlanModel alloc] initWithDictionary:obj];
            [sixArr addObject:model];
        }];
        [twelve_month enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MyPlanModel *model = [[MyPlanModel alloc] initWithDictionary:obj];
            [yearArr addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:threeArr forKey:@"threeArr"];
        [dictionary setValue:sixArr forKey:@"sixArr"];
        [dictionary setValue:yearArr forKey:@"yearArr"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 查询单个理财计划内容
 */
+ (NSURLSessionDataTask *)postGetOneById:(void (^)(id obj, NSError *error))block planId:(NSString *)planId{
    NSString *url = GetOneById;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:planId forKey:@"planId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"查询单个理财计划内容  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 实名前查询老用户实名信息
 */
+ (NSURLSessionDataTask *)postRealNameInformation:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = RealNameInformation;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"实名前查询老用户实名信息  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 *  实名认证
 */
+ (NSURLSessionDataTask *)postMakeRealName:(void (^) (id obj, NSError *error))block userId:(NSString *)userId realName:(NSString *)realname identifyCard:(NSString *)identifyCard paymentPassword:(NSString *)paymentPassword mcryptKey:(NSString *)mcryptKey{
    NSString *url = RealName;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:realname forKey:@"realname"];
    [dic setValue:identifyCard forKey:@"identifyCard"];
    [dic setValue:paymentPassword forKey:@"paymentPassword"];
    [dic setValue:mcryptKey forKey:@"mcryptKey"];
    
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"实名认证  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 生成随机因子
 */
+ (NSURLSessionDataTask *)postGetSrandNum:(void (^)(id obj, NSError *error))block{
    NSString *url = GetSrandNum;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"生成随机因子  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"生成随机因子  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 根据卡号查询归属地和联行号(绑卡用)
 */
+ (NSURLSessionDataTask *)postQueryBankLocation:(void (^)(id obj, NSError *error))block cardNo:(NSString *)cardNo{
    NSString *url = QueryBankLocation;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:cardNo forKey:@"cardNo"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"根据卡号查询归属地和联行号(绑卡用)  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 绑卡验证码申请
 */
+ (NSURLSessionDataTask *)postAddBankSmsSend:(void (^)(id obj, NSError *error))block userId:(NSString *)userId telephone:(NSString *)telephone{
    NSString *url = AddBankSmsSend;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:telephone forKey:@"telephone"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"绑卡验证码申请  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 绑卡
 */
+ (NSURLSessionDataTask *)postAddBank:(void (^)(id obj, NSError *error))block cardNo:(NSString *)cardNo bankCode:(NSString *)bankCode bankName:(NSString *)bankName mobile:(NSString *)mobile subBranch:(NSString *)subBranch subBankCode:(NSString *)subBankCode userId:(NSString *)userId msgBox:(NSString *)msgBox{
    NSString *url = AddBank;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:cardNo forKey:@"cardNo"];
    [dic setValue:bankCode forKey:@"bankCode"];
    [dic setValue:bankName forKey:@"bankName"];
    [dic setValue:mobile forKey:@"mobile"];
    [dic setValue:subBranch forKey:@"subBranch"];
    [dic setValue:subBankCode forKey:@"subBankCode"];
    [dic setValue:msgBox forKey:@"msgBox"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"绑卡  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 查询锁投规则投资记录
 */
+ (NSURLSessionDataTask *)postGetListByAutoId:(void (^)(id obj, NSError *error))block autoId:(NSString *)autoId{
    NSString *url = GetListByAutoId;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:autoId forKey:@"autoId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"查询锁投规则投资记录  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 查询用户是否绑卡
 */
+ (NSURLSessionDataTask *)postGetBankByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = GetBankByUserId;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"查询用户是否绑卡  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 用户银行卡列表
 */
+ (NSURLSessionDataTask *)postGetListByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = GetListByUserId;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic1[@"list"];
        NSMutableArray *dataSource = [NSMutableArray  array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BankListModel *model = [[BankListModel alloc] initWithDictionary:obj];
            [dataSource addObject:model];
        }];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:dataSource forKey:@"SUCCESS"];
        NSLog(@"用户银行卡列表  dic1 == %@", dic1);
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 银行卡解绑
 */
+ (NSURLSessionDataTask *)postUnbindCard:(void (^)(id obj, NSError *error))block userId:(NSString *)userId bankId:(NSString *)bankId password:(NSString *)password mcryptKey:(NSString *)mcryptKey{
    NSString *url = UnbindCard;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:bankId forKey:@"bankId"];
    [dic setValue:password forKey:@"password"];
    [dic setValue:mcryptKey forKey:@"mcryptKey"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"银行卡解绑  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 锁投全部滚动图
 */
+ (NSURLSessionDataTask *)postGetLockAutoPicture:(void (^)(id obj, NSError *error))block{
    NSString *url = GetLockAutoPicture;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array = dic1[@"lists"];
        NSMutableArray *dataSource = [NSMutableArray array];
        if (array.count) {
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ShopBannerModel *model = [[ShopBannerModel alloc] initWithDictionary:obj];
                [dataSource addObject:model];
            }];
        }
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:dataSource forKey:@"SUCCESS"];
        NSLog(@"锁投全部滚动图  dic1 == %@", dic1);
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 推荐商品列表
 */
+ (NSURLSessionDataTask *)postGetRecommendGoods:(void (^)(id obj, NSError *error))block{
    NSString *url = GetRecommendGoods;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic1[@"lists"];
        NSMutableArray *dataSource = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RecommendModel *model = [[RecommendModel alloc] initWithDictionary:obj];
            [dataSource addObject:model];
        }];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:dataSource forKey:@"SUCCESS"];
        
        NSLog(@"推荐商品列表  dic1 == %@", dic1);
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 兑吧免登陆接口
 */
+ (NSURLSessionDataTask *)postLogFreeUrl:(void (^)(id obj, NSError *error))block userId:(NSString *)userId redicrect:(NSString *)redicrect{
    NSString *url = LogFreeUrl;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:redicrect forKey:@"redicrect"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"兑吧免登陆接口  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 修改交易密码短信验证码申请
 */
+ (NSURLSessionDataTask *)postApplySMSforChangePassword:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = ApplySMSforChangePassword;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"修改交易密码短信验证码申请  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 修改交易密码
 */
+ (NSURLSessionDataTask *)postChangePasswordWithoutOld:(void (^)(id obj, NSError *error))block msgBox:(NSString *)msgBox newPs:(NSString *)newPs userId:(NSString *)userId factor:(NSString *)factor cardNo:(NSString *)cardNo name:(NSString *)name{
    NSString *url = ChangePasswordWithoutOld;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:msgBox forKey:@"msgBox"];
    [dic setValue:newPs forKey:@"newPs"];
    [dic setValue:factor forKey:@"factor"];
    [dic setValue:cardNo forKey:@"cardNo"];
    [dic setValue:name forKey:@"name"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"修改交易密码  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 用户购买理财计划
 */
+ (NSURLSessionDataTask *)postBuyPlan:(void (^)(id obj, NSError *error))block userId:(NSString *)userId planId:(NSString *)planId amount:(NSString *)amount password:(NSString *)password salt:(NSString *)salt{
    NSString *url = BuyPlan;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:planId forKey:@"planId"];
    [dic setValue:amount forKey:@"amount"];
    [dic setValue:password forKey:@"password"];
    [dic setValue:salt forKey:@"salt"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"用户购买理财计划  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 常用短信验证码接口
 */
+ (NSURLSessionDataTask *)postCommonSms:(void (^)(id obj, NSError *error))block userId:(NSString *)userId vaildPhoneCode:(NSString *)vaildPhoneCode{
    NSString *url = CommonSms;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:vaildPhoneCode forKey:@"vaildPhoneCode"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"常用短信验证码接口  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 自动投标关闭
 */
+ (NSURLSessionDataTask *)postUpdateStatus:(void (^)(id obj, NSError *error))block autoId:(NSString *)autoId newStatus:(NSString *)newStatus oldStatus:(NSString *)oldStatus{
    NSString *url = UpdateStatus;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:autoId forKey:@"autoId"];
    [dic setValue:newStatus forKey:@"newStatus"];
    [dic setValue:oldStatus forKey:@"oldStatus"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"自动投标关闭  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 老用户验证身份证和姓名
 */
+ (NSURLSessionDataTask *)postOldUserCheck:(void (^)(id obj, NSError *error))block userId:(NSString *)userId realname:(NSString *)realname identifyCard:(NSString *)identifyCard{
    NSString *url = OldUserCheck;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:realname forKey:@"realname"];
    [dic setValue:identifyCard forKey:@"identifyCard"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"老用户验证身份证和姓名  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSURL *url = [NSURL URLWithString:@"http://www.test.com"];
//        NSURLRequest *request = [NSURLRequest requestWithURL: url];
//        NSHTTPURLResponse *response;
//        [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: nil];
//        if ([response respondsToSelector:@selector(allHeaderFields)]) {
//            // 取得所有的请求的头
//            NSDictionary *dictionary = [response allHeaderFields];
//            NSLog([dictionary description]);
//            // 取得http状态码
//            NSLog(@"%d",[response statusCode]);
//            
//        }
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}

/**
 获取商品类目icon
 */
+ (NSURLSessionDataTask *)postGetTypeIcon:(void (^)(id obj, NSError *error))block typeId:(NSString *)typeId{
    NSString *url = GetTypeIcon;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:typeId forKey:@"typeId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"获取商品类目icon  dic1 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 自动填入金额查询
 */
+ (NSURLSessionDataTask *)postAutoFill:(void (^)(id obj, NSError *error))block userId:(NSString *)userId itemId:(NSString *)itemId{
    NSString *url = AutoFill;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:itemId forKey:@"itemId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"自动填入金额查询 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 会员首页弹屏
 */
+ (NSURLSessionDataTask *)postGetMemberPicture:(void (^)(id obj, NSError *error))block picName:(NSString *)picName{
    NSString *url = GetMemberPicture;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:picName forKey:@"picName"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"会员首页弹屏 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 签到
 */
+ (NSURLSessionDataTask *)postGetMemberPicture:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = SignIn;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"签到 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 预约标接口
 */
+ (NSURLSessionDataTask *)postAppointBid:(void (^)(id obj, NSError *error))block userId:(NSString *)userId itemId:(NSString *)itemId{
    NSString *url = @"/mobile/appointBid";
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:itemId forKey:@"itemId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"预约 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 获取投资广告图
 */
+ (NSURLSessionDataTask *)postInvestEndPic:(void (^)(id obj, NSError *error))block investId:(NSString *)investId{
    NSString *url = @"/mobile/invest/getInvestEndPic";
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[HCJFNSUser stringForKey:@"userId"] forKey:@"userId"];
    [dic setValue:investId forKey:@"investId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"广告图 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 积分商城推荐商品
 */
+ (NSURLSessionDataTask *)postVipRegister:(void (^)(id obj, NSError *error))block isDelete:(NSString *)isDelete isRecommend:(NSString *)isRecommend pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize{
    NSString *url = VipRegister;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:isDelete forKey:@"isDelete"];
    [dic setValue:isRecommend forKey:@"isRecommend"];
    [dic setValue:pageNum forKey:@"pageNum"];
    [dic setValue:pageSize forKey:@"pageSize"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dic1[@"list"];
        NSMutableArray *dataSource = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GoodsRecomondModel *model = [[GoodsRecomondModel alloc] initWithDictionary:obj];
            [dataSource addObject:model];
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:dataSource forKey:@"SUCCESS"];
        
        NSLog(@"积分商城推荐商品 == %@", dic1);
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 查询交易密码是否设置接口
 */
+ (NSURLSessionDataTask *)postCheckTradingPs:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = CheckTradingPs;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"查询交易密码是否设置接口 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 首次设置交易密码接口
 */
+ (NSURLSessionDataTask *)postSetPaymentPs:(void (^)(id obj, NSError *error))block userId:(NSString *)userId factor:(NSString *)factor password:(NSString *)password;{
    NSString *url = SetPaymentPs;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:factor forKey:@"factor"];
    [dic setValue:password forKey:@"password"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"首次设置交易密码接口 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 版本更新
 */
+ (NSURLSessionDataTask *)postAppVersionUpdate:(void (^)(id obj, NSError *error))block {
    NSString *url = AppVersion;
    sharedClient = [Factory accessToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"版本号 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 获取当月日历
 */
+ (NSURLSessionDataTask *)postCalendar:(void (^)(id obj, NSError *error))block userId:(NSString *)userId dateStr:(NSString *)dateStr{
    NSString *url = Calendar;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:dateStr forKey:@"dateStr"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"获取当月日历 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"  数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 获取当日投资和回款记录   需要查看的日期 （格式为yyyy-MM-dd)
 */
+ (NSURLSessionDataTask *)postCalendarList:(void (^)(id obj, NSError *error))block userId:(NSString *)userId viewDate:(NSString *)viewDate{
    NSString *url = CalendarList;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:viewDate forKey:@"viewDate"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"获取当日投资和回款记录 == %@", dic1);
        //当日投资总额
        NSString *investTotal = [NSString stringWithFormat:@"%@", dic1[@"investTotal"]];
        //当日回款总额
        NSString *repayTotal = [NSString stringWithFormat:@"%@", dic1[@"repayTotal"]];
        //当日投资回款列表
        NSArray *array = dic1[@"list"];
        //创建一个可以盛放 对象的可变数组
        NSMutableArray *dataSource = [NSMutableArray array];
        //遍历当日投资回款列表
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CalendarListModel *model = [[CalendarListModel alloc] initWithDictionary:obj];
            
            [dataSource addObject:model];
        }];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        [dictionary setValue:investTotal forKey:@"investTotal"];
        [dictionary setValue:repayTotal forKey:@"repayTotal"];
        [dictionary setValue:dataSource forKey:@"dataSource"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [Factory showNoDataHud];
    }];
}
/**
 支付公司类型
 */
+ (NSURLSessionDataTask *)postGetSupportBankLimit:(void (^)(id obj, NSError *error))block bankId:(NSString *)bankId{
    NSString *url = GetSupportBankLimit;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:bankId forKey:@"bankId"];
    NSLog(@"%@", dic);
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array = dic1[@"list"];
        
        NSMutableArray *dataSource = [NSMutableArray array];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TopUpModel *model = [[TopUpModel alloc] initWithDictionary:obj];
            
            [dataSource addObject:model];
        }];
        
        NSLog(@"支付公司类型 == %@", dic1);
        
        if (block) {
            
            block(dataSource,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [Factory showNoDataHud];
    }];
}
/**
 获取Tabbar icon
 */
+ (NSURLSessionDataTask *)postGetBottonIcon:(void (^)(id obj, NSError *error))block{
    NSString *url = GetBottonIcon;
    
    sharedClient = [Factory accessToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"  数据请求失败");
//        [Factory showNoDataHud];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getIcon" object:nil];
    }];
}
/**
 开户数字
 */
+ (NSURLSessionDataTask *)postCountNoviceWelfare:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = CountNoviceWelfare;
    
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"开户数字 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"  数据请求失败");
//        [Factory showNoDataHud];
    }];
}
/**
 福利红点
 */
+ (NSURLSessionDataTask *)postHasCanUseReward:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = HasCanUseReward;
    
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"福利红点 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"  数据请求失败");
//        [Factory showNoDataHud];
    }];
}
/**
 个人中心弹屏
 */
+ (NSURLSessionDataTask *)postGetNoviceWelfare:(void (^)(id obj, NSError *error))block clientId:(NSString *)clientId{
    NSString *url = GetNoviceWelfare;
    
    sharedClient = [Factory accessToken];//token
    
    NSLog(@"%@", clientId);
    
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (clientId == nil) {
        
    }else{
        [dic setValue:clientId forKey:@"clientId"];
    }
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"个人中心弹屏 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"  数据请求失败");
//        [Factory showNoDataHud];
    }];
}
/**
  福利中心 阅读消息
  */
+ (NSURLSessionDataTask *)postReadReward:(void (^)(id obj, NSError *error))block userId:(NSString *)userId key:(NSString *)key{
    NSString *url = ReadReward;
    
    sharedClient = [Factory accessToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:key forKey:@"key"];
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"福利中心 阅读消息 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"  数据请求失败");
//        [Factory showNoDataHud];
    }];
}
/**
 我的账单
 */
+ (NSURLSessionDataTask *)postGetAccountLog:(void (^)(id obj, NSError *error))block userId:(NSString *)userId queryMonth:(NSString *)queryMonth type:(NSString *)type{
    NSString *url = GetAccountLog;
    
    sharedClient = [Factory accessToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:queryMonth forKey:@"queryMonth"];
    [dic setValue:type forKey:@"type"];
    
    NSLog(@"%@    %@", dic, queryMonth);
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array = dic1[@"lists"];
        
        NSMutableArray *dataSource = [NSMutableArray array];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NewMyBillModel *model = [[NewMyBillModel alloc] initWithDictionary:obj];
            
            [dataSource addObject:model];
            
        }];
        
        NSLog(@"我的账单 == %@", dic1);
        
        if (block) {
            
            block(dataSource,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"  数据请求失败");
        //        [Factory showNoDataHud];
    }];
}
/**
 用户分享完成  //isBanner 1为banner分享，0为投资后分享
 */
+ (void)postShare:(void (^)(id obj, NSError *error))block userId:(NSString *)userId isBanner:(NSString *)isBanner{
    
    sharedClient = [Factory accessToken];//token
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:isBanner forKey:@"isBanner"];
    
    [sharedClient POST:@"http://activity.hcjinfu.com/activity/share/share" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"用户分享完成");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
//    //参数
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:userId forKey:@"userId"];
//    [dic setObject:isBanner forKey:@"isBanner"];
//
//    //结果返回
//    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSData *data = (NSData *)responseObject;
//        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        
//        NSLog(@"用户分享完成 == %@", dic1);
//        
//        if (block) {
//            
//            block(dic1,nil);
//            
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //        NSLog(@"  数据请求失败");
//        //        [Factory showNoDataHud];
//    }];
}
/**
 用户实时获取版本号
 */
+ (NSURLSessionDataTask *)postUpdateVersion:(void (^)(id obj, NSError *error))block{
    NSString *url = UpdateVersion;
    
    sharedClient = [Factory accessToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[HCJFNSUser stringForKey:@"userId"] forKey:@"userId"];
    if ([HCJFNSUser stringForKey:@"clientId"] == nil) {
        
    }else{
        [dic setValue:[HCJFNSUser stringForKey:@"clientId"] forKey:@"clientId"];
    }
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    [dic setValue:currentVersion forKey:@"version"];
    
    NSLog(@"%@", dic);
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"用户实时获取版本号 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"  数据请求失败");
        //        [Factory showNoDataHud];
    }];
}
/**
 首页TouchButton图片
 */
+ (NSURLSessionDataTask *)postGetFloatingPicture:(void (^)(id obj, NSError *error))block{
    NSString *url = GetFloatingPicture;
    
    sharedClient = [Factory accessToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSLog(@"%@", dic);
    
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"首页TouchButton图片 == %@", dic1);
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"  数据请求失败");
        //        [Factory showNoDataHud];
    }];
}
/**
 邀请好友中的奖励列表
 */
+ (NSURLSessionDataTask *)postGetNewRewardLists:(void (^)(id obj, NSError *error))block userId:(NSString *)userId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize{
    NSString *url = GetNewRewardLists;

    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:pageNum forKey:@"pageNum"];
    [dic setValue:pageSize forKey:@"pageSize"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"邀请好友中的奖励列表 == %@", dic1);
        
        NSDictionary *diction1 = dic1[@"lists"];
        
        NSArray *array = diction1[@"list"];
        NSDictionary *diction = diction1[@"paginator"];
        NSMutableArray *mutableArr = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AwardDetailsModel *model = [[AwardDetailsModel alloc] initWithDictionary:obj];
            //该记录是否展示给用户：1展示，0不展示
            //NSInteger isDelete = model.isDelete.integerValue;
            //if (isDelete) {
            [mutableArr addObject:model];
            //}
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:mutableArr forKey:@"SUCCESS"];
        [dictionary setValue:diction forKey:@"SUCCESS1"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 邀请好友中的邀请人数列表
 */
+ (NSURLSessionDataTask *)postGetPageInviteInfoLists:(void (^)(id obj, NSError *error))block userId:(NSString *)userId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize{
    NSString *url = GetPageInviteInfoLists;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:pageNum forKey:@"pageNum"];
    [dic setValue:pageSize forKey:@"pageSize"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"邀请好友中的邀请人数列表 == %@", dic1);
        
        NSDictionary *diction1 = dic1[@"lists"];
        
        NSArray *array = diction1[@"list"];
        NSDictionary *diction = diction1[@"paginator"];
        NSMutableArray *mutableArr = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            InvitePersonModel *model = [[InvitePersonModel alloc] initWithDictionary:obj];
            //该记录是否展示给用户：1展示，0不展示
            //NSInteger isDelete = model.isDelete.integerValue;
            //if (isDelete) {
                [mutableArr addObject:model];
            //}
        }];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:mutableArr forKey:@"SUCCESS"];
        [dictionary setValue:diction forKey:@"SUCCESS1"];
        
        if (block) {
            
            block(dictionary,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 邀请好友中的图片
 */
+ (NSURLSessionDataTask *)postGetInvitePagePic:(void (^)(id obj, NSError *error))block{
    NSString *url = GetInvitePagePic;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"邀请好友中的图片 == %@", dic1);
        
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 大额充值中的开户姓名 开户银行 银行商户的接口
 */
+ (NSURLSessionDataTask *)postBigAmountRechargeData:(void (^)(id obj, NSError *error))block{
    NSString *url = BigAmountRechargeData;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"大额充值中的开户姓名 开户银行 银行商户的接口 == %@", dic1);
        
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 人脸识别
 */
+ (NSURLSessionDataTask *)postFaceAuthent:(void (^)(id obj, NSError *error))block userId:(NSString *)userId{
    NSString *url = FaceAuthent;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"人脸识别 == %@", dic1);
        
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 人脸识别 人脸识别后调用的接口 （Integer userId,Integer isSuccess（1是成功，0是失败））
 */
+ (NSURLSessionDataTask *)postDoFaceAuthent:(void (^)(id obj, NSError *error))block userId:(NSString *)userId isSuccess:(NSString *)isSuccess{
    NSString *url = DoFaceAuthent;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:isSuccess forKey:@"isSuccess"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"人脸识别后调用 == %@", dic1);
        
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
/**
 人脸识别失败后 人工审核接口 (Integer userId,String imgUrl（图片url）)
 */
+ (NSURLSessionDataTask *)postManualCheck:(void (^)(id obj, NSError *error))block userId:(NSString *)userId imgUrl:(NSString *)imgUrl{
    NSString *url = ManualCheck;
    sharedClient = [Factory userToken];//token
    //参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:userId forKey:@"userId"];
    [dic setValue:imgUrl forKey:@"imgUrl"];
    //结果返回
    return [sharedClient POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"人脸识别失败后 人工审核接口  == %@", dic1);
        
        
        if (block) {
            
            block(dic1,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据请求失败");
        [Factory showNoDataHud];
    }];
}
@end









