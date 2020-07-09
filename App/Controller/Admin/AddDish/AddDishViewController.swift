

import DropDown
import UIKit
import CoreData
import SwiftIcons
import SwiftyJSON

class AddDishViewController: BaseVC,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var ImageButton: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    
    var selectedImage : UIImage?
    var categoryArray = ["DAIRY PRODUCTS", "DRINKS","FROZEN ITEMS","LAUNDARY","SNACKS","VEGETABLES"]
     let chooseEmp = DropDown()
    
    var selectedCategory = ""
    
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden (false, animated: false)
        self.setNavigationbarleft_imagename(left_icon_Name: IoniconsType.androidArrowBack, left_action: #selector(self.btnBackHandle(_:)),
                                            right_icon_Name:nil,
                                            right_action: nil,
                                            title: "Add Item")
        setupChooseEmpDropDown()
        // Do any additional setup after loading the view.
    }
    //MARK: - custom method
    func saveImageDocumentDirectory(image: UIImage, imageName: String) {
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("CHIECKENAPP")
        if !fileManager.fileExists(atPath: path) {
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        let url = NSURL(string: path)
        let imagePath = url!.appendingPathComponent(imageName)
        let urlString: String = imagePath!.absoluteString
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        //let imageData = UIImagePNGRepresentation(image)
        fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
    }
    func getDirectoryPath() -> NSURL {
          let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("CHIECKENAPP")
          let url = NSURL(string: path)
          return url!
      }
    func setupChooseEmpDropDown() {
         
           chooseEmp.anchorView = self.categoryButton
           chooseEmp.bottomOffset = CGPoint(x: 0, y: 0)
           chooseEmp.dataSource = categoryArray
           chooseEmp.selectionAction = { [weak self] (index, item) in
            self!.selectedCategory = item
            self!.categoryButton.setTitle(item, for: .normal)
               self!.chooseEmp.hide()
           }
           
       }

    //MARK: - Button action
    @IBAction func buttonHandlerSelectCategory(_ sender: Any) {
        self.chooseEmp.show()
    }
    
    @IBAction func buttonHandlerIMage(_ sender: Any) {
      let vc = UIImagePickerController()
       vc.allowsEditing = true
        vc.sourceType = .photoLibrary
        vc.delegate = self
        self.present(vc, animated: true)
   
    }
    @IBAction func buttonHandlerSave(_ sender: Any) {
        if self.nameTextField.text == "" || self.priceTextField.text == "" || self.selectedCategory == ""{
            showAlertWithTitleWithMessage(message: "Please enter all details")
        }else{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName:"Dish", in: context)
            let new = NSManagedObject(entity: entity!, insertInto: context)
            
             new.setValue(nameTextField.text!, forKey:"title")
             new.setValue(priceTextField.text!, forKey:"price")
             new.setValue(selectedCategory, forKey:"category")
             new.setValue("", forKey:"ing")
             new.setValue(nameTextField.text!, forKey:"pic")
            
         
         
            do{
                try context.save()
                DispatchQueue.main.async {
                    self.saveImageDocumentDirectory(image: self.selectedImage!, imageName: self.nameTextField.text!)
                }
                          showAlertWithTitleWithMessage(message: "Item Added Successfully")
                         
                         self.navigationController?.popViewController(animated: true)
                print("Data added successfully....")
            }catch{
                print("Error while inserting data....")
                showAlertWithTitleWithMessage(message: "Please try again")
            }
        }
        
    }
 //MARK: - Image Picker
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.selectedImage = editedImage
            self.ImageButton.setBackgroundImage(self.selectedImage, for: .normal)
        } else if let originalimage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      self.selectedImage = originalimage
              self.ImageButton.setBackgroundImage(self.selectedImage, for: .normal)
        }
     picker.dismiss(animated: true, completion: nil)
    }
}
