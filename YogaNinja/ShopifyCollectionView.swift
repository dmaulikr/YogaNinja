//
//  ShopifyCollectionView.swift
//  TVShop
//
//  Created by admin on 4/1/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Buy

private let reuseIdentifier = "Cell"

class ShopifyCollectionView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var catalog = [Item]()
    var selectedCell = [CatalogCell]()
    var selectedIndex = Int()
    
    let hostname = "yoganinja.myshopify.com"
    let apiKey = "3550fabec3d0bc375beca31e1b895ba6"
    let password = "578dd55eec8acb785ce6641c0173d86a"
    let query = "admin/products.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        activityIndicator.startAnimating()
        
        downloadData()
    }
    
    func downloadData() {
        
        // https://apikey:password@hostname/admin/
        
        let urlString = "https://\(apiKey):\(password)@\(hostname)/\(query)"
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){ (data, request, error) -> Void in
            
            if error != nil {
                print(error.debugDescription)
            } else {
                
                do {
                    
                    let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? Dictionary<String, AnyObject>
                    
                    if let results = dict!["products"] as? [Dictionary<String, AnyObject>]{
                        
                        for obj in results {
                            let item = Item(itemDict: obj)
                            self.catalog.append(item)
                        
                        }
                        
                        //Main UI thread
                        dispatch_async(dispatch_get_main_queue()) {
                            self.collectionView.reloadData()
                        }
                    }
                } catch {
                    
                }
            }
        }
        task.resume()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CatalogCell", forIndexPath: indexPath) as? CatalogCell {
            
            let item = catalog[indexPath.row]
            item.selectedCell = indexPath.row
            cell.configureCell(item)
            
            self.activityIndicator.stopAnimating()
            
            if cell.gestureRecognizers?.count == nil {
                let tap = UITapGestureRecognizer(target: self, action: #selector(ShopifyCollectionView.tapped(_:)))
                tap.allowedPressTypes = [NSNumber(integer: UIPressType.Select.rawValue)]
                cell.addGestureRecognizer(tap)
            }
            return cell
            
        } else {
            
            return CatalogCell()
        }
    }
    
    
    func tapped(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? CatalogCell {
            performSegueWithIdentifier("itemDetailsSegue", sender: cell)
        }
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalog.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(450, 541)
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.item
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let itemDetailsVC = segue.destinationViewController as? ItemDetailsView {
            
            if let theCell = sender as? CatalogCell {
                
                if let title = theCell.itemLbl.text {
                    itemDetailsVC.clickedItemTitle = title
                }
                if let image = theCell.itemImg.image {
                    itemDetailsVC.clickedImage = image
                }
                itemDetailsVC.clickedSideImage1 = theCell.sideImage1
                itemDetailsVC.clickedSideImage2 = theCell.sideImage2

                itemDetailsVC.clickedBrand = "Yoga Ninja"
                itemDetailsVC.clickedPrice = theCell.itemPrice
                itemDetailsVC.clickedItemCategory = theCell.itemDesc
                itemDetailsVC.clickedCell = theCell
                itemDetailsVC.clickedProductId = theCell.itemProductId
                
            }
        }
    }
}
