//
//  InAppPurchaseManager.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 02/11/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import Foundation
import StoreKit

public protocol InAppPurchaseDelegate{
    func FoodPurchased()
    func FoodNotPurchased()
}

public class InAppPurchaseManager : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver{
    static let sharedInstance = InAppPurchaseManager()

    var productIDs: Array<String!> = []
    
    var productsArray: Array<SKProduct!> = []
    var transactionInProgress = false
    
    var purchaseDelegate:InAppPurchaseDelegate?
    
    override init() {
        super.init()
        productIDs.append("ALLFOOD")
        requestProductInfo()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        
    }

    public func BuyFood(delegate: InAppPurchaseDelegate) {
        purchaseDelegate = delegate
        for product in productsArray{
            if product.productIdentifier == "ALLFOOD"{
                let payment = SKPayment(product: product)
                SKPaymentQueue.defaultQueue().addPayment(payment)
                self.transactionInProgress = true
                return
            }
        }
        // if we get here we couldnt find the product
        purchaseDelegate?.FoodNotPurchased()
    }
    
    public func allFoodsBought() -> Bool{
        let storage = NSUserDefaults.standardUserDefaults()
        var allFoods:Bool = false
        if storage.objectForKey("AllFoods") != nil{
            allFoods = storage.boolForKey("AllFoods")
        }
        return allFoods
    }

    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    public func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product )
            }
        }
        else {
            print("There are no products.")
        }
    }
    
    public func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
//                let storage = NSUbiquitousKeyValueStore.defaultStore()
                let storage = NSUserDefaults.standardUserDefaults()
                storage.setBool(true, forKey: "AllFoods")
                let receiptURL = NSBundle.mainBundle().appStoreReceiptURL
                let req = NSURLRequest.init(URL: receiptURL!)
                let receipt = try? NSURLConnection.sendSynchronousRequest(req, returningResponse: nil)
                var savedReceipts = storage.arrayForKey("receipts")
                if savedReceipts == nil{
                    storage.setObject(receipt, forKey: "receipts")
                }else{
                    let updatedReceipts = savedReceipts?.append(receipt!) as! AnyObject
                    storage.setObject(updatedReceipts, forKey: "receipts")
                }
                storage.synchronize()
                purchaseDelegate?.FoodPurchased()
                break
                
            case SKPaymentTransactionState.Failed:
                print("Transaction Failed");
                let e:SKErrorCode = SKErrorCode(rawValue: (transaction.error?.code)!)!
                switch (e){
                case SKErrorCode.Unknown:
                    break
                    
                case SKErrorCode.ClientInvalid:
                    break
                    
                case SKErrorCode.PaymentCancelled:
                    break
                    
                case SKErrorCode.PaymentInvalid:
                    break
                    
                case SKErrorCode.PaymentNotAllowed:
                    break
                    
                case SKErrorCode.StoreProductNotAvailable:
                    break
                    
                default:
                    break
                }
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
                purchaseDelegate?.FoodNotPurchased()
                break
                
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }

}