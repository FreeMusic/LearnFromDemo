//
//  API.h
//  CityJinFu
//
//  Created by xxlc on 17/6/10.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#ifndef API_h
#define API_h

#define AccountPage @"/mobile/account/accountPage"//资产查询
#define ApplyRecharge @"/mobile/account/applyRecharge"//充值
#define GetRechargeListByUserId @"/mobile/account/getRechargeListByUserId"//充值记录
#define Cash @"/mobile/account/cash"//提现
#define CashCheck @"/mobile/account/cashCheck"//提现校验
#define GetCashListByUserId @"/mobile/account/getCashListByUserId"//提现记录
#define RechargeData @"/mobile/account/rechargeData"//充值页面数据展示
#define CashData @"/mobile/account/cashData"//提现界面数据展示
#define RechargeDetails @"/mobile/account/rechargeDetails"//充值详情页展示
#define CashDetails @"/mobile/account/cashDetails"//提现详情展示
#define RechargeDetails @"/mobile/account/rechargeDetails"//充值单条记录进度数据展示
#define CashDetails @"/mobile/account/cashDetails"//提现单条记录进度数据展示
#define GetInvestListAllByUserId @"/mobile/bill/getInvestListAllByUserId"//本月部分投资记录
#define GetInvestListByUserId @"/mobile/bill/getInvestListByUserId"//本月所有投资记录
#define GetCollectListByUserId @"/mobile/bill/getCollectListByUserId"//本月所有回款记录
#define GetCollectListAllByUserId @"/mobile/bill/getCollectListAllByUserId"//本月部分回款记录
#define InviteFriend @"/mobile/invite/index"//邀请好友首页
#define GetRewardLists @"/mobile/invite/getRewardLists"//奖励明细
#define GetInviteInfoLists @"/mobile/invite/getInviteInfoLists"//邀请人列表
#define GetGoodsTypeList @"/mobile/lockInvest/getGoodsTypeList"//锁投有礼首页商品类型
#define GetGoodsListByType @"/mobile/lockInvest/getGoodsListByType"//某个类目下的商品列表
#define GetGoodsListAllByType @"/mobile/lockInvest/getGoodsListAllByType"//某个类目下的商品所有列表
#define GetGoodsDetails @"/mobile/lockInvest/getGoodsDetails"//单个商品点击进入详情页
#define GetGoodsKinds @"/mobile/lockInvest/getGoodsKinds"//根据商品id查询期限种类
#define GetAllGoods @"/mobile/lockInvest/getAllGoods"//锁投有礼首页全部商品
#define CheckCountAndRemainder @"/mobile/lockInvest/checkCountAndRemainder"//库存及限购校验
#define GetGoodsDescription @"/mobile/lockInvest/getGoodsDescription"//商品详情的商品详情
#define Invest @"/mobile/lockInvest/invest"//商品详情页立即投资
#define HomeIndex @"/mobile/index"//首页获取数据
#define CheckAccountCash @"/mobile/order/checkAccountCash"//检查用户账户可提是否够订单金额
#define MoneyList @"/mobile/item/list"//理财列表
#define ItemDocuments @"/mobile/item/documents"//项目详情
#define Information @"/mobile/item/information"//登录状态的项目信息
#define Buy @"/mobile/invest/buy" //投资
#define GetInvestDetails @"/mobile/bill/getInvestDetails"//获取单个投资详情
#define GetCollectDetails @"/mobile/bill/getCollectDetails"//获取单个回款记录详情
#define GetCollectListByinvestId @"/mobile/bill/getCollectListByinvestId"//付息表
#define GetContracts @"/user/getContracts"//查看合同
#define Activitylist @"/mobile/activity/list"//活动图列表
#define GetNoticeList @"/mobile/activity/getNoticeList"//公告列表
#define GetAnnouncementList @"/mobile/activity/getAnnouncementList"//公告动态
#define GetByUserId @"/mobile/autoInvest/getByUserId"//自动投标查询
#define CountInvestingByUserId @"/mobile/autoInvest/countInvestingByUserId"//自动投标累计在投
#define GetRankByUserId @"/mobile/autoInvest/getRankByUserId"//自动投标排名
#define CountUsePeople @"/mobile/autoInvest/countUsePeople"//自动投标累计开启人数
#define CountBalance @"/mobile/autoInvest/countBalance"//自动投标统计余额
#define AutoSms @"/mobile/user/autoSms"//设置自动投标验证码
#define Add @"/mobile/autoInvest/add"//添加自动投标
#define ModifyAuto @"/mobile/autoInvest/modifyAuto"//修改自动投标
#define GetUserQrCode @"/mobile/invite/getUserQrCode"//获取二维码
#define CheckAuthority @"/mobile/order/checkAuthority"//用户免密投资授权与否校验
#define OrderPay @"/mobile/order/pay"//订单支付
#define GetMyOrderLists @"/mobile/order/getMyOrderLists"//我的订单列表
#define CountUnCompleteOrder @"/mobile/order/countUnCompleteOrder"//统计未完成订单数量
#define GetUserName @"/mobile/order/getUserName"//获取用户名
#define QueryAddressByUserId @"/mobile/order/queryAddressByUserId"//用户查询收货地址
#define ModifyAddress @"/mobile/order/modifyAddress"//用户修改收货地址
#define AddAddress @"/mobile/order/addAddress"//用户添加收货地址
#define GetOrderDetails @"/mobile/order/getOrderDetails"//用户点击订单查看订单详情
#define OrderCancel @"/mobile/order/orderCancel"//取消订单
#define QueryLogisticsByNo @"/mobile/order/queryLogisticsByNo"//物流信息查询
#define MobileAuthorization @"/mobile/order/mobileAuthorization"//用户授权
#define GetSiteMailList @"/mobile/user/getSiteMailList"//获取消息列表
#define RealName @"/mobile/user/realName"//实名认证
#define GetUserByMobile @"/mobile/getUserByMobile"//校验手机号是否已注册
#define RegisterSendSms @"/mobile/user/registerSendSms"//注册发送短信
#define Register @"/mobile/register"//注册接口
#define AddByPasswordByMobile @"/mobile/addByPasswordByMobile"//根据手机号码设置密码
#define ModifyByPasswordByMobile @"/mobile/modifyByPasswordByMobile"//根据手机号码修改密码
#define RealNameCheck @"/mobile/user/realNameCheck"//实名认证前验证
#define RealName @"/mobile/user/realName"//实名认证
#define ReadSiteMail @"/mobile/user/readSiteMail"//点击单条消息（读消息）
#define ReadAllMail @"/mobile/user/readAllSiteMail"//全部已读
#define GetInvestResult @"/return/notice/getInvestResult"//投资返回查询投资状态
#define GetLists @"/mobile/autoInvest/getLists" //自动投标记录
#define GetRiskTemplet @"/mobile/item/getRiskTemplet"//更新用户风险类型
#define MobileAccountInfoManage @"/mobile/manage/mobileAccountInfoManage"//查看存管账户
#define GetGradeAndIntegral @"/mobile/member/getGradeAndIntegral"//会员首页
#define GetPrivileges @"/mobile/member/getPrivileges"//会员权益模块
#define GetConfigByIdAndGrade @"/mobile/member/getConfigByIdAndGrade"//根据会员等级和权益id查询会员可享受权益
#define GetConfigsByGrade @"/mobile/member/getConfigsByGrade"//根据会员等级查询该等级可享权益列表
#define GetConfigById @"/mobile/member/getConfigById"//查询单个权益模块不同会员等级可享权益
#define GetMemberGrade @"/mobile/member/getMemberGrade"//不同等级需要年化门槛
#define GetIntegralLogs @"/mobile/mission/getIntegralLogs"//用户积分记录
#define GetMissions @"/mobile/mission/getMissions"//根据用户id和任务类型查询任务列表
#define GetRecommendMission @"/mobile/mission/getRecommendMission"//会员中心推荐任务列表
#define GetWalletLists @"/mobile/plan/getLists" //理财计划列表
#define CountPlans @"/mobile/plan/countPlans"//我的计划规则统计
#define MyPlans @"/mobile/plan/MyPlans"//计划中我的规则列表
#define GetOneById @"/mobile/plan/getOneById"//查询单个理财计划内容
#define GetListByAutoId @"/mobile/plan/getListByAutoId"//查询锁投规则投资记录
#define RealNameInformation @"/mobile/user/realNameInformation"//实名前查询老用户实名信息
#define GetSrandNum @"/mobile/user/getSrandNum"//生成随机因子
#define QueryBankLocation @"/mobile/bankCard/queryBankLocation" //根据卡号查询归属地和联行号(绑卡用)
#define AddBankSmsSend @"/mobile/account/addBankSmsSend"//绑卡验证码申请
#define AddBank @"/mobile/account/addBank"//绑卡
#define GetBankByUserId @"/mobile/account/getBankByUserId"//查询用户是否绑卡
#define GetListByUserId @"/mobile/account/getListByUserId"//用户银行卡列表
#define UnbindCard @"/mobile/account/unbindCard" //银行卡解绑
#define GetLockAutoPicture @"/mobile/lockInvest/getLockAutoPicture"//锁投全部滚动图
#define GetRecommendGoods @"/mobile/lockInvest/getRecommendGoods"//推荐商品列表
#define LogFreeUrl @"/mobile/duiba/logFreeUrl" //兑吧免登陆接口
#define ChangePasswordWithoutOld @"/mobile/user/changePasswordWithoutOld"//修改交易密码
#define ApplySMSforChangePassword @"/mobile/user/applySMSforChangePassword"//修改交易密码短信验证码申请
#define BuyPlan @"/mobile/plan/buyPlan"//用户购买理财计划
#define CommonSms @"/mobile/user/commonSms"//常用短信验证码接口
#define UpdateStatus @"/mobile/autoInvest/updateStatus"//自动投标关闭
#define Fileupload @"/mobile/user/fileupload"//上传身份证照片
#define OldUserCheck @"/mobile/user/oldUserCheck"//老用户验证身份证和姓名
#define GetTypeIcon @"/mobile/lockInvest/getTypeIcon"//获取商品类目icon
#define AutoFill @"/mobile/invest/autoFill"//自动填入金额查询
#define GetMemberPicture @"/mobile/member/getMemberPicture"//会员首页弹屏
#define SignIn @"/mobile/user/signIn"//签到
#define VipRegister @"/mobile/addIntegral/recommend"//积分商城推荐商品
#define CheckTradingPs @"/mobile/user/checkTradingPs"//查询交易密码是否设置接口
#define SetPaymentPs @"/mobile/user/setPaymentPs"//首次设置交易密码接口
#define AppVersion @"/mobile/version" //版本
#define Calendar @"/mobile/user/calendar"//获取当月日历
#define CalendarList @"/mobile/user/calendarList"//获取当日投资和回款记录
#define GetSupportBankLimit @"/mobile/account/getSupportBankLimit"//支付公司类型
#define GetBottonIcon @"/mobile/index/getBottonIcon"//获取Tabbar icon
#define CountNoviceWelfare @"/mobile/reward/countNoviceWelfare"//新手登录 福利信息
#define HasCanUseReward @"/mobile/reward/hasCanUseReward"//福利红点
#define GetNoviceWelfare @"/mobile/account/getNoviceWelfare"//个人中心弹屏
#define ReadReward @"/mobile/reward/readReward"//福利中心 阅读消息
#define GetAccountLog @"/mobile/bill/getAccountLog"//我的账单
#define Share @"/activity/share/share "//用户分享完成
#define UpdateVersion @"/mobile/account/updateVersion"//用户实时获取版本号
#define GetFloatingPicture @"/mobile/index/getFloatingPicture" //首页TouchButton图片
#define GetNewRewardLists @"/mobile/invite/getNewRewardLists"//邀请好友中的奖励列表
#define GetPageInviteInfoLists @"/mobile/invite/getPageInviteInfoLists"//邀请好友中的邀请人数列表
#define GetInvitePagePic @"/mobile/invite/getInvitePagePic" //邀请好友中的图片
#define BigAmountRechargeData @"/mobile/account/bigAmountRechargeData"//大额充值中的开户姓名 开户银行 银行商户的接口
#define FaceAuthent @"/mobile/account/faceAuthent"//人脸识别前获取人脸识别因子
#define PictureFile @"/pictureFile"//人脸识别失败 人工审核上传图片接口
#define DoFaceAuthent @"/mobile/account/doFaceAuthent"//人脸识别后调用的接口 （Integer userId,Integer isSuccess（1是成功，0是失败））
#define ManualCheck @"/mobile/account/manualCheck" //人脸识别失败后 人工审核接口 (Integer userId,String imgUrl（图片url）)

#endif /* API_h */
