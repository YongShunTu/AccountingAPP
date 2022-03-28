//
//  EditWithdrawalDetailsViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/15.
//

import UIKit

protocol EditWithdrawalDetailsViewControllerDelegate {
    func editWithdrawalDetails(_ withdrawalBank: WithdrawalBanks, _ account: Accounts, handlingFee: Double)
    func deleteWithdrawalDetails(_ withdrawalBank: WithdrawalBanks)
}

class EditWithdrawalDetailsViewController: UIViewController {

    @IBOutlet var allView: [UIView]!
    @IBOutlet weak var money: UITextField!
    @IBOutlet weak var handlingFee: UITextField!
    @IBOutlet weak var selectedDate: UIDatePicker!
    @IBOutlet weak var transferOutLabel: UILabel!
    @IBOutlet weak var note: UITextView!
    
    var withdrawalBank: WithdrawalBanks?
    
    var delegate: EditWithdrawalDetailsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        updateEditWithdrawalDetailsStyle()
        updateEditTransferDetails()
    }
    
    func updateEditWithdrawalDetailsStyle() {
        for view in allView {
            view.backgroundColor = UIColor(red: 231/255, green: 207/255, blue: 168/255, alpha: 0.4)
            view.layer.cornerRadius = 10
            view.layer.borderWidth = 1
            view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
        money.textColor = UIColor(red: 123/255, green: 139/255, blue: 111/255, alpha: 1)
        handlingFee.textColor = UIColor(red: 240/255, green: 164/255, blue: 141/255, alpha: 1)
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
    
    func updateEditTransferDetails() {
        if let withdrawalBank = self.withdrawalBank {
            money.text = String(format: "%.0f", withdrawalBank.transferOutMoney)
            handlingFee.text = String(format: "%.0f", withdrawalBank.handlingFee)
            selectedDate.date = withdrawalBank.date
            transferOutLabel.text = withdrawalBank.transferOutName
            note.text = withdrawalBank.note
        }
    }
    
    @IBAction func dismissEditWithdrawalDetailsButtonClicked(_ sender: UIButton) {
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
        let alter = UIAlertController(title: "修改提款", message: "確定要修改此筆提款嗎", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "Cancle", style: .default, handler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            let money = Double(self.money.text ?? "") ?? 0.0
            let handlingFee = Double(self.handlingFee.text ?? "") ?? 0.0
            let date = self.selectedDate.date
            let transferOutString = self.transferOutLabel.text ?? ""
            let note = self.note.text ?? ""
            var index: String = ""
            
            if let withdrawalBank = self.withdrawalBank {
                index = withdrawalBank.withdrawalBanksIndex
            }
            
            let account = Accounts(expenditureOrIncome: ExpenditureOrIncome.expenditure.rawValue, imageName: nil, money: handlingFee, date: date, category: "雜費", subtype: "提款手續費", note: note, bankAccounts: transferOutString, project: "現金", location: "", accountsIndex: index)
            
            let withdrawalBank = WithdrawalBanks(money: money, handlingFee: handlingFee, transferOutName: transferOutString, transferOutMoney: money, date: date, note: note, withdrawalBanksIndex: index)
            
            self.delegate?.editWithdrawalDetails(withdrawalBank, account, handlingFee: handlingFee)
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alter.addAction(cancleAction)
        alter.addAction(okAction)
        present(alter, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteTransferDetailsButtonClicked(_ sender: UIButton) {
        let alter = UIAlertController(title: "刪除", message: "確定要刪除此筆提款嗎", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "Cancle", style: .default, handler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            if let withdrawalBank = self.withdrawalBank {
                self.delegate?.deleteWithdrawalDetails(withdrawalBank)
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

    
}

extension EditWithdrawalDetailsViewController: AllCategoriesTableViewControllerDelegate {
    
    func getItemsString(_ allcategories: allCategories, _ itemsString: String) {
        self.transferOutLabel.text = itemsString
    }

}
