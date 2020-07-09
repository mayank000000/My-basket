//
import UIKit
import Realm
import RealmSwift
import DropDown

class SignupViewController: BaseVC {

    @IBOutlet weak var ButtonUserType: UIButton!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldMobile: UITextField!
    @IBOutlet weak var buttonGender: UIButton!
    @IBOutlet weak var buttonSignup: UIButton!
    let userTypeArray = ["Admin","User","Employee"]
    var selectedGender = ""
    let chooseEmp = DropDown()
       
    var selectedType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.buttonSignup.setCornerRadius(radius: 5.0)
        self.buttonSignup.backgroundColor = APP_THEME_COLOR
        setupChooseEmpDropDown()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - button action
    
    @IBAction func buttonHandlerUserType(_ sender: Any) {
        chooseEmp.show()
    }
    @IBAction func buttonHandlerSignup(_ sender: Any) {
        if self.textFieldEmail.text == "" || self.textFieldPassword.text == "" || self.textFieldMobile.text == "" || self.selectedType == ""{
            showAlertWithTitleWithMessage(message: "Please complete the form")
        }else{
            if HelperFunction.helper.isValidEmail(testStr: self.textFieldEmail.text!){
                if HelperFunction.helper.isPasswordValid(self.textFieldPassword.text!){
                    
                    if (self.textFieldMobile.text?.length)! > 7 && (self.textFieldMobile.text?.length)! < 11{
                     
                   
                        self.registerUser()
                   
                }else{
                         showAlertWithTitleWithMessage(message: "Please enter valid mobile number.(Mobile number should be 8-10 digits only)")
                }
                }else{
                    showAlertWithTitleWithMessage(message: "Password should contain one special character and minimum 8 character required")
                }
                
            }else{
                showAlertWithTitleWithMessage(message: "Email is not valid")
            }
        }
    }
    //this button action handle gender selection
    @IBAction func buttonHandlerGender(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Gender", message: "Please select gender")
        
        let frameSizes: [String] = ["Male","Female"]
        let pickerViewValues: [[String]] = [["Male","Female"]]
        self.buttonGender.setTitle(frameSizes[0], for: .normal)
        self.selectedGender = frameSizes[0]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            self.selectedGender = frameSizes[index.row]
            self.buttonGender.setTitle(frameSizes[index.row], for: .normal)
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
                    print(frameSizes[index.row])
                    
                    
                }
            }
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    //go back to login screen
    @IBAction func buttonHandlerSignin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Custom methods
    func setupChooseEmpDropDown() {
              
                chooseEmp.anchorView = self.ButtonUserType
                chooseEmp.bottomOffset = CGPoint(x: 0, y: 0)
                chooseEmp.dataSource = userTypeArray
                chooseEmp.selectionAction = { [weak self] (index, item) in
                 self!.selectedType = item
                 self!.ButtonUserType.setTitle(item, for: .normal)
                    self!.chooseEmp.hide()
                }
                
            }
    //this method is used for the register user and save data to Realm
    func registerUser(){
        
        let user = RObjUser()
        user.firstName = self.textFieldFirstName.text!
        user.lastName = self.textFieldLastName.text!
        user.email = self.textFieldEmail.text!
        user.password = self.textFieldPassword.text!
        user.type = self.selectedType
       // user.gender = self.selectedGender
        user.mobileNum = Int(self.textFieldMobile.text!)!
        let realm = try! Realm()
        let arrayData = realm.objects(RObjUser.self).filter("email == %d",self.textFieldEmail.text!)
        if arrayData.count>0{
            showAlertWithTitleWithMessage(message: "Email already exists")
        }else{
            runOnAfterTime(afterTime: 1.0) {
                DBManager.sharedInstance.addObject(object: user)
                customeSimpleAlertView(title: "Registered!", message: "Congratulations! You are successfully registered")
                
                //Reset all controls after user registeration
                self.textFieldFirstName.text = ""
                self.textFieldLastName.text = ""
                self.textFieldMobile.text = ""
                self.textFieldEmail.text = ""
                self.textFieldPassword.text = ""
                               
            }
            
        }
        
    }
}
