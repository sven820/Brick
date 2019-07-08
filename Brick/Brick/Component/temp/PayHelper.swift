//
//  PayHelper.swift
//  Translator
//
//  Created by 靳小飞 on 2019/6/11.
//  Copyright © 2019 coco. All rights reserved.
//

import UIKit
import StoreKit

enum PayChannel: String {
    //iap
    case IAP = "IAP"
    //wx
    case WX_JSAPI = "WX_JSAPI"
    case WX_NATIVE = "WX_NATIVE"
    case WX_APP = "WX_APP"
    case WX_MWEB = "WX_MWEB"
    //alipay
    case ALIPAY_MOBILE = "ALIPAY_MOBILE"
    case ALIPAY_PC = "ALIPAY_PC"
    case ALIPAY_WAP = "ALIPAY_WAP"
    case ALIPAY_QR = "ALIPAY_QR"
    //other
    case GOOGLEPAY_APP = "GOOGLEPAY_APP"
    case MASERCARD_APP = "MASERCARD_APP"
    case VISA_APP = "VISA_APP"
    case PAYPAL_APP = "PAYPAL_APP"
    case CREDIT_CARD = "CREDIT_CARD"
}

enum PayChannelName: String {
    case WX = "WX"
    case ALIPAY = "ALIPAY"
}

struct IAPPayPersistence: Codable {
    var orderId = ""
    var receipt = ""
    var date: TimeInterval = 0
}

typealias PaySuccessHandle = (_ info: [String: Any]?)->Void
typealias PayFailHandle = (_ reason: String?, _ statusCode: Int?)->Void

class PayHelper: NSObject {
    static let helper = PayHelper()
    static let alipayScheme = "alipaybgttrans"
    
    var iapPayPersistences: [IAPPayPersistence] = [] //需要下次启动后验证
    var successHandle: PaySuccessHandle?
    var failHandle: PayFailHandle?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        SKPaymentQueue.default().remove(self)
    }
    
    override init() {
        super.init()
        
        SKPaymentQueue.default().add(self)
    }
}

// MARK: IAP
extension PayHelper: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func iapPayWith(_ id: String, successHandle: PaySuccessHandle?, failHandle: PayFailHandle?) {
        
        self.successHandle = successHandle
        self.failHandle = failHandle
        
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest.init(productIdentifiers: [id])
            request.delegate = self
            request.start()
        }else {
            self.failHandle?("您已禁止应用内付费购买, 请取消后重试", nil)
        }
    }
    
    func iapSaveLocalReceipt(_ iapPersistence: IAPPayPersistence) {
        
    }
    func iapRemoveLocalReceipt(_ iapPersistenceOrderIds: [String]) {
        
    }
    
    ///SKProductsRequestDelegate
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let pd = response.products.first else {
            self.failHandle?("无法获取产品信息，请重试", nil)
            return
        }
        let payment = SKPayment(product: pd)
        SKPaymentQueue.default().add(payment)
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        self.failHandle?(error.localizedDescription, nil)
    }
    ///SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for tr in transactions {
            switch tr.transactionState {
            case .failed:
                let error = tr.error as NSError?
                var reason = error?.localizedDescription ?? "购买失败，请重试"
                if error?.code == SKError.paymentCancelled.rawValue {
                    reason = "支付取消"
                }else if error?.code == SKError.paymentInvalid.rawValue {
                    reason = "支付无效"
                }else if error?.code == SKError.paymentNotAllowed.rawValue {
                    reason = "支付不被允许"
                }
                failHandle?(reason, nil)
                SKPaymentQueue.default().finishTransaction(tr)
                break
            case .deferred: //结果未确定
                break
            case .purchased: //交易完成
                if let url = Bundle.main.appStoreReceiptURL,
                    let receipt = try? Data(contentsOf: url) {
                    let receiptString = receipt.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
                    self.successHandle?(["receipt": receiptString])
                }
                SKPaymentQueue.default().finishTransaction(tr)
                break
            case .purchasing: //交易进行中，商品添加进列表
                break
            case .restored: //已经购买过该商品
                self.successHandle?(["result": "已经购买过该商品"])
                SKPaymentQueue.default().finishTransaction(tr)
                break
            @unknown default:
                print("other case")
            }
        }
    }
}

// MARK: alipay
extension PayHelper {
    
    func alipayWithOrderInfo(_ orderInfo: String, successHandle: PaySuccessHandle?, failHandle: PayFailHandle?) {
        
        self.successHandle = successHandle
        self.failHandle = failHandle
        
        AlipaySDK.defaultService()?.payOrder(orderInfo, fromScheme: PayHelper.alipayScheme, callback: nil)
    }
    
    func alipayOpenUrl(_ url: URL) {
        AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: { (result) in
            if let code = result?["resultStatus"] as? String {
                
                let resCode = Int(code) ?? -1
                var msg = result?["msg"] as? String
                
                if resCode == 9000 {
                    self.successHandle?(nil)
                    return
                }else if resCode == 8000 {
                    msg = msg ?? "正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态"
                }else if resCode == 4000 {
                    msg = msg ?? "订单支付失败"
                }else if resCode == 5000 {
                    msg = msg ?? "重复请求"
                }else if resCode == 6001 {
                    msg = msg ?? "用户中途取消"
                }else if resCode == 6002 {
                    msg = msg ?? "网络连接出错"
                }else if resCode == 6004 {
                    msg = msg ?? "支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态"
                }else {
                    msg = msg ?? "其它支付错误"
                }
                self.failHandle?(msg, nil)
            }
        })
    }
}
// MARK: wx
extension PayReq {
    
    @objc class func modelCustomPropertyMapper() -> [String: Any]? {
        return ["package": "packageValue"]
    }
}

extension PayHelper {
    
    func wxpayWithOrderInfo(_ orderInfo: String, successHandle: PaySuccessHandle?, failHandle: PayFailHandle?) {
        
        self.successHandle = successHandle
        self.failHandle = failHandle
        
        let payReq = PayReq.yy_model(withJSON: orderInfo)
        WXApi.send(payReq)
    }
    func wxPayWithResq(_ resq: PayResp) {
        if resq.errCode == WXSuccess.rawValue {
            self.successHandle?(nil)
        }else {
            var errorStr = "充值失败"
            if resq.errCode == WXErrCodeUserCancel.rawValue {
                errorStr = "充值取消"
            }else if resq.errCode == WXErrCodeSentFail.rawValue {
                errorStr = "发送失败"
            }else if resq.errCode == WXErrCodeAuthDeny.rawValue {
                errorStr = "授权失败"
            }else if resq.errCode == WXErrCodeUnsupport.rawValue {
                errorStr = "微信不支持"
            }else if resq.errCode == WXErrCodeCommon.rawValue {
                errorStr = "普通错误类型"
            }
            
            self.failHandle?(errorStr, Int(resq.errCode))
        }
    }
}

