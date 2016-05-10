//
//  ShoppingCartCell.swift
//  TVShop
//
//  Created by admin on 3/6/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class ShoppingCartCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cellTotalLabel: UILabel!
    
    var cartCellTitle = String()
    var cartCellPrice = String()
    var cellImagePath = String()
    var cellSideImagePath1 = String()
    var cellSideImagePath2 = String()
    var cartCellImage = UIImage()
    var cartCellSideImage1 = UIImage()
    var cartCellSideImage2 = UIImage()
    var productId = String()
    
    override func canBecomeFocused() -> Bool {
        return true
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        if context.nextFocusedView == self {
            
            coordinator.addCoordinatedAnimations({ () -> Void in
                
                self.layer.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.1).CGColor
                
                }, completion: nil)
            
        } else if context.previouslyFocusedView == self {
            
            coordinator.addCoordinatedAnimations({ () -> Void in
                
                self.layer.backgroundColor = UIColor.clearColor().CGColor
                
                }, completion: nil)
        }
    }
    
    
    func setCell(row: Int) {
        
        if let returnedArray = NSUserDefaults.standardUserDefaults().objectForKey("savedItems") {
            
            var arr = returnedArray as! [Dictionary<String, AnyObject>]
            let output: [String: AnyObject] = arr[row]
            var cellQty = 0.00
            var cellPrice = 0.00
            var cellTotal = 0.00
            
            if let qty = output["qty"] as? Int {
                qtyLabel.text = String(qty)
                cellQty = Double(qty)
            }
            if let size1 = output["size"] as? String {
                sizeLabel.text = size1
            }
            if let cell = output["cell"] as? [String: AnyObject] {
                if let title = cell["title"] as? String {
                    titleLabel.text = title
                    cartCellTitle = title
                }
                if let price = cell["price"] as? String {
                    priceLabel.text = price
                    cellPrice = Double(price)!
                    cartCellPrice = price
                    
                }
                if let selectedCell = cell["productId"] as?  String {
                    productId = selectedCell
                }
                
                if let imagePath = cell["image"] as? String {
                    cellImagePath = imagePath
                    
                    if let urlNS = NSURL(string: imagePath) {
                        
                        self.getImage(urlNS) { (data, response, error)  in
                            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                guard let data = data where error == nil else { return }
                                if let downloadedImage = UIImage(data: data){
                                    self.imageView.image = downloadedImage
                                    self.cartCellImage = downloadedImage
                                }
                            }
                        }
                    }
                }
                if let imagePath = cell["sideImage1"] as? String {
                    cellSideImagePath1 = imagePath
                    if let urlNS = NSURL(string: imagePath) {
                        
                        self.getImage(urlNS) { (data, response, error)  in
                            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                guard let data = data where error == nil else { return }
                                if let downloadedImage = UIImage(data: data){
                                    self.cartCellSideImage1 = downloadedImage
                                }
                            }
                        }
                    }
                }
                if let imagePath = cell["sideImage2"] as? String {
                    cellSideImagePath2 = imagePath
                    if let urlNS = NSURL(string: imagePath) {
                        
                        self.getImage(urlNS) { (data, response, error)  in
                            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                guard let data = data where error == nil else { return }
                                if let downloadedImage = UIImage(data: data){
                                    self.cartCellSideImage2 = downloadedImage
                                }
                            }
                        }
                    }
                    
                }
                cellTotal = cellQty * cellPrice
                cellTotalLabel.text = "$\(cellTotal)0"
            }
        }
    }
    func getImage(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
}
