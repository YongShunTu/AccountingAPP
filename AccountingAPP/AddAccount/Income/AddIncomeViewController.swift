//
//  AddIncomeViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/16.
//

import UIKit


class AddIncomeViewController: UIViewController, UITextViewDelegate {
    
    static let addFrequentlyUsedIncomeNotification = Notification.Name("addFrequentlyUsedIncome")
    
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
    
    var account: Accounts?
    
    var categoryString: String = "" {
        didSet {
            categoryLabel.text = categoryString
            subTypeLabel.text = (incomeSubTypeItems[categoryString]?.first) ?? ""
        }
    }
    
    var isSelectImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAddIncomeStyle()
        NotificationCenter.default.addObserver(self, selector: #selector(frequentlyUsedIncome), name: AddAccountViewController.moveToIncomeNotification, object: nil)
        // Do any additional setup after loading the view.
        
    }
    
    func updateAddIncomeStyle() {
        for view in allView {
            view.backgroundColor = UIColor(red: 231/255, green: 207/255, blue: 168/255, alpha: 0.4)
            view.layer.cornerRadius = 10
            view.layer.borderWidth = 1
            view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
        buttonPhoto.clipsToBounds = true
        buttonPhoto.layer.cornerRadius = 10
        
        categoryString = incomeCategoryItems[0]
        projectLabel.text = incomeProjectItems[0]
        bankLabel.text = bankItems[0]
        selectDate.date = AddAccountViewController.selectedDate!
        money.addKeyboardReturn()
        noteTextView.addKeyboardReturn()
        registerForKeyboardNotifications()
        addTapGesture()
        money.textColor = UIColor(red: 123/255, green: 139/255, blue: 111/255, alpha: 1)
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
        let contentInsets = keyboardSize.height - (view.bounds.height - textView.frame.maxY)
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
    
    
    @objc func frequentlyUsedIncome(_ noti: Notification) {
        if let user = noti.userInfo,
           let commonIncomeAccount = user[ExpenditureOrIncome.income.rawValue] as? FrequentlyUsedIncome {
            money.text = String(format: "%.0f", commonIncomeAccount.money)
            categoryLabel.text = commonIncomeAccount.category
            subTypeLabel.text = commonIncomeAccount.subtype
            noteTextView.text = commonIncomeAccount.note
            projectLabel.text = commonIncomeAccount.project
            locationLabel.text = commonIncomeAccount.location
        }
    }
    
    
    @IBAction func categoryButtonClicked(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "\(AllCategoriesTableViewController.self)") as? AllCategoriesTableViewController,
           let sheetPresentationController = controller.sheetPresentationController
        {
            controller.items = incomeCategoryItems
            controller.itemsName = .category
            controller.delegate = self
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.prefersGrabberVisible = true
            present(controller, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func subTypeButtonClicked(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "\(AllCategoriesTableViewController.self)") as? AllCategoriesTableViewController,
           let sheetPresentationController = controller.sheetPresentationController
        {
            controller.items = incomeSubTypeItems[categoryString]!
            controller.itemsName = .subType
            controller.categoryItemsPhotoName = categoryString
            controller.delegate = self
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.prefersGrabberVisible = true
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func bankAccountsButtonClicked(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "\(AllCategoriesTableViewController.self)") as? AllCategoriesTableViewController,
           let sheetPresentationController = controller.sheetPresentationController
{
            controller.items = bankItems
            controller.itemsName = .bankAccounts
            controller.delegate = self
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.prefersGrabberVisible = true
            present(controller, animated: true, completion: nil)
        }
    }
    @IBAction func projectButtonClicked(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "\(AllCategoriesTableViewController.self)") as? AllCategoriesTableViewController,
           let sheetPresentationController = controller.sheetPresentationController
{
            controller.items = incomeProjectItems
            controller.itemsName = .project
            controller.delegate = self
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.prefersGrabberVisible = true
            present(controller, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func locationButtonClicked(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "\(GoogleMapViewController.self)") as? GoogleMapViewController,
           let sheetPresentationController = controller.sheetPresentationController
{
            controller.searchBarLabel = locationLabel.text ?? ""
            controller.googleDelegate = self
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.prefersGrabberVisible = true
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
    @IBAction func addIncome(_ sender: UIButton) {
        let alter = UIAlertController(title: "新增收入", message: "確定要新增此筆收入嗎", preferredStyle: .alert)
        
        let cancle = UIAlertAction(title: "Cancle", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            var imageName: String?
            let money = Double(self.money.text ?? "") ?? 0.0
            let data = self.selectDate.date
            let category = self.categoryLabel.text ?? ""
            let subtype = self.subTypeLabel.text ?? ""
            let note = self.noteTextView.text ?? ""
            let bankAccounts = self.bankLabel.text ?? ""
            let project = self.projectLabel.text ?? ""
            let location = self.locationLabel.text ?? ""
            let index = UUID().uuidString
            
//            switch foodpandaOrUber.init(rawValue: project) {
//            case .FoodPanda:
//                money = money * 0.7
//            case .Uber:
//                money = money * 0.66
//            default:
//                break
//            }
            
            if self.isSelectImage {
                imageName = UUID().uuidString
                let imageData = self.buttonPhoto.image(for: .normal)?.jpegData(compressionQuality: 0.5)
                let imageURL = Accounts.documentDirectory.appendingPathComponent(imageName!).appendingPathExtension("jpeg")
                try? imageData?.write(to: imageURL)
            }
            
            let account = Accounts(expenditureOrIncome: ExpenditureOrIncome.income.rawValue, imageName: imageName, money: money, date: data, category: category, subtype: subtype, note: note, bankAccounts: bankAccounts, project: project, location: location, accountsIndex: index)
            AddAccountViewController.addAccountDelegate?.addIncomeAccount(account)
            self.dismiss(animated: true, completion: nil)
        }
        
        alter.addAction(cancle)
        alter.addAction(okAction)
        present(alter, animated: true, completion: nil)
    }
    
    @IBAction func addFrequentlyUsedIncomeButtonClicked(_ sender: UIButton) {
        
        let alter = UIAlertController(title: "新增常用", message: "輸入標題", preferredStyle: .alert)
        alter.addTextField { (textField) in
            textField.placeholder = "write here"
        }
        
        
        let cancleAction = UIAlertAction(title: "Cancle", style: .default, handler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let money = Double(self.money.text ?? "") ?? 0.0
            let category = self.categoryLabel.text ?? ""
            let subType = self.subTypeLabel.text ?? ""
            let note = self.noteTextView.text ?? ""
            let project = self.projectLabel.text ?? ""
            let location = self.locationLabel.text ?? ""
            let title = alter.textFields?[0].text ?? ""
            
            let addFrequentlyUsedIncome = FrequentlyUsedIncome(expenditrueOrIncome: ExpenditureOrIncome.income.rawValue, money: money, tittle: title, category: category, subtype: subType, note: note, project: project, location: location)
            
            NotificationCenter.default.post(name: AddIncomeViewController.addFrequentlyUsedIncomeNotification, object: nil, userInfo: [ExpenditureOrIncome.income.rawValue: addFrequentlyUsedIncome])
        }
        
        alter.addAction(cancleAction)
        alter.addAction(okAction)
        present(alter, animated: true, completion: nil)
        
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



extension AddIncomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, AllCategoriesTableViewControllerDelegate, GoogleMapViewControllerDelegate {
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
