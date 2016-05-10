//
//  item.swift
//  TVShop
//
//  Created by admin on 1/2/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import Foundation

class Item {
    
    var title: String!
    var itemDescription: String!
    var itemImagePath: String!
    var sideImagePath1: String!
    var sideImagePath2: String!
    var price: String!
    var productId: String!
    
    var selectedCell = Int()
    
    
    init(itemDict: [String: AnyObject]) {
        
        if let title = itemDict["title"] as? String {
            self.title = title
        }
        
        if let descriptionOutput = itemDict["description"] as? String {
            let theString = NSString(string: descriptionOutput)
            
            if theString.containsString("&nbsp") {
                let trimString = theString.substringWithRange(NSRange(location: 3, length: theString.length - 13))
                self.itemDescription = trimString as String
            }
            else if theString.containsString("<p>") {
                let trimString = theString.substringWithRange(NSRange(location: 3, length: theString.length - 7))
                self.itemDescription = trimString as String
            }
        }
        
        if let priceOutput = itemDict["price"] as? String {
            self.price = priceOutput
        }
        
        if let images = itemDict["images"] as? [Dictionary<String, AnyObject>] {
            if let mainImage = images.first {
                if let src = mainImage["src"] as? String {
                    self.itemImagePath = src
                }
            }
            if 1  < images.count {
                if let src = images[1]["src"] as? String {
                    self.sideImagePath1 = src
                }
            }
            if 2  < images.count {
                if let src = images[2]["src"] as? String {
                    self.sideImagePath2 = src
                }
            }
        }
        
        if let bigPrice = itemDict["calculated_price"] as? String {
            
            let theString = NSString(string: bigPrice)
            
            if theString.containsString(".0000") {
                let trimString = theString.substringWithRange(NSRange(location: 0, length: theString.length - 2))
                self.price = trimString as String
            }
            
        }
        if let bigTitle = itemDict["name"] as? String {
            self.title = bigTitle
        }
        
        if let variants = itemDict["variants"] as? [Dictionary<String, AnyObject>] {
            let selectVariant = variants[0]
            if let shopifyPrice = selectVariant["price"] as? String {
                self.price = shopifyPrice
            }
            if let productId = selectVariant["product_id"] as? Int {
                self.productId = "\(productId)"
            }
        }
    }
}