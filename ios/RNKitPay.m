//
//  RNKitPay.m
//  RNKitPay
//
//  Created by SimMan on 2017/06/01.
//  Copyright © 2017年 RNKit.io. All rights reserved.
//

#if __has_include(<React/RCTBridge.h>)
#import <React/RCTConvert.h>
#else
#import "RCTConvert"
#endif

#import "RNKitPay.h"
#import "LLPaySdk.h"
#import <CommonCrypto/CommonDigest.h>

@implementation RCTConvert (RNKitPayType)

RCT_ENUM_CONVERTER(LLPayType, (@{
                                   @"Quick": @(LLPayTypeQuick),
                                   @"Verify": @(LLPayTypeVerify),
                                   @"PreAuth": @(LLPayTypePreAuth),
                                   @"Travel": @(LLPayTypeTravel),
                                   @"RealName": @(LLPayTypeRealName),
                                   @"Car": @(LLPayTypeCar),
                                   @"Instalments": @(LLPayTypeInstalments)
                                }), kLLPayResultUnknow, integerValue)
@end


@interface RNKitPay() <LLPaySdkDelegate> {
    RCTPromiseResolveBlock _resolveBlock;
    RCTPromiseRejectBlock  _rejectBlock;
}
@property (nonatomic, strong) NSDictionary *orderInfo;
@end

@implementation RNKitPay

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()


/**
 *  连连支付 支付接口
 *
 *  @param viewController 推出连连支付支付界面的ViewController
 *  @param payType        连连支付类型:LLPayType （快捷支付、认证支付、预授权支付、游易付、实名快捷支付、车易付）
 *  @param traderInfo     交易信息
 */
RCT_EXPORT_METHOD(pay:(NSString *)payType
                  traderInfo:(NSDictionary *)traderInfo
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    _resolveBlock = resolve;
    _rejectBlock = reject;
    LLPayType type = [RCTConvert LLPayType:payType];
    UIViewController *presentingController = RCTPresentedViewController();
    if (presentingController == nil) {
        RCTLogError(@"Tried to display view but there is no application window.");
    }
    
    [[LLPaySdk sharedSdk] setSdkDelegate:self];
    [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:presentingController withPayType:type andTraderInfo:traderInfo];
}

/**
 *  连连支付 签约接口
 *
 *  @param viewController 推出连连支付签约界面的ViewController
 *  @param payType        连连支付类型:LLPayType（签约支持快捷签约、认证签约、实名快捷签约）
 *  @param traderInfo     交易信息
 */
RCT_EXPORT_METHOD(paySign:(NSString *)payType
                  traderInfo:(NSDictionary *)traderInfo
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    _resolveBlock = resolve;
    _rejectBlock = reject;
    LLPayType type = [RCTConvert LLPayType:payType];
    UIViewController *presentingController = RCTPresentedViewController();
    if (presentingController == nil) {
        RCTLogError(@"Tried to display view but there is no application window.");
    }
    [[LLPaySdk sharedSdk] setSdkDelegate:self];
    [[LLPaySdk sharedSdk] presentLLPaySignInViewController:presentingController withPayType:type andTraderInfo:traderInfo];
}

/**
 *  调用sdk以后的结果回调
 *
 *  @param resultCode 支付结果
 *  @param dic        回调的字典，参数中，ret_msg会有具体错误显示
 */
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary*)dic
{
    NSString *msg = @"支付异常";
    switch (resultCode)
    {
        case kLLPayResultFail:
        {
            msg = dic[@"ret_msg"];
        }
            break;
        case kLLPayResultCancel:
        {
            msg = @"支付取消";
        }
            break;
        case kLLPayResultInitError:
        {
            msg = @"钱包初始化异常";
        }
            break;
        case kLLPayResultInitParamError:
        {
            msg = dic[@"ret_msg"];
        }
            break;
        default:
            break;
    }
    
    if (resultCode == kLLPayResultSuccess) {
        _resolveBlock(dic);
    } else {
        _rejectBlock([NSString stringWithFormat:@"%d", resultCode], msg, nil);
    }
}

@end
  
