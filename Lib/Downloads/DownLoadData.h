//
//  DownLoadData.h
//  007AFN的使用
//
//  Created by 黎跃春 on 15/5/18.
//  Copyright (c) 2015年 黎跃春. All rights reserved.
//



#import <Foundation/Foundation.h>
#define Request_Type @"RequestType"

@interface DownLoadData : NSObject

/**
 token
 */
+ (NSURLSessionDataTask *)postappToken:(void (^) (id obj, NSError *error))block andMykey:(NSString *)myKey andUUID:(NSString *)uuid;
/**
 *  验证码
 */
+ (NSURLSessionDataTask *)postVaildPhoneCode:(void (^) (id obj, NSError *error))block andvaildPhoneCode:(NSString *)phoneCode andmobile:(NSString *)mobile andtag:(NSInteger)tag stat:(NSString *)stat;
/**
 *  注册
 */
+ (NSURLSessionDataTask *)postRegister:(void (^) (id obj, NSError *error))block andmobile:(NSString *)mobile andpassword:(NSString *)password andinputCode:(NSString *)inputCode andjsCode:(NSString *)jsCode andvalidPhoneExpiredTime:(NSString *)validTime openId:(NSString *)openId type:(NSString *)type andidfa:(NSString *)idfa;
/**
 *  注册
 */
+ (NSURLSessionDataTask *)postRegister:(void (^) (id obj, NSError *error))block andmobile:(NSString *)mobile andpassword:(NSString *)password andinputCode:(NSString *)inputCode andjsCode:(NSString *)jsCode andvalidPhoneExpiredTime:(NSString *)validTime openId:(NSString *)openId type:(NSString *)type andidfa:(NSString *)idfa version:(NSString *)version invitePerson:(NSString *)invitePerson;
/**
 *  注册-密码选填
 */
+ (NSURLSessionDataTask *)postRegisterSecond:(void (^) (id obj, NSError *error))block andmobile:(NSString *)mobile andpassword:(NSString *)password;
/**
 *  登录
 */
+ (NSURLSessionDataTask *)postWetherSign:(void (^) (id obj, NSError *error))block andusername:(NSString *)username andpassword:(NSString *)password andclientId:(NSString *)clientId;
/**
 *  快捷登录
 */
+ (NSURLSessionDataTask *)postQuickSign:(void (^) (id obj, NSError *error))block andmobile:(NSString *)mobile andinputCode:(NSString *)inputCode andjsCode:(NSString *)jsCode andvalidPhoneExpiredTime:(NSString *)validTime andclientId:(NSString *)clientId;
/**
 *  根据手机号码修改密码
 */
+ (NSURLSessionDataTask *)postUsername:(void (^) (id obj, NSError *error))block andusername:(NSString *)username;
/**
 *  找回密码
 */
+ (NSURLSessionDataTask *)postBackPassword:(void (^) (id obj, NSError *error))block mobileStr:(NSString *)mobileStr vaildPhoneCode:(NSString *)phoneCode JSCode:(NSString *)JSCode newPassword:(NSString *)newPassword validPhoneExpiredTime:(NSString *)validPhoneExpiredTime;
/**
 *  加签名
 */
+ (NSURLSessionDataTask *)postSignature:(void (^) (id obj, NSError *error))block userId:(NSString *)userId;
/**
 *  收益
 */
+ (NSURLSessionDataTask *)postIncome:(void (^) (id obj, NSError *error))block userId:(NSString *)userId;
/**
 *  我的账单
 */
+ (NSURLSessionDataTask *)postMyBill:(void (^)(id, NSError *))block userId:(NSString *)userId pageNum:(int)pageNum andpageSize:(int)pageSize andMonth:(NSString *)queryMonth andType:(NSString *)type;
/**
 *  资产明细
 */
+ (NSURLSessionDataTask *)postAccountPage:(void (^) (id obj, NSError *error))block userId:(NSString *)userId;
/**
 *  用户个人信息
 */
+ (NSURLSessionDataTask *)postUserInformation:(void (^) (id obj, NSError *error))block userId:(NSString *)userId;
/**
 *  修改绑定手机
 */
+ (NSURLSessionDataTask *)postModifyMobile:(void (^) (id obj, NSError *error))block mobile:(NSString *)mobile inputRandomCode:(NSString *)inputCode jsCode:(NSString *)jsCode validPhoneExpiredTime:(NSString *)validPhoneExpiredTime oldMobile:(NSString *)oldMobile;
/**
 *  充值加签
 */
+ (NSURLSessionDataTask *)postRechargeSignature:(void (^)(id obj, NSError *error))block userId:(NSString *)userId amount:(NSString *)amount;
/**
 *  获取银行卡信息
 */
+ (NSURLSessionDataTask *)postBankMessage:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 *  提现显示账户余额
 */
+ (NSURLSessionDataTask *)postRemainCount:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 *  提现
 */
+ (NSURLSessionDataTask *)postWithdraw:(void (^)(id obj, NSError *error))block userId:(NSString *)userId cashAmount:(NSString *)cashAmount bankId:(NSString *)bankId password:(NSString *)password mcryptKey:(NSString *)mcryptKey routeFlag:(NSString *)routeFlag;
/**
 *  校验验证码
 */
+ (NSURLSessionDataTask *)postCheckMobile:(void (^) (id obj, NSError *error))block inputRandomCode:(NSString *)inputCode jsCode:(NSString *)jsCode validPhoneExpiredTime:(NSString *)validPhoneExpiredTime;

/**
 *  红包、加息劵、体验金
 */
+ (NSURLSessionDataTask *)postCouponTicketGold:(void (^)(id obj, NSError *error))block userId:(NSString *)userId andpageSize:(NSString *)size andpageNum:(NSString *)num andtype:(NSInteger)tag;
/**
 *  投资时显示红包
 */
+ (NSURLSessionDataTask *)postShowRedMessage:(void (^) (id obj, NSError *error))block amount:(NSString *)amount userId:(NSString *)userId anditemCycle:(NSString *)itemCycle andbalance:(NSString *)balance;
/**
 *  投资时显示加息券
 */
+ (NSURLSessionDataTask *)postShowTicketMessage:(void (^) (id obj, NSError *error))block amount:(NSString *)amount userId:(NSString *)userId anditemCycle:(NSString *)itemCycle andbalance:(NSString *)balance;
/**
 *  项目的购买
 */
+ (NSURLSessionDataTask *)postBuyProject:(void (^) (id obj, NSError *error))block amount:(NSString *)amount userId:(NSString *)userId itemId:(NSString *)itemId couponId:(NSString *)couponId ticketId:(NSString *)ticketId;
/**
 *  登录状态的项目的信息
 */
+ (NSURLSessionDataTask *)postProjectMessage:(void (^) (id obj, NSError *error))block userId:(NSString *)userId itemId:(NSString *)itemId;

/**
 *  实名认证(开户)
 */
+ (NSURLSessionDataTask *)postRealName:(void (^) (id obj, NSError *error))block userId:(NSString *)userId realName:(NSString *)realname identifyCard:(NSString *)identifyCard;
/**
 *  添加银行卡
 */
+ (NSURLSessionDataTask *)postAddBank:(void (^) (id obj, NSError *error))block userId:(NSString *)userId;

/**
 *  实名成功后的信息
 */
+ (NSURLSessionDataTask *)postrealName:(void (^) (id obj, NSError *error))block userId:(NSString *)userId;
/**
 *   投资记录
 */
+ (NSURLSessionDataTask *)postItemInformation:(void (^) (id obj, NSError *error))block itemId:(NSString *)itemId andpageSize:(NSString *)pageSize andpageNum:(NSString *)pageNum;
/**
 *  首页数据
 */
+ (NSURLSessionDataTask *)postHome:(void (^) (id obj, NSError *error))block itemType:(NSString *)itemType pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize;
/**
 *  收益计算
 */
+ (NSURLSessionDataTask *)postcalCulator:(void (^) (id obj, NSError *error))block andamount:(NSString *)amount anditemId:(NSString *)itemId andticketId:(NSString *)ticketId;
/**
 *  自动投标
 */
+ (NSURLSessionDataTask *)postAutoAdd:(void (^) (id obj, NSError *error))block anduserId:(NSString *)userId anditemStatus:(NSString *)itemStatus anditemAmountType:(NSString *)AmountType anditemAmount:(NSString *)itemAmount anditemRateMin:(NSString *)rateMin anditemRateMax:(NSString *)rateMax anditemRateStatus:(NSString *)rateStatus anditemDayMin:(NSString *)daymin anditemDayMax:(NSString *)dayMax anditemDayStatus:(NSString *)dayStatus anditemLockStatus:(NSString *)lockStatus anditemLockCycle:(NSString *)lockCycle anditemAddRate:(NSString *)addRate andjsCode:(NSString *)jsCode andinputCode:(NSString *)inputCode andvalidPhoneExpiredTime:(NSString *)validPhoneExpiredTime andgoodsName:(NSString *)goodsName andautoId:(NSString *)autoId;
/**
 *  体验金
 */
+ (NSURLSessionDataTask *)postExperienceGlod:(void (^) (id obj, NSError *error))block userId:(NSString *)userId;
/**
 *  充值
 */
+ (NSURLSessionDataTask *)postApplyRecharge:(void (^) (id obj, NSError *error))block userId:(NSString *)userId amount:(NSString *)amount bankId:(NSString *)bankId password:(NSString *)password mcryptKey:(NSString *)mcryptKey paymentId:(NSString *)paymentId;
/**
 *  用户系统设置
 */
+ (NSURLSessionDataTask *)postWithSystem:(void (^) (id obj, NSError *error))block userId:(NSMutableDictionary *)muDic andtag:(NSInteger)tag;
/**
 *  直接登录
 */
+ (NSURLSessionDataTask *)postInstantLogin:(void (^) (id obj, NSError *error))block mobile:(NSString *)mobile clientId:(NSString *)clientId;
/**
 *  自动投标查询
 */
+ (NSURLSessionDataTask *)postGetAuto:(void (^) (id obj, NSError *error))block userId:(NSString *)userId;
/**
 *  自动投标记录
 */
+ (NSURLSessionDataTask *)postGetAutoRecode:(void (^) (id obj, NSError *error))block userId:(NSString *)userId;
/**
 *  自动投标短信验证码
 */
+ (NSURLSessionDataTask *)postAutoSms:(void (^) (id obj, NSError *error))block userId:(NSString *)userId andvaildPhoneCode:(NSString *)vaildPhoneCode;
//修改密码
+ (NSURLSessionDataTask *)postChange_passwordRecord:(void (^) (id obj, NSError *error))block andLoginName:(NSString *)LoginName andnewPassword:(NSString *)newPassword andphoneCode:(NSString *)phoneCode andjsCode:(NSString *)jsCode andimageTime:(NSString *)imageTime;
//短信验证码
+ (NSURLSessionDataTask *)PostWithVerificationUserCode:(void (^) (id obj, NSError *error))block vaildPhoneCode:(NSString *)vaildPhoneCode userId:(NSString *)userId;
//消息中心(站内信)
+ (NSURLSessionDataTask *)postSiteMail:(void (^)(id obj, NSError *error))block userId:(NSString *)userId andpageSize:(NSString *)size andpageNum:(NSString *)num;
/**
 * 获取用户系统设置
 */
+ (NSURLSessionDataTask *)postUserSystemSetting:(void (^)(id object, NSError *error))block userId:(NSString *)userId;
/**
 *  修改系统设置
 */
+ (NSURLSessionDataTask *)postChangeSystemSetting:(void (^)(id obj, NSError *error))block userId:(NSString *)userId gesture:(NSString *)gesture touchID:(NSString *)touchID accountProtect:(NSString *)accountProtect;
/**
 *  查看手势密码是否存在
 */
+ (NSURLSessionDataTask *)postGestureExist:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 *  更新手势密码
 */
+ (NSURLSessionDataTask *)postUpdateGesture:(void (^)(id obj, NSError *error))block userId:(NSString *)userId newGesture:(NSString *)newGesture;
/**
 *  验证手势密码
 */
+ (NSURLSessionDataTask *)postMatchGesture:(void (^)(id obj, NSError *error))block userId:(NSString *)userId gestureStr:(NSString *)gestureStr;
/**
 头像
 */
+ (NSURLSessionDataTask *)postUpdateIcon:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 充值记录
 */
+ (NSURLSessionDataTask *)postTopupRecorde:(void (^)(id obj, NSError *error))block userId:(NSString *)userId pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize;
/**
 提现记录
 */
+ (NSURLSessionDataTask *)postWithdrawRecorde:(void (^)(id obj, NSError *error))block userId:(NSString *)userId pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize;
/**
 合同查看
 */
+ (NSURLSessionDataTask *)postContractsList:(void (^)(id obj, NSError *error))block userId:(NSString *)userId pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize;
/*  
 修改手势密码验证码校验
 */
+ (NSURLSessionDataTask *)postCheckOutGesture:(void (^)(id obj, NSError *error))block mobile:(NSString *)mobile inputCode:(NSString *)inputCode validTime:(NSString *)validTime jsCode:(NSString *)jsCode;
/*
 投资记录详情
 */
+ (NSURLSessionDataTask *)postInvestDetail:(void (^)(id obj, NSError *error))block andInvestId:(NSString *)investId;
/*
 活动页面
 */
+ (NSURLSessionDataTask *)postActivity:(void (^)(id obj, NSError *error))block;

/**
 修改自动投标
 */
+ (NSURLSessionDataTask *)postModifyAuto:(void (^)(id obj, NSError *error))block andUserId:(NSString *)userId andId:(NSString *)Id andvalidPhoneExpiredTime:(NSString *)validPhoneExpiredTime andjsCode:(NSString *)jsCode andinputCode:(NSString *)inputCode anditemStatus:(NSString *)itemStatus;
/**
 第三方登录
 */
+ (NSURLSessionDataTask *)postLoginWithOtherSelector:(void (^)(id obj, NSError *error))block openId:(NSString *)openId type:(NSString *)type clientId:(NSString *)clientId nickname:(NSString *)nickname;
/**
 第三方绑定登录
 */
+ (NSURLSessionDataTask *)postRelevanceLogin:(void (^)(id obj, NSError *error))block openId:(NSString *)openId type:(NSString *)type mobile:(NSString *)mobile clientId:(NSString *)clientId inputRandomCode:(NSString *)inputRandomCode jsCode:(NSString *)jsCode validPhoneExpiredTime:(NSString *)validPhoneExpiredTime nickname:(NSString *)nickname;
/**
 获取微信用户openId
 */
+ (NSURLSessionDataTask *)getWechatMessage:(void (^)(id obj,NSError *error))block code:(NSString *)code;
/**
 获取微信用户个人信息
 */
+ (NSURLSessionDataTask *)getWechatUserInfo:(void (^)(id obj,NSError *error))block token:(NSString *)token openId:(NSString *)openId;
/**
 合同的查看
 */
+ (NSURLSessionDataTask *)postContractsSee:(void (^)(id obj,NSError *error))block orderNo:(NSString *)orderNo;
/**
 邀请好友信息数据
 */
+ (NSURLSessionDataTask *)postInviteUserMessage:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 删除自动投标
 */
+ (NSURLSessionDataTask *)postDeleteAuto:(void (^)(id obj, NSError *error))block autoId:(NSString *)autoId;
/**
 活动页数据
 */
+ (NSURLSessionDataTask *)postActivityScreen:(void (^)(id obj, NSError * error))block;
/**
 分享回调
 */
+ (NSURLSessionDataTask *)postShareMessage:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 服务器是否处于对账期
 */
+ (NSURLSessionDataTask *)postServeTime:(void (^)(id obj, NSError *error))block;
/**
 项目剩余可投金额
 */
+ (NSURLSessionDataTask *)postItemRemainAccount:(void (^)(id obj, NSError *error))block itemId:(NSString *)itemId;
/**
 根据月份获取起止日
 */
+ (NSURLSessionDataTask *)postGetStartAndEndByMonth:(void (^)(id obj, NSError *error))block queryMonth:(NSString *)queryMonth;
/**
 累计投资和累计收益（总的）
 */
+ (NSURLSessionDataTask *)postBillCount:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 我的账单首页
 */
+ (NSURLSessionDataTask *)postBillIndex:(void (^)(id obj, NSError *error))block userId:(NSString *)userId queryMonth:(NSString *)queryMonth;
/**

 充值提现界面数据展示
 */
+ (NSURLSessionDataTask *)postData:(void (^)(id obj, NSError *error))block userId:(NSString *)userId type:(NSInteger)tag;
/**
 充值提现界面数据详情展示
 */
+ (NSURLSessionDataTask *)postDetailsData:(void (^)(id obj, NSError *error))block userId:(NSString *)userId rechargeId:(NSString *)rechargeId type:(NSInteger)tag;
/**
 提现/充值单条记录进度数据展示
 */
+ (NSURLSessionDataTask *)postRechargeDetails:(void (^)(id obj, NSError *error))block userId:(NSString *)userId rechargeId:(NSString *)rechargeId type:(NSInteger)tag;
/**
 用户本月部分投资记录
 */
+ (NSURLSessionDataTask *)postGetInvestListAllByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId queryMonth:(NSString *)queryMonth;
/**
 用户本月部分回款记录
 */
+ (NSURLSessionDataTask *)postGetCollectListByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId queryMonth:(NSString *)queryMonth;
/**
 用户本月所有投资记录
 */
+ (NSURLSessionDataTask *)postGetInvestListByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId queryMonth:(NSString *)queryMonth;
/**
 用户本月所有回款记录
 */
+ (NSURLSessionDataTask *)postGetCollectListAllByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId queryMonth:(NSString *)queryMonth;
/**
 邀请好友首页
 */
+ (NSURLSessionDataTask *)postInviteFriendByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 奖励明细
 */
+ (NSURLSessionDataTask *)postGetRewardLists:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 邀请人列表
 */
+ (NSURLSessionDataTask *)postGetInviteInfoLists:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 锁投有礼首页商品类型
 */
+ (NSURLSessionDataTask *)postGetGoodsTypeList:(void (^)(id obj, NSError *error))block;
/**
 某个类目下的商品列表
 */
+ (NSURLSessionDataTask *)postGetGoodsTypeList:(void (^)(id obj, NSError *error))block pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize userId:(NSString *)userId typeId:(NSString *)typeId;
/**
 某个类目下的商品所有列表
 */
+ (NSURLSessionDataTask *)postGetGoodsListAllByType:(void (^)(id obj, NSError *error))block userId:(NSString *)userId typeId:(NSString *)typeId;
/**
 单个商品点击进入详情页
 */
+ (NSURLSessionDataTask *)postGetGoodsDetails:(void (^)(id obj, NSError *error))block goodsId:(NSString *)goodsId;
/**
 根据商品id查询期限种类
 */
+ (NSURLSessionDataTask *)postGetGoodsKinds:(void (^)(id obj, NSError *error))block goodsId:(NSString *)goodsId;
/**
 锁投有礼首页全部商品
 */
+ (NSURLSessionDataTask *)postGetAllGoods:(void (^)(id obj, NSError *error))block pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize;
/**
 库存及限购校验
 */
+ (NSURLSessionDataTask *)postCheckCountAndRemainder:(void (^)(id obj, NSError *error))block kindId:(NSString *)kindId num:(NSString *)num userId:(NSString *)userId;
/**
 商品详情的商品详情
 */
+ (NSURLSessionDataTask *)postGetGoodsDescription:(void (^)(id obj, NSError *error))block goodsId:(NSString *)goodsId;
/**
 商品详情页立即投资
 */
+ (NSURLSessionDataTask *)postInvest:(void (^)(id obj, NSError *error))block kindId:(NSString *)kindId num:(NSString *)num userId:(NSString *)userId;
/**
 首页获取数据
 */
+ (NSURLSessionDataTask *)postIndex:(void (^)(id obj, NSError *error))block;
/**
 检查用户账户可提是否够订单金额
 */
+ (NSURLSessionDataTask *)postCheckAccountCash:(void (^)(id obj, NSError *error))block orderNo:(NSString *)orderNo;
/**
 理财列表
 */
+ (NSURLSessionDataTask *)postList:(void (^)(id obj, NSError *error))block pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize itemStatus:(NSString *)itemStatus itemType:(NSString *)itemType;
/**
 项目详情
 */
+ (NSURLSessionDataTask *)postItemDocuments:(void (^)(id obj, NSError *error))block itemId:(NSString *)itemId;
/**
 登录状态的项目信息
 */
+ (NSURLSessionDataTask *)postInformation:(void (^)(id obj, NSError *error))block itemId:(NSString *)itemId userId:(NSString *)userId;
/**
 投资
 */
+ (NSURLSessionDataTask *)postBuy:(void (^)(id obj, NSError *error))block amount:(NSString *)amount userId:(NSString *)userId couponId:(NSString *)couponId ticketId:(NSString *)ticketId investType:(NSString *)investType itemId:(NSString *)itemId paymentPassword:(NSString *)paymentPassword mcryptKey:(NSString *)mcryptKey;
/**
 获取单个投资详情
 */
+ (NSURLSessionDataTask *)postGetInvestDetails:(void (^)(id obj, NSError *error))block investId:(NSString *)investId;
/**
 获取单个回款记录详情
 */
+ (NSURLSessionDataTask *)postGetCollectDetails:(void (^)(id obj, NSError *error))block collectId:(NSString *)collectId;
/**
 付息表
 */
+ (NSURLSessionDataTask *)postGetCollectListByinvestId:(void (^)(id obj, NSError *error))block investId:(NSString *)investId;
/**
 查看合同
 */
+ (NSURLSessionDataTask *)postGetContracts:(void (^)(id obj, NSError *error))block investId:(NSString *)investId;
/**
 活动图列表
 */
+ (NSURLSessionDataTask *)postActivityList:(void (^)(id obj, NSError *error))block;
/**
 公告列表
 */
+ (NSURLSessionDataTask *)postGetNoticeList:(void (^)(id obj, NSError *error))block;
/**
 公告动态
 */
+ (NSURLSessionDataTask *)postGetAnnouncementList:(void (^)(id obj, NSError *error))block pageSize:(NSString *)pageSize pageNum:(NSString *)pageNum;
/**
 自动投标排名
 */
+ (NSURLSessionDataTask *)postGetRankByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 自动投标累计在投
 */
+ (NSURLSessionDataTask *)postCountInvestingByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 自动投标累计开启人数
 */
+ (NSURLSessionDataTask *)postCountUsePeople:(void (^)(id obj, NSError *error))block;
/**
 自动投标统计余额
 */
+ (NSURLSessionDataTask *)postCountBalance:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 设置自动投标验证码
 */
+ (NSURLSessionDataTask *)postCountBalance:(void (^)(id obj, NSError *error))block userId:(NSString *)userId vaildPhoneCode:(NSString *)vaildPhoneCode;
/**
 添加自动投标
 */
+ (NSURLSessionDataTask *)postAutoInvestAdd:(void (^)(id obj, NSError *error))block itemUserId:(NSString *)itemUserId autoId:(NSString *)autoId itemStatus:(NSString *)itemStatus itemRateMin:(NSString *)itemRateMin itemRateMax:(NSString *)itemRateMax itemDayMin:(NSString *)itemDayMin itemDayMax:(NSString *)itemDayMax itemAmount:(NSString *)itemAmount password:(NSString *)password salt:(NSString *)salt type:(NSInteger)type itemType:(NSString *)itemType;
/**
 获取二维码
 */
+ (NSURLSessionDataTask *)postGetUserQrCode:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 用户免密投资授权与否校验
 */
+ (NSURLSessionDataTask *)postCheckAuthority:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 订单支付
 */
+ (NSURLSessionDataTask *)postOrderPay:(void (^)(id obj, NSError *error))block orderNo:(NSString *)orderNo address:(NSString *)address receiveName:(NSString *)receiveName receiveMobile:(NSString *)receiveMobile password:(NSString *)password salt:(NSString *)salt;
/**
 我的订单列表
 */
+ (NSURLSessionDataTask *)postGetMyOrderLists:(void (^)(id obj, NSError *error))block pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize status:(NSString *)status userId:(NSString *)userId;
/**
 统计未完成订单数量
 */
+ (NSURLSessionDataTask *)postCountUnCompleteOrder:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 获取用户名
 */
+ (NSURLSessionDataTask *)postGetUserName:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 用户查询收货地址
 */
+ (NSURLSessionDataTask *)postQueryAddressByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 (type 是0 用户添加收货地址)(type 是1 用户修改收货地址)
 */
+ (NSURLSessionDataTask *)postModifyAddress:(void (^)(id obj, NSError *error))block userId:(NSString *)userId mobile:(NSString *)mobile address:(NSString *)address userName:(NSString *)userName type:(NSInteger)type addressId:(NSString *)addressId;
/**
 用户点击订单查看订单详情
 */
+ (NSURLSessionDataTask *)postGetOrderDetails:(void (^)(id obj, NSError *error))block orderNo:(NSString *)orderNo;
/**
 取消订单
 */
+ (NSURLSessionDataTask *)postOrderCancel:(void (^)(id obj, NSError *error))block orderNo:(NSString *)orderNo;
/**
 物流信息查询
 */
+ (NSURLSessionDataTask *)postQueryLogisticsByNo:(void (^)(id obj, NSError *error))block userId:(NSString *)userId logisticsNo:(NSString *)logisticsNo logisticsType:(NSString *)logisticsType;
/**
 用户授权
 */
+ (NSURLSessionDataTask *)postMobileAuthorization:(void (^)(id obj, NSError *error))block userId:(NSString *)userId grantList:(NSString *)grantList;
/**
 获取消息列表
 */
+ (NSURLSessionDataTask *)postGetSiteMailList:(void (^)(id obj, NSError *error))block userId:(NSString *)userId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize type:(NSString *)type;
/**
 根据手机号码修改密码
 */
+ (NSURLSessionDataTask *)postModifyByPasswordByMobile:(void (^)(id obj, NSError *error))block mobile:(NSString *)mobile password:(NSString *)password;
/**
 实名认证
 */
+ (NSURLSessionDataTask *)postUserRealName:(void (^)(id obj, NSError *error))block userId:(NSString *)userId bizType:(NSString *)bizType;
/**
 点击单条消息（读消息）
 */
+ (NSURLSessionDataTask *)postReadSiteMail:(void (^)(id obj, NSError *error))block siteMailId:(NSString *)siteMailId;
/**
 投资返回查询投资状态
 */
+ (NSURLSessionDataTask *)postGetInvestResult:(void (^)(id obj, NSError *error))block orderId:(NSString *)orderId;
/**
 自动投标记录
 */
+ (NSURLSessionDataTask *)postGetLists:(void (^)(id obj, NSError *error))block pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize userId:(NSString *)userId investType:(NSString *)investType queryMonth:(NSString *)queryMonth;
/**
 根据itemId获得风险评估模板
 */
+ (NSURLSessionDataTask *)postGetRiskTemplet:(void (^)(id obj, NSError *error))block itemId:(NSString *)itemId;
/**
 查看存管账户
 */
+ (NSURLSessionDataTask *)postMobileAccountInfoManage:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 会员首页
 */
+ (NSURLSessionDataTask *)postGetGradeAndIntegral:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 会员权益模块
 */
+ (NSURLSessionDataTask *)postGetPrivileges:(void (^)(id obj, NSError *error))block;
/**
 根据会员等级和权益id查询会员可享受权益
 */
+ (NSURLSessionDataTask *)postGetConfigByIdAndGrade:(void (^)(id obj, NSError *error))block privilegeId:(NSString *)privilegeId grade:(NSString *)grade;
/**
 根据会员等级查询该等级可享权益列表
 */
+ (NSURLSessionDataTask *)postGetConfigsByGrade:(void (^)(id obj, NSError *error))block grade:(NSString *)grade;
/**
 查询单个权益模块不同会员等级可享权益
 */
+ (NSURLSessionDataTask *)postGetConfigById:(void (^)(id obj, NSError *error))block privilegeId:(NSString *)privilegeId;
/**
 不同等级需要年化门槛
 */
+ (NSURLSessionDataTask *)postGetMemberGrade:(void (^)(id obj, NSError *error))block;
/**
 用户积分记录
 */
+ (NSURLSessionDataTask *)postGetIntegralLogs:(void (^)(id obj, NSError *error))block userId:(NSString *)userId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize;
/**
 根据用户id和任务类型查询任务列表
 */
+ (NSURLSessionDataTask *)postGetMissions:(void (^)(id obj, NSError *error))block userId:(NSString *)userId type:(NSString *)type;
/**
 会员中心推荐任务列表
 */
+ (NSURLSessionDataTask *)postGetRecommendMission:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 理财计划列表
 */
+ (NSURLSessionDataTask *)postGetWalletLists:(void (^)(id obj, NSError *error))block isDelete:(NSString *)isDelete;
/**
 我的计划规则统计
 */
+ (NSURLSessionDataTask *)postCountPlans:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 计划中我的规则列表
 */
+ (NSURLSessionDataTask *)postMyPlans:(void (^)(id obj, NSError *error))block userId:(NSString *)userId isDelete:(NSString *)isDelete;
/**
 查询单个理财计划内容
 */
+ (NSURLSessionDataTask *)postGetOneById:(void (^)(id obj, NSError *error))block planId:(NSString *)planId;
/**
 实名前查询老用户实名信息
 */
+ (NSURLSessionDataTask *)postRealNameInformation:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 *  实名认证
 */
+ (NSURLSessionDataTask *)postMakeRealName:(void (^) (id obj, NSError *error))block userId:(NSString *)userId realName:(NSString *)realname identifyCard:(NSString *)identifyCard paymentPassword:(NSString *)paymentPassword mcryptKey:(NSString *)mcryptKey;
/**
 生成随机因子
 */
+ (NSURLSessionDataTask *)postGetSrandNum:(void (^)(id obj, NSError *error))block;
/**
 根据卡号查询归属地和联行号(绑卡用)
 */
+ (NSURLSessionDataTask *)postQueryBankLocation:(void (^)(id obj, NSError *error))block cardNo:(NSString *)cardNo;
/**
 绑卡验证码申请
 */
+ (NSURLSessionDataTask *)postAddBankSmsSend:(void (^)(id obj, NSError *error))block userId:(NSString *)userId telephone:(NSString *)telephone;
/**
 绑卡
 */
+ (NSURLSessionDataTask *)postAddBank:(void (^)(id obj, NSError *error))block cardNo:(NSString *)cardNo bankCode:(NSString *)bankCode bankName:(NSString *)bankName mobile:(NSString *)mobile subBranch:(NSString *)subBranch subBankCode:(NSString *)subBankCode userId:(NSString *)userId msgBox:(NSString *)msgBox;
/**
 查询锁投规则投资记录
 */
+ (NSURLSessionDataTask *)postGetListByAutoId:(void (^)(id obj, NSError *error))block autoId:(NSString *)autoId;
/**
 查询用户是否绑卡
 */
+ (NSURLSessionDataTask *)postGetBankByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 用户银行卡列表
 */
+ (NSURLSessionDataTask *)postGetListByUserId:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 银行卡解绑
 */
+ (NSURLSessionDataTask *)postUnbindCard:(void (^)(id obj, NSError *error))block userId:(NSString *)userId bankId:(NSString *)bankId password:(NSString *)password mcryptKey:(NSString *)mcryptKey;
/**
 全部已读
 */
+ (NSURLSessionDataTask *)postReadAllSiteMail:(void (^)(id obj, NSError *error))block;
/**
 锁投全部滚动图
 */
+ (NSURLSessionDataTask *)postGetLockAutoPicture:(void (^)(id obj, NSError *error))block;
/**
 推荐商品列表
 */
+ (NSURLSessionDataTask *)postGetRecommendGoods:(void (^)(id obj, NSError *error))block;
/**
 兑吧免登陆接口
 */
+ (NSURLSessionDataTask *)postLogFreeUrl:(void (^)(id obj, NSError *error))block userId:(NSString *)userId redicrect:(NSString *)redicrect;
/**
 修改交易密码
 */
+ (NSURLSessionDataTask *)postChangePasswordWithoutOld:(void (^)(id obj, NSError *error))block msgBox:(NSString *)msgBox newPs:(NSString *)newPs userId:(NSString *)userId factor:(NSString *)factor cardNo:(NSString *)cardNo name:(NSString *)name;
/**
 修改交易密码短信验证码申请
 */
+ (NSURLSessionDataTask *)postApplySMSforChangePassword:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 用户购买理财计划
 */
+ (NSURLSessionDataTask *)postBuyPlan:(void (^)(id obj, NSError *error))block userId:(NSString *)userId planId:(NSString *)planId amount:(NSString *)amount password:(NSString *)password salt:(NSString *)salt;
/**
 常用短信验证码接口
 */
+ (NSURLSessionDataTask *)postCommonSms:(void (^)(id obj, NSError *error))block userId:(NSString *)userId vaildPhoneCode:(NSString *)vaildPhoneCode;
/**
 自动投标关闭
 */
+ (NSURLSessionDataTask *)postUpdateStatus:(void (^)(id obj, NSError *error))block autoId:(NSString *)autoId newStatus:(NSString *)newStatus oldStatus:(NSString *)oldStatus;
/**
 老用户验证身份证和姓名
 */
+ (NSURLSessionDataTask *)postOldUserCheck:(void (^)(id obj, NSError *error))block userId:(NSString *)userId realname:(NSString *)realname identifyCard:(NSString *)identifyCard;
/**
 获取商品类目icon
 */
+ (NSURLSessionDataTask *)postGetTypeIcon:(void (^)(id obj, NSError *error))block typeId:(NSString *)typeId;
/**
 自动填入金额查询
 */
+ (NSURLSessionDataTask *)postAutoFill:(void (^)(id obj, NSError *error))block userId:(NSString *)userId itemId:(NSString *)itemId;
/**
 会员首页弹屏
 */
+ (NSURLSessionDataTask *)postGetMemberPicture:(void (^)(id obj, NSError *error))block picName:(NSString *)picName;
/**
 签到
 */
+ (NSURLSessionDataTask *)postGetMemberPicture:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 预约标
 */
+ (NSURLSessionDataTask *)postAppointBid:(void (^)(id obj, NSError *error))block userId:(NSString *)userId itemId:(NSString *)itemId;
/**
 获取投资广告图
 */
+ (NSURLSessionDataTask *)postInvestEndPic:(void (^)(id obj, NSError *error))block investId:(NSString *)investId;
/**
 查询交易密码是否设置接口
 */
+ (NSURLSessionDataTask *)postCheckTradingPs:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 积分商城推荐商品
 */
+ (NSURLSessionDataTask *)postVipRegister:(void (^)(id obj, NSError *error))block isDelete:(NSString *)isDelete isRecommend:(NSString *)isRecommend pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize;
/**
 首次设置交易密码接口
 */
+ (NSURLSessionDataTask *)postSetPaymentPs:(void (^)(id obj, NSError *error))block userId:(NSString *)userId factor:(NSString *)factor password:(NSString *)password;
/**
 版本更新
 */
+ (NSURLSessionDataTask *)postAppVersionUpdate:(void (^)(id obj, NSError *error))block;
/**
 获取当月日历   日期 格式为yyyy-MM
 */
+ (NSURLSessionDataTask *)postCalendar:(void (^)(id obj, NSError *error))block userId:(NSString *)userId dateStr:(NSString *)dateStr;
/**
 获取当日投资和回款记录   需要查看的日期 （格式为yyyy-MM-dd)
 */
+ (NSURLSessionDataTask *)postCalendarList:(void (^)(id obj, NSError *error))block userId:(NSString *)userId viewDate:(NSString *)viewDate;
/**
 支付公司类型
 */
+ (NSURLSessionDataTask *)postGetSupportBankLimit:(void (^)(id obj, NSError *error))block bankId:(NSString *)bankId;
/**
 获取Tabbar icon
 */
+ (NSURLSessionDataTask *)postGetBottonIcon:(void (^)(id obj, NSError *error))block;
/**
 开户数字
 */
+ (NSURLSessionDataTask *)postCountNoviceWelfare:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 福利红点
 */
+ (NSURLSessionDataTask *)postHasCanUseReward:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 个人中心弹屏
 */
+ (NSURLSessionDataTask *)postGetNoviceWelfare:(void (^)(id obj, NSError *error))block clientId:(NSString *)clientId;
/**
 福利中心 阅读消息
 */
+ (NSURLSessionDataTask *)postReadReward:(void (^)(id obj, NSError *error))block userId:(NSString *)userId key:(NSString *)key;
/**
 我的账单
 */
+ (NSURLSessionDataTask *)postGetAccountLog:(void (^)(id obj, NSError *error))block userId:(NSString *)userId queryMonth:(NSString *)queryMonth type:(NSString *)type;
/**
  用户分享完成
 */
+ (void)postShare:(void (^)(id obj, NSError *error))block userId:(NSString *)userId isBanner:(NSString *)isBanner;//isBanner 1为banner分享，0为投资后分享
/**
 用户实时获取版本号
 */
+ (NSURLSessionDataTask *)postUpdateVersion:(void (^)(id obj, NSError *error))block;
/**
 首页TouchButton图片
 */
+ (NSURLSessionDataTask *)postGetFloatingPicture:(void (^)(id obj, NSError *error))block;
/**
 邀请好友中的奖励列表
 */
+ (NSURLSessionDataTask *)postGetNewRewardLists:(void (^)(id obj, NSError *error))block userId:(NSString *)userId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize;
/**
 邀请好友中的邀请人数列表
 */
+ (NSURLSessionDataTask *)postGetPageInviteInfoLists:(void (^)(id obj, NSError *error))block userId:(NSString *)userId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize;
/**
 邀请好友中的图片
 */
+ (NSURLSessionDataTask *)postGetInvitePagePic:(void (^)(id obj, NSError *error))block;
/**
 大额充值中的开户姓名 开户银行 银行商户的接口
 */
+ (NSURLSessionDataTask *)postBigAmountRechargeData:(void (^)(id obj, NSError *error))block;
/**
 人脸识别  人脸识别前获取人脸识别因子
 */
+ (NSURLSessionDataTask *)postFaceAuthent:(void (^)(id obj, NSError *error))block userId:(NSString *)userId;
/**
 人脸识别 人脸识别后调用的接口 （Integer userId,Integer isSuccess（1是成功，0是失败））
 */
+ (NSURLSessionDataTask *)postDoFaceAuthent:(void (^)(id obj, NSError *error))block userId:(NSString *)userId isSuccess:(NSString *)isSuccess;
/**
 人脸识别失败后 人工审核接口 (Integer userId,String imgUrl（图片url）)
 */
+ (NSURLSessionDataTask *)postManualCheck:(void (^)(id obj, NSError *error))block userId:(NSString *)userId imgUrl:(NSString *)imgUrl;
@end















