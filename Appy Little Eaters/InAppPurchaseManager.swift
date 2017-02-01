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

open class InAppPurchaseManager : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver{
    static let sharedInstance = InAppPurchaseManager()

    var productIDs: Array<String?> = []
    
    var productsArray: Array<SKProduct?> = []
    var transactionInProgress = false
    
    var purchaseDelegate:InAppPurchaseDelegate?
    
    override init() {
        super.init()
        productIDs.append("ALLFOOD")
        requestProductInfo()
        SKPaymentQueue.default().add(self)
        
    }

    open func BuyFood(_ delegate: InAppPurchaseDelegate) {
        purchaseDelegate = delegate
        for product in productsArray{
            if product?.productIdentifier == "ALLFOOD"{
                let payment = SKPayment(product: product!)
                SKPaymentQueue.default().add(payment)
                self.transactionInProgress = true
                return
            }
        }
        // if we get here we couldnt find the product
        purchaseDelegate?.FoodNotPurchased()
    }
    
    open func allFoodsBought() -> Bool{
        let storage = UserDefaults.standard
        var allFoods:Bool = false
        if storage.object(forKey: "AllFoods") != nil{
            allFoods = storage.bool(forKey: "AllFoods")
        }
        return allFoods
    }
    
    open func setFoodsBought(){
        let storage = UserDefaults.standard
        storage.set(true, forKey: "AllFoods")
    }
    
    open func setFoodsNotBought(){
        let storage = UserDefaults.standard
        storage.set(false, forKey: "AllFoods")
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
    
    open func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product )
            }
        }
        else {
            print("There are no products.")
        }
    }
    
    open func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
//                let storage = NSUbiquitousKeyValueStore.defaultStore()
                let storage = UserDefaults.standard
                storage.set(true, forKey: "AllFoods")
                let receiptURL = Bundle.main.appStoreReceiptURL
                let req = URLRequest.init(url: receiptURL!)
                let receipt = try? NSURLConnection.sendSynchronousRequest(req, returning: nil)
                var savedReceipts = storage.array(forKey: "receipts")
                if savedReceipts == nil{
                    storage.set(receipt, forKey: "receipts")
                }else{
                    let updatedReceipts = savedReceipts?.append(receipt!) as AnyObject
                    storage.set(updatedReceipts, forKey: "receipts")
                }
                storage.synchronize()
                purchaseDelegate?.FoodPurchased()
                break
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed");
                print(transaction.error.debugDescription)
                print(transaction.error?.localizedDescription)
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                purchaseDelegate?.FoodNotPurchased()
                break
                
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }

}
