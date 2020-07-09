//
//  OrderListViewController.swift
//  App
//
//  Created by Sehbaz Munshi on 15/12/2019.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import CoreData
import SwiftIcons

class OrderListViewController: BaseVC,UITableViewDataSource,UITableViewDelegate {
 var arrayDish = [NSManagedObject]()
    @IBOutlet weak var listTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden (false, animated: false)
        self.setNavigationbarleft_imagename(left_icon_Name: nil, left_action: nil,
                                            right_icon_Name: IoniconsType.logOut,
                                            right_action: #selector(self.btnBackHandle(_:)),
                                            title: "Order List")
        listTableView.delegate = self
        listTableView.dataSource = self
        
        listTableView.register(UINib(nibName: "OrderListTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderListTableViewCell")
        listTableView.estimatedRowHeight = 140
        listTableView.rowHeight = UITableViewAutomaticDimension
        self.fetchData()
        // Do any additional setup after loading the view.
    }
    func fetchData(){
              self.arrayDish.removeAll()
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
              let context = appDelegate.persistentContainer.viewContext
              let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
              request.returnsObjectsAsFaults = false
              do{
                  let result = try context.fetch(request)
                  for data in result as! [NSManagedObject]{
                      self.arrayDish.append(data)
                      
                  }
                  self.listTableView.reloadData()
              }catch{
                  print("error while fetching....")
              }
          }
    // MARK: - UITableViewDataSource
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return self.arrayDish.count
            
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            
            return UITableViewAutomaticDimension
            
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListTableViewCell", for: indexPath) as! OrderListTableViewCell
           let obj = self.arrayDish[indexPath.row]
           cell.titleLabel.text = "\(obj.value(forKey: "title") as! String)"
             cell.userLabel.text = "For: \(obj.value(forKey: "user") as! String)"
             cell.ingLabel.text = "Pick-up Time: \(obj.value(forKey: "ing") as! String)"
           
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        }
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
               let delete = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Completed") { (action, indexPath) in
       //            self.arrayFruit.remove(at: indexPath.row)
       //            self.tblList.reloadData()
               let fruit = self.arrayDish[indexPath.row]
               let name = fruit.value(forKey: "title") as! String
                 
                   let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   let managedContext = appDelegate.persistentContainer.viewContext
                   let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
                   request.predicate = NSPredicate(format: "title = %@", name)
                   request.returnsObjectsAsFaults = false
                   
                   do{
                      let test = try managedContext.fetch(request)
                       if test.count == 1{
                           let objectDelete = test[0] as! NSManagedObject
                           //delete this way
                           managedContext.delete(objectDelete)
                           
                           do{
                               try managedContext.save()
                               print("Object is deleted successfully...")
                           }catch{
                               print("error")
                           }
                       }
                   }catch{
                       print("error")
                   }
                    self.fetchData()
               }
               return [delete]
           }
      
}
