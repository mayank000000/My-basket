//

import UIKit
import SwiftIcons
import SwiftyJSON
import CoreData

class ListViewController: BaseVC,UITableViewDataSource,UITableViewDelegate {
    var arrayDish = [NSManagedObject]()
    var category = ""
    var categoryIndex = 0
    var dishArray:[ObjOrder] = [ObjOrder]()
    @IBOutlet weak var listTableVie: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableVie.delegate = self
        listTableVie.dataSource = self
        
        listTableVie.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
        
        
      //  self.setDish()
        listTableVie.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    /*
    func setDish(){

        if categoryIndex == 0{
            addDish(name: "Basic FILTER burger", price: 7.0, image: "1")
            addDish(name: "ORIGINAL FILTER BURGER", price: 8.50, image: "2")
            addDish(name: "HONEY CRISP FILTER BURGER", price: 8.50, image: "3")
            addDish(name: "HAWAIIN FILTER BURGER", price: 9.0, image: "")
            addDish(name: "spicy fillet burger", price: 8.50, image: "")
        }else if categoryIndex == 1{
            addDish(name: "HASH BROWN NUGGETS", price: 4.0, image: "")
            addDish(name: "REGULAR CHIPS", price: 3.50, image: "")
            addDish(name: "LARGE CHIPS", price: 5.0, image: "")
            addDish(name: "WEDGES", price: 4.0, image: "")
        }else if categoryIndex == 2{
            addDish(name: "KIDDIES BOX", price: 5.50, image: "")
            addDish(name: "SNACK BOX", price: 6.50, image: "")
            addDish(name: "LUNCH BOX", price: 8.50, image: "")
            addDish(name: "DINNER BOX", price: 11.00, image: "")
            addDish(name: "3 WINGS BOX", price: 7.50, image: "")
            addDish(name: "3 DRUMS BOX", price: 10.50, image: "")
            addDish(name: "5 WINGS BOX", price: 10.50, image: "")
        }else if categoryIndex == 3{
            addDish(name: "5 PIECE PACK", price: 16.0, image: "")
            addDish(name: "BIG FEED", price: 21.50, image: "")
            addDish(name: "9 PIECE PACK", price: 23.0, image: "")
            addDish(name: "FAMILY FEAST", price: 30.0, image: "")
            addDish(name: "PARTY PACK", price: 40.0, image: "")
        }else if categoryIndex == 4{
            addDish(name: "5 NIBBLE PACK", price: 7.50, image: "")
            addDish(name: "8 NIBBLE PACK", price: 10.50, image: "")
            addDish(name: "12 NIBBLE PACK", price: 15.0, image: "")
        }else{
            //Add here drinks
            addDish(name: "V drink blue", price: 2.0, image: "")
        }
        
        
    }
    func addDish(name:String,price:Double, image:String){
        let dic = ["Title":name,
                   "Ing":"",
                   "Price":"\(price)",
            "Pic":image]
        let json = JSON(dic)
        let obj:ObjOrder = ObjOrder.init(json: json)
        self.dishArray.append(obj)
    }*/
    func fetchData(){
    
        self.arrayDish.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dish")
        request.predicate = NSPredicate(format: "category = %@", category)
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                self.arrayDish.append(data)
                
            }
            self.listTableVie.reloadData()
        }catch{
            print("error while fetching....")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden (false, animated: false)
        self.setNavigationbarleft_imagename(left_icon_Name: IoniconsType.androidArrowBack, left_action: #selector(self.btnBackHandle(_:)),
                                            right_icon_Name:nil,
                                            right_action: nil,
                                            title: "Items")
        self.fetchData()
        
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
        cell.imageViewGallery.image = getImageFromDocumentDirectory(imageName: (obj.value(forKey: "title") as! String))
        
    
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.arrayDish[indexPath.row]
        let title  = (obj.value(forKey: "title") as! String)
        let price  = (obj.value(forKey: "price") as! String)
        //var obj:ObjOrder? = nil
        let dic = ["Title":title,
                   "Ing":"",
                   "Price":"\(price)",
            "Pic":""] as [String : Any]
        let json = JSON(dic)
        let obj1:ObjOrder = ObjOrder.init(json: json)
        
        let vc = loadVC(storyboardMain, "DetailViewController") as! DetailViewController
        vc.objOrder = obj1//dishArray[indexPath.row]
        vc.category = category
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    func getImageFromDocumentDirectory(imageName: String)->UIImage{
              let fileManager = FileManager.default
                  let imagePath = (self.getDirectoryPath() as NSURL).appendingPathComponent("\(imageName)")
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
