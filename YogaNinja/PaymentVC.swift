//
//  PaymentVC.swift
//  TVShop
//
//  Created by admin on 4/13/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Buy
import Alamofire

class PaymentVC: UIViewController {
    
    @IBOutlet weak var enterPhoneLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    
    //Twilio credentials
    let basePath = "https://api.twilio.com/"
    let accountSID = "AC1b3adcaf8e9939fefd9c5964a720ce6d"
    let authToken = "34519c922259ad01317a092608cc43a7"
    let messageText = "Felix"
    let twilioPhoneNumber = "2018905326"
    
    //Shopify credentials
    let shopDomain = "yoganinja.myshopify.com"
    let apiKey = "706f85f7989134d8225e2ec4da7335b8"
    let channelId = "49743622"
    
    //Google Tiny-URL credentials
    let tinyApiKey = "AIzaSyCzJ1nS8knmHKeu3iOclTFSZ3JhUBamFvM"
    let apiURL = "https://www.googleapis.com/urlshortener/v1/url"
    
    var productVariant: BUYProductVariant?
    let client: BUYClient
    let cart = BUYCart()
    
    required init(coder aDecoder: NSCoder) {
        
        client = BUYClient(shopDomain: shopDomain, apiKey: apiKey, channelId: channelId)
        super.init(coder: aDecoder)!
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var selectedVariant = 1
        
        if let invoiceList = NSUserDefaults.standardUserDefaults().objectForKey("savedItems") {
            
            if let arr = invoiceList as? [Dictionary<String, AnyObject>] {
                
                /////////////
                for item in arr {
                    var productQty = 1
                    if let qty = item["qty"] as? Int {
                        productQty = qty
                    }
                    
                    if let itemCell = item["cell"] as? [String: AnyObject] {
                        if let itemId = itemCell["productId"] as? String {
                            
                            
                            client.getProductById(itemId) { (product, error) -> Void in
                                
                                if let size = item["size"] as? String {
                                    switch size {
                                    case "Small":
                                        selectedVariant = 0
                                    case "Medium":
                                        selectedVariant = 1
                                    case "Large":
                                        selectedVariant = 2
                                    case "Extra Large":
                                        selectedVariant = 3
                                    default:
                                        selectedVariant = 0
                                    }
                                    
                                    if let variants = product.variants as? [BUYProductVariant] {
                                        self.productVariant = variants[selectedVariant]
                                        
                                        while productQty > 0 {
                                            if let productVar = self.productVariant {
                                                self.cart.addVariant(productVar)
                                                productQty -= 1
                                            }
                                        }
                                    }
                        }   }   }
                    }
                }
            }
        }
    }
    
    
    @IBAction func payButton(sender: AnyObject) {
        
        let checkout = BUYCheckout(cart: cart)
        client.createCheckout(checkout) { (checkout, error) -> Void in
            
            //create shortURL
            let parameters = [
                "longUrl": "\(checkout.webCheckoutURL)"
            ]
            
            Alamofire.request(.POST, "https://www.googleapis.com/urlshortener/v1/url?key=\(self.tinyApiKey)", parameters: parameters, encoding: .JSON)
                .responseJSON { Response in
                    if let output = Response.result.value as? Dictionary<String, AnyObject> {
                        
                        if let urlOutput = output["id"] as? String {
                            let txtMessage = "Welcome to Yoga Ninja!  Please click on link to make payment: \(urlOutput)"
                            self.sendText(txtMessage)
                        }
                    }
            }
            
        }
    }
    
    func sendText(message: String) {
        
        if let phoneNumber = self.phoneTextField.text {
            let charCount = phoneNumber.characters.count
            if charCount < 10 {
                //Need an alert to do this!
                enterPhoneLabel.text = "Please enter a valid phone number"
            } else {
                enterPhoneLabel.text = ""
                let fromNumber = "%2B1\(self.twilioPhoneNumber)"
                let toNumber = "%2B1\(phoneNumber)"
                
                // Build the request
                let request = NSMutableURLRequest(URL: NSURL(string:"https://\(self.accountSID):\(self.authToken)@api.twilio.com/2010-04-01/Accounts/\(self.accountSID)/SMS/Messages")!)
                request.HTTPMethod = "POST"
                request.HTTPBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".dataUsingEncoding(NSUTF8StringEncoding)
                
                NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                    if let data = data, responseDetails = NSString(data: data, encoding: NSUTF8StringEncoding) {
                        print("Text sent")
                    } else {
                        print("Error: \(error)")
                    }
                }).resume()
                
                let alertText = "Text message sent to \(phoneNumber). Please check your message to complete the payment!"
                let alertController = UIAlertController(title: "Payment Text Sent!", message: alertText, preferredStyle: .Alert)
                let ok = UIAlertAction(title: "OK", style: .Default) { (action) in
                    self.performSegueWithIdentifier("continueShopping", sender: self)
                }
                alertController.addAction(ok)
                self.presentViewController(alertController, animated: true) {
                }
            }
        } else {
            //Need an alert to do this!
            enterPhoneLabel.text = "Please enter a phone number"
        }
    }
    
}
