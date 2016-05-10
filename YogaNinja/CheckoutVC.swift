//
//  CheckoutVC.swift
//  TVShop
//
//  Created by admin on 2/28/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class CheckoutVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    var selectedIndex = Int()
    
    
    @IBAction func clearList(sender: AnyObject) {
        
        
        let alertMsg = "Would you like to delete all items?"
        let alertController = UIAlertController(title: "Clear Cart", message: alertMsg, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        let deleteItem = UIAlertAction(title: "Delete All", style: .Default) { (action) in
            NSUserDefaults.standardUserDefaults().removeObjectForKey("savedItems")
            self.subtotalLabel.text = "0.00"
            self.shippingLabel.text = "0.00"
            self.totalCostLabel.text = "0.00"
            self.collectionView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteItem)
        
        self.presentViewController(alertController, animated: true) {
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        calculateTotal()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.collectionView.reloadData()
        calculateTotal()
    }
    
    func tapped(gesture: UITapGestureRecognizer) {
        
        if let tappedCell = gesture.view as? ShoppingCartCell {
            
            if let indexPath = self.collectionView!.indexPathForCell(tappedCell) {
                selectedIndex = indexPath.row
            }
            
            let alertMessage = "Would you like to edit selected item?"
            
            let alertController = UIAlertController(title: "Edit Cart", message: alertMessage, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            }
            let editItem = UIAlertAction(title: "Edit Item", style: .Default) { (action) in
                if let itemToEdit = NSUserDefaults.standardUserDefaults().objectForKey("savedItems") {
                    var arr = itemToEdit as! [Dictionary<String, AnyObject>]
                    arr.removeAtIndex(self.selectedIndex)
                    NSUserDefaults.standardUserDefaults().setObject(arr, forKey: "savedItems")
                    self.collectionView.reloadData()
                }
                self.performSegueWithIdentifier("editItem", sender: tappedCell)
            }
            let deleteItem = UIAlertAction(title: "Delete Item", style: .Default) { (action) in
                
                if let itemToDelete = NSUserDefaults.standardUserDefaults().objectForKey("savedItems") {
                    var arr = itemToDelete as! [Dictionary<String, AnyObject>]
                    arr.removeAtIndex(self.selectedIndex)
                    NSUserDefaults.standardUserDefaults().setObject(arr, forKey: "savedItems")
                    self.collectionView.reloadData()
                }
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(editItem)
            alertController.addAction(deleteItem)
            
            self.presentViewController(alertController, animated: true) {
            }
        }
    }
    
    func calculateTotal() {
        
        if let cartArray = NSUserDefaults.standardUserDefaults().objectForKey("savedItems") {
            
            let arr = cartArray as! [Dictionary<String, AnyObject>]
            
            var subtotalCost = 0.00
            let shipping = 8.00
            var totalCost = 0.00
            
            for output in arr {
                
                var sumQty = 0
                var cost = 0.00
                var cellCost = 0.00
                
                if let qty = output["qty"] as? Int {
                    sumQty = qty
                }
                
                if let size = output["cell"] as? [String: AnyObject] {
                    if let price = size["price"] as? String {
                        cost = Double(price)!
                    }
                }
                cellCost = Double(sumQty) * cost
                subtotalCost = subtotalCost + cellCost
                totalCost = subtotalCost + shipping
                shippingLabel.text = "\(shipping)0"
                subtotalLabel.text = "\(subtotalCost)0"
                totalCostLabel.text = "\(totalCost)0"
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("checkoutCell", forIndexPath: indexPath) as? ShoppingCartCell {
            
            cell.setCell(indexPath.row)
            
            if cell.gestureRecognizers?.count == nil {
                let tap = UITapGestureRecognizer(target: self, action: #selector(CheckoutVC.tapped(_:)))
                tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
                cell.addGestureRecognizer(tap)
            }
            
            return cell
        } else {
            
            return ShoppingCartCell()
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let returnedArray = NSUserDefaults.standardUserDefaults().objectForKey("savedItems") {
            
            let arr = returnedArray as! [Dictionary<String, AnyObject>]
            return arr.count
        } else {
            return 0
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let itemDetailsVC = segue.destinationViewController as? ItemDetailsView {
            
            if let cartCell = sender as? ShoppingCartCell {
                
                itemDetailsVC.clickedItemTitle = cartCell.cartCellTitle
                
                itemDetailsVC.clickedImage = cartCell.cartCellImage
                itemDetailsVC.clickedSideImage1 = cartCell.cartCellSideImage1
                itemDetailsVC.clickedSideImage2 = cartCell.cartCellSideImage2
                itemDetailsVC.clickedBrand = "Yoga Ninja"
                itemDetailsVC.clickedPrice = cartCell.cartCellPrice
                itemDetailsVC.clickedItemCategory = cartCell.cartCellTitle
                itemDetailsVC.clickedCell.imagePath = cartCell.cellImagePath
                itemDetailsVC.clickedCell.sideImagePath1 = cartCell.cellSideImagePath1
                itemDetailsVC.clickedCell.sideImagePath2 = cartCell.cellSideImagePath2
                itemDetailsVC.clickedProductId = cartCell.productId
                
            }
        }
    }
}
