//
//  IncomeViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/15.
//

import UIKit

class IncomeViewController: UIViewController {

    var account: Account?
    
    @IBOutlet var allView: [UIView]!
    @IBOutlet weak var money: UITextField!
    @IBOutlet weak var selectDate: UIDatePicker!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subTypeLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var billNumberLabel: UILabel!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var buttonPhoto: UIButton!
    
    var categoryString: String = "" {
        didSet {
            categoryLabel.text = categoryString
            subTypeString = (incomeSubTypeItems[categoryString]?.first) ?? ""
        }
    }
    
    var subTypeString: String = "" {
        didSet {
            subTypeLabel.text = subTypeString
        }
    }
    
    var isSelectImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryString = incomeCategoryItems[0]
        allViewStyle()
        // Do any additional setup after loading the view.
    }

    
    func allViewStyle() {
        for view in allView {
            view.layer.cornerRadius = 10
            view.layer.borderWidth = 1
            view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    @IBAction func unwindToCategory(_ unwindSegue: UIStoryboardSegue) {
        if let controller = unwindSegue.source as? CategoryTableViewController {
            categoryString = controller.categoryString
        }
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func unwindToSubType(_ unwindSegue: UIStoryboardSegue) {
        if let controller = unwindSegue.source as? SubTypeTableViewController {
            subTypeString = controller.subTypeString
        }
        // Use data from the view controller which initiated the unwind segue
    }
    
    
    @IBAction func categoryButtonClicked(_ sender: UIButton) {
        CategoryTableViewController.items = incomeCategoryItems
    }
    
    @IBAction func subTypeButtonClicked(_ sender: UIButton) {
        SubTypeTableViewController.items = incomeSubTypeItems[categoryString]!
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
        var imageName: String?
        let money = money.text ?? ""
        let data = selectDate.date
        let category = categoryLabel.text ?? ""
        let subtype = subTypeLabel.text ?? ""
        let note = noteTextView.text ?? ""
        let billNumber = billNumberLabel.text ?? ""
        let project = projectLabel.text ?? ""
        let location = locationLabel.text ?? ""
//        dismiss(animated: true) {
//            if let account = self.account {
//                imageName = account.imageName
//            }

            if self.isSelectImage {
                imageName = UUID().uuidString
                let imageData = self.buttonPhoto.image(for: .normal)?.jpegData(compressionQuality: 0.9)
                let imageURL = Account.documentDirectory.appendingPathComponent(imageName!).appendingPathExtension("jpeg")
                try? imageData?.write(to: imageURL)
            }
        self.account = Account(expenditrueOrIncome: "income", imageName: imageName, money: money, date: data, category: category, subtype: subtype, note: note, billNumber: billNumber, project: project, location: location)
//        }
    }
    @IBAction func textAlter(_ sender: UIButton) {
        let alter = UIAlertController(title: "新增", message: nil, preferredStyle: .alert)
        alter.addTextField { (textField) in
            textField.placeholder = "write here"
//            textField.text = self.noteTextView.text
        }
        let okAction = UIAlertAction(title: "note", style: .default) { (action) in
                self.noteTextView.text = alter.textFields?[0].text
        }
        
        let moneyAction = UIAlertAction(title: "money", style: .default) { (action) in
            self.money.text = alter.textFields?[0].text
        }
        
        let cancle = UIAlertAction(title: "cancle", style: .default, handler: nil)
        
        alter.addAction(cancle)
        alter.addAction(moneyAction)
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



extension IncomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        isSelectImage = true
        if let image = info[.originalImage] as? UIImage {
            buttonPhoto.setImage(image, for: .normal)
            dismiss(animated: true, completion: nil)
        }
    }
    
}
