//
import UIKit
import SwiftIcons
import CoreData

class DetailViewController: BaseVC,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {
    var ingArray = ["15min","30min","1hr","2hr","3hr","4hr","5hr","6hr"]
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var dishImage: UILabel!
    var selectedIng = [String]()
    var selectedStrIng = ""
    
    var selectedIndex = 0
    
    var objOrder:ObjOrder? = nil
    var arrayObj:[ObjOrder] = [ObjOrder]()
    
    @IBOutlet weak var txt_pickUpData: UITextField!
    var myPickerView : UIPickerView!
    
    @IBOutlet weak var textfieldNote: UITextField!
    @IBOutlet weak var extraLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var category = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = objOrder?.title ?? ""
        var img = objOrder?.pic ?? ""
        if img == ""{
            img = "delbusy2"
        }
        self.mainImage.image = UIImage(named:img)
        txt_pickUpData.delegate = self
        txt_pickUpData.tintColor = UIColor.clear
        extraLabel.text = "Pick-up Time"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden (true, animated: false)
    }
    //MARK: - button action
    @IBAction func buttonHandlerAdd(_ sender: Any) {
        
        //check data is updated....
        let arrData = UserDefaults.standard.object(forKey: "myOrder")
        if arrData != nil{
            
            self.arrayObj = NSKeyedUnarchiver.unarchiveObject(with: arrData as! Data) as! [ObjOrder]
            
        }
        
        self.arrayObj.append(self.objOrder!)
        DispatchQueue.main.async{
        let myData = NSKeyedArchiver.archivedData(withRootObject: self.arrayObj)
        UserDefaults.standard.set(myData, forKey: "myOrder")
        }
        self.AddOrder(title: (objOrder?.title!)!, price: (objOrder?.price!)!, category: category, ing: self.selectedStrIng)
        let vc = loadVC(storyboardMain, "OrderViewController") as! OrderViewController
        self.objOrder?.ing = self.selectedStrIng
        vc.objOrder = self.objOrder
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func AddOrder(title:String,price:String,category:String,ing:String){
        
        let username = HelperFunction.helper.FetchFromUserDefault(name: "username")
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
             let context = appDelegate.persistentContainer.viewContext
             
             let entity = NSEntityDescription.entity(forEntityName:"Order", in: context)
             let new = NSManagedObject(entity: entity!, insertInto: context)
             
              new.setValue(title, forKey:"title")
              new.setValue(price, forKey:"price")
              new.setValue(category, forKey:"category")
              new.setValue(ing, forKey:"ing")
              new.setValue(username, forKey: "user")
             new.setValue("progress", forKey: "status")
             
             do{
                 try context.save()
              
                 print("Data added successfully....")
             }catch{
                 print("Error while inserting data....")
                 showAlertWithTitleWithMessage(message: "Please try again")
             }
      }
    @IBAction func buttonHaadlerSelect(_ sender: Any) {
        
    }
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        selectedIndex = 0
    }
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(txt_pickUpData)
    }
    @objc func doneClick() {
        
        txt_pickUpData.resignFirstResponder()
        self.updateUI()
        
        
    }
    @objc func cancelClick() {
        txt_pickUpData.resignFirstResponder()
    }
    func updateUI(){
        self.selectedIng.append(ingArray[selectedIndex])
        self.selectedStrIng =  selectedIng.joined(separator: ",")
        self.extraLabel.text = selectedStrIng
    }
    @IBAction func buttonHandlerBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ingArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.ingArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedIndex = row
        // self.txt_pickUpData.text = pickerData[row]
        
    }
    
}
