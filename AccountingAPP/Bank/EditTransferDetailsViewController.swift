//
//  EditTransferDetailsViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/14.
//

import UIKit

protocol EditTransferDetailsViewControllerDelegate {
    func editTransferDetails(_ bankAcoount: BankAccounts, _ account: Accounts, handlingFee: Double)
    func deleteTransferDetails(_ bankAccount: BankAccounts)
}

class EditTransferDetailsViewController: UIViewController {
    
    @IBOutlet var allView: [UIView]!
    @IBOutlet weak var money: UITextField!
    @IBOutlet weak var handlingFee: UITextField!
    @IBOutlet weak var selectedDate: UIDatePicker!
    @IBOutlet weak var transferOutLabel: UILabel!
    @IBOutlet weak var transferInLabel: UILabel!
    @IBOutlet weak var note: UITextView!
    
    var bankAccount: BankAccounts?
    
    var delegate: EditTransferDetailsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        updateStyle()
        updateEditTransferDetails()
    }
    
    func updateStyle() {
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
        money.addKeyboardReturn()
        handlingFee.addKeyboardReturn()
        note.addKeyboardReturn()
    }
    
    func updateEditTransferDetails() {
        if let bankAccount = bankAccount {
            money.text = String(format: "%.0f", bankAccount.transferOutmoney)
            handlingFee.text = String(format: "%.0f", bankAccount.handlingFee)
            selectedDate.date = bankAccount.date
            transferOutLabel.text = bankAccount.transferOutName
            transferInLabel.text = bankAccount.transferInName
            note.text = bankAccount.note
        }
    }
    
    @IBAction func dismissEditTransferDetailButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func editTransferDetailsButtonClicked(_ sender: UIButton) {
        let alter = UIAlertController(title: "修改轉帳", message: "確定要修改此筆轉帳嗎", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "Cancle", style: .default, handler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            let money = Double(self.money.text ?? "") ?? 0.0
            let handlingFee = Double(self.handlingFee.text ?? "") ?? 0.0
            let date = self.selectedDate.date
            let transferOutString = self.transferOutLabel.text ?? ""
            let transferInString = self.transferInLabel.text ?? ""
            let note = self.note.text ?? ""
            
            
            
            let account = Accounts(expenditureOrIncome: ExpenditureOrIncome.expenditure.rawValue, imageName: nil, money: handlingFee, date: date, category: "雜費", subtype: "轉帳手續費", note: note, bankAccounts: transferOutString, project: "現金", location: "")
//            self.delegate?.editAccounts(account)
            
            let bankAccount = BankAccounts(transferOutName: transferOutString, transferInName: transferInString, transferOutmoney: money, transferInMoney: money, handlingFee: handlingFee, date: date, note: note)
            self.delegate?.editTransferDetails(bankAccount, account, handlingFee: handlingFee)
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alter.addAction(cancleAction)
        alter.addAction(okAction)
        present(alter, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteTransferDetailsButtonClicked(_ sender: UIButton) {
        let alter = UIAlertController(title: "刪除", message: "確定要刪除此筆轉帳嗎", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "Cancle", style: .default, handler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            if let bankAccount = self.bankAccount {
                self.delegate?.deleteTransferDetails(bankAccount)
                self.dismiss(animated: true, completion: nil)
            }
        }
        alter.addAction(cancleAction)
        alter.addAction(okAction)
        present(alter, animated: true, completion: nil)
    }
    
    
    @IBAction func transferOutButtonClicked(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "\(AllCategoriesTableViewController.self)") as? AllCategoriesTableViewController {
            controller.items = bankItems
            controller.itemsName = .transferOut
            controller.delegate = self
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func transferInButtonClicked(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "\(AllCategoriesTableViewController.self)") as? AllCategoriesTableViewController {
            controller.items = bankItems
            controller.itemsName = .transferIn
            controller.delegate = self
            present(controller, animated: true, completion: nil)
        }
    }
    
}

extension EditTransferDetailsViewController: AllCategoriesTableViewControllerDelegate {
    func getItemsString(_ allcategories: allCategories, _ itemsString: String) {
        switch allcategories {
        case .transferOut:
            transferOutLabel.text = itemsString
        case .transferIn:
            transferInLabel.text = itemsString
        default:
            break
        }
    }
    
}
