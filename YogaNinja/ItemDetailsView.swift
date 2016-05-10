//
//  ItemDetailsView.swift
//  TVShop
//
//  Created by admin on 1/5/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class ItemDetailsView: UIViewController {
    
    @IBOutlet var sideImageView: FocusView!
    @IBOutlet var sideImage1View: FocusView!
    @IBOutlet var sideImage2View: FocusView!
    @IBOutlet var image: UIImageView!
    @IBOutlet var sideImage: UIImageView!
    @IBOutlet var sideImage1: UIImageView!
    @IBOutlet var sideImage2: UIImageView!
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var brand: UILabel!
    @IBOutlet var productCategory: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet weak var smLabel: UIButton!
    @IBOutlet weak var mdLabel: UIButton!
    @IBOutlet weak var lgLabel: UIButton!
    @IBOutlet weak var xlLabel: UIButton!
    @IBOutlet weak var qtyEntered: UITextField!
    
    @IBOutlet weak var cartQTYLabel: UILabel!
    
    var selectedSize = ""
    
    var clickedImage = UIImage()
    var clickedSideImage1 = UIImage()
    var clickedSideImage2 = UIImage()
    var clickedItemTitle = ""
    var clickedBrand = ""
    var clickedItemCategory = ""
    var clickedPrice = ""
    var clickedProductId = ""
    var clickedCell = CatalogCell()
    
    @IBAction func smButton(sender: AnyObject) {
        selectedSize = "Small"
        smLabel.backgroundColor = UIColor.blackColor()
        mdLabel.backgroundColor = UIColor.whiteColor()
        lgLabel.backgroundColor = UIColor.whiteColor()
        xlLabel.backgroundColor = UIColor.whiteColor()
    }
    @IBAction func mdButton(sender: AnyObject) {
        selectedSize = "Medium"
        mdLabel.backgroundColor = UIColor.blackColor()
        smLabel.backgroundColor = UIColor.whiteColor()
        lgLabel.backgroundColor = UIColor.whiteColor()
        xlLabel.backgroundColor = UIColor.whiteColor()
    }
    @IBAction func lgButton(sender: AnyObject) {
        selectedSize = "Large"
        lgLabel.backgroundColor = UIColor.blackColor()
        smLabel.backgroundColor = UIColor.whiteColor()
        mdLabel.backgroundColor = UIColor.whiteColor()
        xlLabel.backgroundColor = UIColor.whiteColor()
    }
    @IBAction func xlButton(sender: AnyObject) {
        selectedSize = "Extra Large"
        xlLabel.backgroundColor = UIColor.blackColor()
        smLabel.backgroundColor = UIColor.whiteColor()
        mdLabel.backgroundColor = UIColor.whiteColor()
        lgLabel.backgroundColor = UIColor.whiteColor()
    }
    @IBAction func addToCart(sender: AnyObject) {
        if selectedSize == "" {
            let alertText = "Please select a size to add to cart!"
            cartQTYLabel.text = alertText
            
            let alertController = UIAlertController(title: "Select Size", message: alertText, preferredStyle: .Alert)
            let ok = UIAlertAction(title: "OK", style: .Default) { (action) in
            }
            alertController.addAction(ok)
            
            self.presentViewController(alertController, animated: true) {
            }
            
        } else {
            
            if var cartQTY = qtyEntered.text {
                if cartQTY == "" || cartQTY == "0" {
                    cartQTY = "1"
                }
                
                if let floatingPrice = Float(clickedPrice) {
                    
                    let subtotal = floatingPrice * Float(cartQTY)!
                    cartQTYLabel.text = "QTY in your Cart \(cartQTY).  Subtotal = $\(subtotal)0"
                    let imagePath = clickedCell.imagePath
                    let sideImagePath1 = clickedCell.sideImagePath1
                    let sideImagePath2 = clickedCell.sideImagePath2
                    let cellInfo: [String: AnyObject] = ["image": imagePath, "sideImage1": sideImagePath1, "sideImage2": sideImagePath2, "title": clickedItemTitle, "price": clickedPrice, "brand": clickedBrand, "productId": clickedProductId]
                    let qty = Int(cartQTY)!
                    let size = selectedSize
                    let itemAttributes: [String: AnyObject] = ["cell": cellInfo, "size": size, "qty": qty]
                    
                    if let returnedArray = NSUserDefaults.standardUserDefaults().objectForKey("savedItems") {
                        var arr = returnedArray as! [Dictionary<String, AnyObject>]
                        arr.append(itemAttributes)
                        NSUserDefaults.standardUserDefaults().setObject(arr, forKey: "savedItems")
                    } else {
                        var newArray: [Dictionary<String, AnyObject>] = []
                        newArray.append(itemAttributes)
                        NSUserDefaults.standardUserDefaults().setObject(newArray, forKey: "savedItems")
                    }
                    
                    let alertText = "Selected item QTY \(cartQTY) was added to your Cart.  Subtotal = $\(subtotal)0"
                    let alertController = UIAlertController(title: "Item Added to Cart", message: alertText, preferredStyle: .Alert)
                    let ok = UIAlertAction(title: "OK", style: .Default) { (action) in
                    }
                    alertController.addAction(ok)
                    
                    self.presentViewController(alertController, animated: true) {
                    }
                }
                
            } else {
                let cartQTY = 1
                let subtotal = Float(clickedPrice)! * Float(cartQTY)
                if cartQTYLabel.text != nil {
                    cartQTYLabel.text = "QTY in your Cart \(cartQTY).   Subtotal = $\(subtotal)0"
                }
            }
        }
    }
    @IBAction func clearCart(sender: AnyObject) {
        
        qtyEntered.text = "0"
        let subtotal = 0
        cartQTYLabel.text = "QTY in your Cart \(clickedCell.qtyInCart).   Subtotal = $\(subtotal)0"
    }
    
    @IBAction func checkout(sender: AnyObject) {
        if selectedSize == "" {
            cartQTYLabel.text = "Please select a size."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = clickedImage
        sideImage.image = clickedImage
        sideImage1.image = clickedSideImage1
        sideImage2.image = clickedSideImage2
        itemTitle.text = clickedItemTitle
        brand.text = clickedBrand
        productCategory.text = clickedItemCategory
        price.text = clickedPrice
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
        
        if sideImageView.focused == true {
            image.image = clickedImage
        }
        if sideImage1View.focused == true {
            image.image = clickedSideImage1
        }
        if sideImage2View.focused == true {
            image.image = clickedSideImage2
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //        if let checkoutView = segue.destinationViewController as? CheckoutVC {
        //
        //
        //        }
    }
}
