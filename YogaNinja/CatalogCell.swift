//
//  CatalogCell.swift
//  TVShop
//
//  Created by admin on 1/2/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class CatalogCell: UICollectionViewCell {
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var itemLbl: UILabel!
    
    var itemDesc = ""
    var itemBrand = ""
    var itemPrice = ""
    var itemProductId = ""
    var imagePath = ""
    var sideImagePath1 = ""
    var sideImagePath2 = ""
    var selectedIndex = Int()
    var qtyInCart = Int()
    var sideImage1 = UIImage()
    var sideImage2 = UIImage()
    
    func configureCell(item: Item) {
        
        if let title = item.title {
            itemLbl.text = title
        }
        
        if let image = item.itemImagePath {
            imagePath = image
            if let urlNS = NSURL(string: image) {
                self.getDataFromUrl(urlNS) { (data, response, error)  in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        guard let data = data where error == nil else { return }
                        if let downloadedImage = UIImage(data: data){
                            self.itemImg.image = downloadedImage
                        }
                    }
                }
            }
            itemImg.image = UIImage(named: image)
        }
        
        if let sideImage = item.sideImagePath1 {
            sideImagePath1 = sideImage
            if let urlNS = NSURL(string: sideImage) {
                self.getDataFromUrl(urlNS) { (data, response, error)  in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        guard let data = data where error == nil else { return }
                        if let downloadedImage = UIImage(data: data){
                            self.sideImage1 = downloadedImage
                        }
                    }
                }
            }
        }
        if let sideImage2 = item.sideImagePath2 {
            sideImagePath2 = sideImage2
            if let urlNS = NSURL(string: sideImage2) {
                self.getDataFromUrl(urlNS) { (data, response, error)  in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        guard let data = data where error == nil else { return }
                        if let downloadedImage = UIImage(data: data){
                            self.sideImage2 = downloadedImage
                        }
                    }
                }
            }
        }
        if let itemText = item.itemDescription {
            itemDesc = itemText
        }
        
        if let itemPrice1 = item.price {
            itemPrice = itemPrice1
        }
        if let theSKUId = item.productId {
            itemProductId = theSKUId
        }
        selectedIndex = item.selectedCell
        
    }

    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
}