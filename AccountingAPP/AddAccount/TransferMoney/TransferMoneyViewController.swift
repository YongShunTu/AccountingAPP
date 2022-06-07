//
//  TransferMoneyViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/19.
//

import UIKit

class TransferMoneyViewController: UIViewController {

    @IBOutlet var allView: [UIView]!
    @IBOutlet weak var money: UITextField!
    @IBOutlet weak var handlingFee: UITextField!
    @IBOutlet weak var selectedDate: UIDatePicker!
    @IBOutlet weak var transferOutLabel: UILabel!
    @IBOutlet weak var transferInLabel: UILabel!
    @IBOutlet weak var note: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateTransferMoneyStyle()
    }
    
    func updateTransferMoneyStyle() {
        for view in allView {
            view.backgroundColor = UIColor(red: 231/255, green: 207/255, blue: 168/255, alpha: 0.4)
            view.layer.cornerRadius = 10
            view.layer.borderWidth = 1
            view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
        money.textColor = UIColor(red: 123/255, green: 139/255, blue: 111/255, alpha: 1)
        handlingFee.textColor = UIColor(red: 240/255, green: 164/255, blue: 141/255, alpha: 1)
        transferOutLabel.text = bankItems[0]
        transferInLabel.text = bankItems[1]
        selectedDate.date = AddAccountViewController.selectedDate!
        money.addKeyboardReturn()
        handlingFee.addKeyboardReturn()
        note.addKeyboardReturn()
        addTapGesture()
    }
    
    func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBAction func colseKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func transferOutButtonClicked(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "\(AllCategoriesTableViewController.self)") as? AllCategoriesTableViewController,
           let sheetPresentationController = controller.sheetPresentationController
        {
            controller.items = bankItems
            controller.itemsName = .transferOut
            controller.delegate = self
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.prefersGrabberVisible = true
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func transferInButtonClicked(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "\(AllCategoriesTableViewController.self)") as? AllCategoriesTableViewController,
           let sheetPresentationController = controller.sheetPresentationController
        {
            controller.items = bankItems
            controller.itemsName = .transferIn
            controller.delegate = self
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.prefersGrabberVisible = true
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func addTransferMoneyButtonClicked(_ sender: UIButton) {
        let alter = UIAlertController(title: "轉帳", message: "確定要轉帳嗎", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "Cancle", style: .default, handler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            let money = Double(self.money.text ?? "") ?? 0.0
            let handlingFee = Double(self.handlingFee.text ?? "") ?? 0.0
            let date = self.selectedDate.date
            let transferOutString = self.transferOutLabel.text ?? ""
            let transferInString = self.transferInLabel.text ?? ""
            let note = self.note.text ?? ""
            let index = UUID().uuidString
            
            
            
            let account = Accounts(expenditureOrIncome: ExpenditureOrIncome.expenditure.rawValue, imageName: nil, money: handlingFee, date: date, category: "雜費", subtype: "轉帳手續費", note: note, bankAccounts: transferOutString, project: "現金", location: "", accountsIndex: index)
            
            let withdrawalBank = BankAccounts(transferOutName: transferOutString, transferInName: transferInString, transferOutmoney: money, transferInMoney: money, handlingFee: handlingFee, date: date, note: note, bankAccountsIndex: index)
            
            AddAccountViewController.addAccountDelegate?.addTransferMoneyHandlingFee(account, bankAccount: withdrawalBank, handlingFee: handlingFee)

            self.dismiss(animated: true, completion: nil)
        }
        
        alter.addAction(cancleAction)
        alter.addAction(okAction)
        present(alter, animated: true, completion: nil)
    }

}

extension TransferMoneyViewController: AllCategoriesTableViewControllerDelegate {
    func getItemsString(_ allcategories: allCategories, _ itemsString: String) {
        switch allcategories {
        case .transferOut:
            self.transferOutLabel.text = itemsString
        case .transferIn:
            self.transferInLabel.text = itemsString
        default:
            break
        }
    }
    
    
}
