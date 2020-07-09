/
import UIKit
import CoreData
import SwiftIcons

class DishListViewController: BaseVC,UITableViewDataSource,UITableViewDelegate  {
    
    @IBOutlet weak var dishTableView: UITableView!
    var arrayDish = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden (false, animated: false)
        self.setNavigationbarleft_imagename(left_icon_Name:nil, left_action: nil,
                                            right_icon_Name: IoniconsType.logOut,
                                            right_action: #selector(self.btnBackHandle(_:)),
                                            title: "Item List")
        dishTableView.delegate = self
        dishTableView.dataSource = self
        
        dishTableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.fetchData()
    }
    //MARK: - Button action
    @IBAction func buttonAdd(_ sender: Any) {
        let homeVC = loadVC(storyboardMain, "AddDishViewController") as! AddDishViewController
                                         self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func fetchData(){
           self.arrayDish.removeAll()
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let context = appDelegate.persistentContainer.viewContext
           let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dish")
           request.returnsObjectsAsFaults = false
           do{
               let result = try context.fetch(request)
               for data in result as! [NSManagedObject]{
                   self.arrayDish.append(data)
                   
               }
               self.dishTableView.reloadData()
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
         
         return 75.0
         
         
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        let obj = self.arrayDish[indexPath.row]
        cell.titleLabel.text = (obj.value(forKey: "title") as! String)
        DispatchQueue.main.async {
            let img = self.getImageFromDocumentDirectory(imageName: (obj.value(forKey: "title") as! String))
        cell.imageViewGallery.image = img
        }
    
         cell.selectionStyle = .none
         cell.backgroundColor = UIColor.clear
         cell.contentView.backgroundColor = UIColor.clear
         return cell
     }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
     }
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let delete = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete") { (action, indexPath) in
    //            self.arrayFruit.remove(at: indexPath.row)
    //            self.tblList.reloadData()
            let fruit = self.arrayDish[indexPath.row]
            let name = fruit.value(forKey: "title") as! String
              
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedContext = appDelegate.persistentContainer.viewContext
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dish")
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
     func getImageFromDocumentDirectory(imageName: String)->UIImage{
             let fileManager = FileManager.default
                 let imagePath = (self.getDirectoryPath() as NSURL).appendingPathComponent("\(imageName)")
           print("\n Image Path:",imagePath)
                 let urlString: String = imagePath!.absoluteString
                 if fileManager.fileExists(atPath: urlString) {
                     let image = UIImage(contentsOfFile: urlString)
                     return image!
                     //imageArray.append(image!)
                 } else {
                     // print("No Image")
                     return UIImage(named: "logo_theme")!
                 }
         
         }
    
    func getDirectoryPath() -> NSURL {
             let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("CHIECKENAPP")
             let url = NSURL(string: path)
             return url!
         }
    
}
