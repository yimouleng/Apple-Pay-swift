//
//  ViewController.swift
//  Apple Pay-swift
//
//  Created by Eli on 16/5/27.
//  Copyright © 2016年 Ely. All rights reserved.
//

import UIKit
import PassKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //判断设备是否支持Apple Pay
        if !PKPaymentAuthorizationViewController.canMakePayments()
        {
            print("不支持Apple Pay")
        // 判断是否添加了银行卡
        }else if !PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks([PKPaymentNetworkVisa, PKPaymentNetworkChinaUnionPay])
        {
             //创建跳转按钮
            let btn = PKPaymentButton.init(type: PKPaymentButtonType.SetUp, style: PKPaymentButtonStyle.WhiteOutline)
            btn.addTarget(self, action: #selector(ViewController.jumpBankCard), forControlEvents: UIControlEvents.TouchUpInside)
            btn.frame = CGRect(x: 100, y: 100, width: 100, height: 20)
            view.addSubview(btn)
            
        }else
        {
            //创建支付按钮
            let btn = PKPaymentButton.init(type: PKPaymentButtonType.Buy, style: PKPaymentButtonStyle.Black)
            btn.addTarget(self, action: #selector(ViewController.buyShop), forControlEvents: UIControlEvents.TouchUpInside)
            btn.frame = CGRect(x: 100, y: 100, width: 100, height: 20)
            view.addSubview(btn)
        }
    }
    //跳转添加银行卡页面
    func jumpBankCard(){
        PKPassLibrary().openPaymentSetup()
        print("跳转设置界面")
    }
    //购买
    func buyShop(){
         print("开始购买")
         //1.创建支付请求
        let request = PKPaymentRequest()
        //2.配置商家ID
        request.merchantIdentifier = "yimouelng.com";
        //3.配置货币代码和国家代码
        request.countryCode = "CN";
        request.currencyCode = "CNY";
        //4.配置请求支持的支付网络
        request.supportedNetworks = [PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
        //5.配置处理方式
        request.merchantCapabilities = PKMerchantCapability.Capability3DS
        //6.配置购买的商品列表 注意支付列表最后一个代表总和 注意名称和价钱
        let num = NSDecimalNumber.init(string:"988")

        let item = PKPaymentSummaryItem.init(label: "商品", amount: num)
        request.paymentSummaryItems  = [item]
        
        
        //--------附加选项(选填) --------
        request.requiredBillingAddressFields = PKAddressField.All//添加收货地址
        
        request.requiredShippingAddressFields = PKAddressField.All//运输地址
        
        //添加快递
        let price = NSDecimalNumber.init(string:"988")
        let method = PKShippingMethod.init(label: "顺丰", amount: price)
        method.identifier = "sf"
        method.detail = "货到付款"//备注
        request.shippingMethods = [method]
        
        request.applicationData = "id = 1" .dataUsingEncoding(NSUTF8StringEncoding)//添加附加数据
        
        //7.验证用户的支付请求并跳转支付页面
        let  auth = PKPaymentAuthorizationViewController.init(paymentRequest: request)
        self.presentViewController(auth, animated: true, completion: nil)
    }
    
}



