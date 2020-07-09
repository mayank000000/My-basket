
import UIKit
import SwiftIcons
import MessageUI
import Alamofire
import Realm
import RealmSwift
import CoreData

class DeliveryViewController: BaseVC{
    var orderArray:[ObjOrder] = [ObjOrder]()
    var userEmail = ""
    var total = ""
    var orderList = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.userEmail = HelperFunction.helper.FetchFromUserDefault(name: "email")
        
        for order in orderArray{
            orderList = orderList + "<h4 style=\"color:blue;\">\(order.title!) - $\(order.price!)"
        }
        orderList = orderList + "<h3 style=\"color:red;\">Total: \(total)</h3>"
        print(orderList)
        self.sendEmail()
        self.sendEmailToOwner()
        // Do any additional setup after loading the view.
    }
    
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
           self.navigationController?.setNavigationBarHidden (true, animated: false)
          
       }
 
    @IBAction func buttonHandlerFInish(_ sender: Any) {
        
   let homeVC = loadVC(storyboardMain, viewImageDisplayerVC) as! ImageDisplayerViewController
                                  self.navigationController?.pushViewController(homeVC, animated: true)
                              
    }
    
    
    func sendEmailToOwner() {
        
        var html = "<h4 style=\"color: #5e9ca0;\"><strong>&nbsp;Hey Foodie...,</strong></h4><h2 id=\"home-enter-address-title\" class=\"b4 b5 b6 c1 c2 c3 c4 c5\"><span style=\"color: #000080;\">Sensational Chicken - New Order Received</span></h2><h4><span style=\"color: #ff6600;\">Please start to cook for following recipes:\(orderList)</span></h4><h2 class=\"box__title\"><strong><span style=\"color: #800000;\">Order</span></strong></h2><div class=\"box__body\"><h4 class=\"sc-dRaagA dZtcIM sc-czDwQe dsTmXT\">Order is confirmed</h4></div><h2 class=\"sc-cjHlYL jmwEsc sc-dJyloi hnELNK\"><span style=\"color: #800000;\">Anywhere you are</span></h2><h4 class=\"sc-dRaagA dZtcIM sc-czDwQe dsTmXT\">Go and Pick it Save your time.</h4><h2 style=\"color: #2e6c80;\">How can you get it:</h2><ol style=\"list-style: none; font-size: 14px; line-height: 32px; font-weight: bold;\"><li style=\"clear: both;\"><img style=\"float: left;\" src=\"https://html-online.com/img/01-interactive-connection.png\" alt=\"interactive connection\" width=\"45\" />Choose your dish</li><li style=\"clear: both;\"><img style=\"float: left;\" src=\"https://html-online.com/img/02-html-clean.png\" alt=\"html cleaner\" width=\"45\" />Prepare it as you want</li><li style=\"clear: both;\"><img style=\"float: left;\" src=\"https://html-online.com/img/05-gibberish.png\" alt=\"gibberish\" width=\"45\" /> Order it</li><li style=\"clear: both;\"><img style=\"float: left;\" src=\"https://html-online.com/img/6-table-div-html.png\" alt=\"html table div\" width=\"45\" /> Get Order confirm<strong>&nbsp;</strong></li><li style=\"clear: both;\"></li></ol><p><strong>You like it then share it with your friends. </strong><br /><strong>Enjoy!</strong></p><p><strong>&nbsp;</strong></p>"
        
        
        let send = ["name":"Sensational Chicken","email":"seb.munshi@gmail.com"]
        let to = ["name":"Foodie","email":"seb.munshi@gmail.com"]//HERE YOU CAN CHANGE OWNER EMAIL
        let dic = ["sender":send,
                    "to":[to],
                    "htmlContent":html,
                    "subject":"Sensational Chicken - New Order placed",
                    "replyTo":send] as [String : Any]
        
        
        
        print(dic)
        let urlSignIn = "https://api.sendinblue.com/v3/smtp/email"
        let headers: HTTPHeaders = [
        "accept": "application/json",
        "api-key":" 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",
        "content-type":"application/json"]
     
        let json = dic.json

        let url = URL(string: urlSignIn)!
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = headers
        //request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        Alamofire.request(request).responseJSON {
            (response) in

            print(response)
            
            guard let responseDic = response.value as? [String:Any] else{
                            print("Please try again later")
                            return
         
        }
            guard let messageId = responseDic["messageId"] as? String else{
                                      print("Please try again later")
                                      return
                   
                  }
            
           print(messageId)
        }
        showAlertWithTitleWithMessage(message: "Please check your email for more details")
    }
    func sendEmail() {
        
        let html = "<h4 style=\"color: #5e9ca0;\"><strong>&nbsp;Hey Buddy...,</strong></h4><h2 id=\"home-enter-address-title\" class=\"b4 b5 b6 c1 c2 c3 c4 c5\"><span style=\"color: #000080;\">Welcome to My Basket where we have made grocery shopping easier than ever. Only the finest products and fresh vegetables!</span></h2><h4><span style=\"color: #ff6600;\">The Best App for buying Grocery from anywhere you are:):):):)\(orderList)</span></h4><h2 class=\"box__title\"><strong><span style=\"color: #800000;\">Order</span></strong></h2><div class=\"box__body\"><h4 class=\"sc-dRaagA dZtcIM sc-czDwQe dsTmXT\"></h4></div><h2 class=\"sc-cjHlYL jmwEsc sc-dJyloi hnELNK\"><span style=\"color: #800000;\">Anywhere you are</span></h2><h4 class=\"sc-dRaagA dZtcIM sc-czDwQe dsTmXT\">Easy order confirmation.</h4><h2 style=\"color: #2e6c80;\">How can you get it:</h2><ol style=\"list-style: none; font-size: 14px; line-height: 32px; font-weight: bold;\"><li style=\"clear: both;\"><img style=\"float: left;\" src=\"https://html-online.com/img/01-interactive-connection.png\" alt=\"interactive connection\" width=\"45\" />Choose your Items</li><li style=\"clear: both;\"><img style=\"float: left;\" src=\"https://html-online.com/img/02-html-clean.png\" alt=\"html cleaner\" width=\"45\" />Give us a time</li><li style=\"clear: both;\"><img style=\"float: left;\" src=\"https://html-online.com/img/05-gibberish.png\" alt=\"gibberish\" width=\"45\" /> Order it</li><li style=\"clear: both;\"><img style=\"float: left;\" src=\"https://html-online.com/img/6-table-div-html.png\" alt=\"html table div\" width=\"45\" /> Get Order confirm<strong>&nbsp;</strong></li><li style=\"clear: both;\"></li></ol><p><strong></strong><br /><strong>Enjoy!</strong></p><p><strong>&nbsp;</strong></p>"
        
        
        if self.userEmail == "" || self.userEmail == "admin"{
            self.userEmail = "seb.munshi@gmail.com"
        }else{
            
        }
        let send = ["name":"My Basket","email":"seb.munshi@gmail.com"]
        let to = ["name":"Buddy","email":self.userEmail]
        let dic = ["sender":send,
                    "to":[to],
                    "htmlContent":html,
                    "subject":"My Basket - Order successfully placed",
                    "replyTo":send] as [String : Any]
        
        
        
        print(dic)
        let urlSignIn = "https://api.sendinblue.com/v3/smtp/email"
        let headers: HTTPHeaders = [
        "accept": "application/json",
        "api-key":" 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",
        "content-type":"application/json"]
     
        let json = dic.json

        let url = URL(string: urlSignIn)!
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = headers
        //request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        Alamofire.request(request).responseJSON {
            (response) in

            print(response)
            
            guard let responseDic = response.value as? [String:Any] else{
                            print("Please try again later")
                            return
         
        }
            guard let messageId = responseDic["messageId"] as? String else{
                                      print("Please try again later")
                                      return
                   
                  }
            
           print(messageId)
        }
        showAlertWithTitleWithMessage(message: "Please check your email for more details")
    }
    
  
    
}
extension Dictionary {

    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }

    func printJson() {
        print(json)
    }

}
