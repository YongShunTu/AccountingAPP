//
//  EditAccountViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/15.
//

import UIKit

protocol EditAccountViewControllerDelegate {
    func deleteAccount(delete account: Accounts)
    func editAccount(edit account: Accounts)
}

class EditAccountViewController: UIViewController {
    
    var account: Accounts?
    
    @IBOutlet var allView: [UIView]!
    @IBOutlet weak var money: UITextField!
    @IBOutlet weak var selectDate: UIDatePicker!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subTypeLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var buttonPhoto: UIButton!
    @IBOutlet weak var expenditureOrIncomeLabel: UILabel!
    
    
    var categoryString: String = "" {
        didSet {
            if let account = self.account {
                switch ExpenditureOrIncome.init(rawValue: account.expenditureOrIncome) {
                case .expenditure:
                    categoryLabel.text = categoryString
                    subTypeLabel.text = (expenditureSubTypeItems[categoryString]?.first) ?? ""
                case .income:
                    categoryLabel.text = categoryString
                    subTypeLabel.text = (incomeSubTypeItems[categoryString]?.first) ?? ""
                default:
                    break
                }
            }
        }
    }
    
    var delegate: EditAccountViewControllerDelegate?
    var isSelectImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        upDateEditAccount()
        updateEditAccountStyle()
        // Do any additional setup after loading the view.
    }
    
    func updateEditAccountStyle() {
        for view in allView {
            view.backgroundColor = UIColor(red: 231/255, green: 207/255, blue: 168/255, alpha: 0.4)
            view.layer.cornerRadius = 10
            view.layer.borderWidth = 1
            view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
        buttonPhoto.clipsToBounds = true
        buttonPhoto.layer.cornerRadius = 10
        money.addKeyboardReturn()
        noteTextView.addKeyboardReturn()
        registerForKeyboardNotifications()
        addTapGesture()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo,
              let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        let contentInsets = keyboardSize.height - (view.bounds.height - (textView.frame.maxY + (textView.superview?.frame.minY ?? 0)))
        if noteTextView.isFirstResponder {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
                self.view.bounds.origin.y = contentInsets
            }
        }else{
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
                self.view.bounds.origin.y = 0
            }
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        self.view.bounds.origin.y = 0
    }
    
    func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    func upDateEditAccount() {
        if let account = self.account {
            switch foodpandaOrUber.init(rawValue: account.project) {
            case .FoodPanda:
                money.text = String(format: "%.0f", (account.money / 0.7))
            case .Uber:
                money.text = String(format: "%.0f", (account.money / 0.66))
            default:
                money.text = String(format: "%.0f", account.money)
            }
            
            categoryString = account.category
            subTypeLabel.text = account.subtype
            selectDate.date = account.date
            noteTextView.text = account.note
            bankLabel.text = account.bankAccounts
            projectLabel.text = account.project
            locationLabel.text = account.location
            
            switch ExpenditureOrIncome.init(rawValue: account.expenditureOrIncome) {
            case .expenditure:
                money.textColor = UIColor(red: 240/255, green: 164/255, blue: 141/255, alpha: 1)
                expenditureOrIncomeLabel.text = "支出"
            case .income:
                money.textColor = UIColor(red: 123/255, green: 139/255, blue: 111/255, alpha: 1)
                expenditureOrIncomeLabel.text = "收入"
            default:
                break
            }
            
            if let imageName = account.imageName {
                let imageURL = Accounts.documentDirectory.appendingPathComponent(imageName).appendingPathExtension("jpeg")
                let image = UIImage(contentsOfFile: imageURL.path)
                buttonPhoto.setImage(image, for: .normal)
            }
        }
        
    }
    
    
    @IBAction func categoryButtonClicked(_ sender: UIButton) {
        if let account = self.account,
           let controller = storyboard?.instantiateViewController(withIdentifier: "\(AllCategoriesTableViewController.self)") as? AllCategoriesTableViewController
        {
            switch ExpenditureOrIncome.init(rawValue: account.expenditureOrIncome) {
            case .expenditure:
                controller.items = expenditureCategoryItems
                controller.itemsName = .category
                controller.delegate = self
                present(controller, animated: true, completion: nil)
            case .income:
                controller.items = incomeCategoryItems
                controller.itemsName = .category
                controller.delegate = self
                present(controller, animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    @IBAction func subTypeButtonClicked(_ sender: UIButton) {
        if let account = self.account,
           let controller = storyboard?.instantiateViewController(withIdentifier: "\(AllCategoriesTableViewController.self)") as? AllCategoriesTableViewController
        {
            switch ExpenditureOrIncome.init(rawValue: account.expenditureOrIncome) {
            case .expenditure:
                controller.items = expenditureSubTypeItems[categoryString]!
                controller.itemsName = .subType
                controller.categoryItemsPhotoName = categoryString
                controller.delegate = self
                present(controller, animated: true, completion: nil)
            case .income:
                controller.items = incomeSubTypeItems[categoryString]!
                controller.itemsName = .subType
                controller.categoryItemsPhotoName = categoryString
                controller.delegate = self
                present(controller, animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    @IBAction func bankAccountsButtonClicked(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "\(AllCategoriesTableViewController.self)") as? AllCategoriesTableViewController {
            controller.items = bankItems
            controller.itemsName = .bankAccounts
            controller.delegate = self
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func projectButtonClicked(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "\(AllCategoriesTableViewController.self)") as? AllCategoriesTableViewController,
           let accounts = self.account,
           accounts.expenditureOrIncome == ExpenditureOrIncome.income.rawValue
        {
            controller.items = incomeProjectItems
            controller.itemsName = .project
            controller.delegate = self
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "\(GoogleMapViewController.self)") as? GoogleMapViewController {
            controller.searchBarLabel = locationLabel.text ?? ""
            controller.googleDelegate = self
            present(controller, animated: true, completion: nil)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func editAccount(_ sender: UIButton) {
        let alter = UIAlertController(title: "修改", message: "確定要修改此筆資料嗎", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "Cancle", style: .default, handler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            var imageName: String?
            var expenditureOrIncome: String = ""
            var money = Double(self.money.text ?? "") ?? 0.0
            let data = self.selectDate.date
            let category = self.categoryLabel.text ?? ""
            let subtype = self.subTypeLabel.text ?? ""
            let note = self.noteTextView.text ?? ""
            let bankAccounts = self.bankLabel.text ?? ""
            let project = self.projectLabel.text ?? ""
            let location = self.locationLabel.text ?? ""
            var index: String = ""
            
            switch foodpandaOrUber.init(rawValue: project) {
            case .FoodPanda:
                money = money * 0.7
            case .Uber:
                money = money * 0.66
            default:
                break
            }
            
            if let account = self.account {
                imageName = account.imageName
                expenditureOrIncome = account.expenditureOrIncome
                index = account.accountsIndex
            }
            
            if self.isSelectImage {
                imageName = UUID().uuidString
                let imageData = self.buttonPhoto.image(for: .normal)?.jpegData(compressionQuality: 0.9)
                let imageURL = Accounts.documentDirectory.appendingPathComponent(imageName!).appendingPathExtension("jpeg")
                try? imageData?.write(to: imageURL)
            }
            
            let editAccounts = Accounts(expenditureOrIncome: expenditureOrIncome, imageName: imageName, money: money, date: data, category: category, subtype: subtype, note: note, bankAccounts: bankAccounts, project: project, location: location, accountsIndex: index)
            
            self.delegate?.editAccount(edit: editAccounts)
            self.dismiss(animated: true, completion: nil)
        }
        
        alter.addAction(cancleAction)
        alter.addAction(okAction)
        present(alter, animated: true, completion: nil)
    }
    
    @IBAction func deleteAccount(_ sender: UIButton) {
        let alter = UIAlertController(title: "刪除", message: "確定要刪除此筆紀錄嗎", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "Cancle", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let account = self.account {
                self.delegate?.deleteAccount(delete: account)
                self.dismiss(animated: true, completion: nil)
            }
        }
        alter.addAction(cancleAction)
        alter.addAction(okAction)
        present(alter, animated: true, completion: nil)
    }
    
    @IBAction func dismissEditAccountViewButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectButtonPhoto(_ sender: UIButton) {
        let alter = UIAlertController(title: "照片選擇", message: nil, preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "相機", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        let photoLibraryAction = UIAlertAction(title: "相簿", style: .default) { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        
        alter.addAction(cameraAction)
        alter.addAction(photoLibraryAction)
        alter.addAction(cancelAction)
        present(alter, animated: true, completion: nil)
    }
    
}



extension EditAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, AllCategoriesTableViewControllerDelegate,  GoogleMapViewControllerDelegate {
    
    func getItemsString(_ allcategories: allCategories, _ itemsString: String) {
        switch allcategories {
        case .category:
            self.categoryString = itemsString
        case .subType:
            self.subTypeLabel.text = itemsString
        case .bankAccounts:
            self.bankLabel.text = itemsString
        case .project:
            self.projectLabel.text = itemsString
            self.bankLabel.text = incomeProjectBankItems[itemsString]
        default:
            break
        }
    }
    
    func getLocation(_ location: String) {
        locationLabel.text = location
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        isSelectImage = true
        if let image = info[.originalImage] as? UIImage {
            buttonPhoto.setImage(image, for: .normal)
            dismiss(animated: true, completion: nil)
        }
    }
    
}

