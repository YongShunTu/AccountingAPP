//
//  WithdrawMoneyViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/15.
//

import UIKit

class WithdrawMoneyViewController: UIViewController {

    @IBOutlet var allView: [UIView]!
    @IBOutlet weak var money: UITextField!
    @IBOutlet weak var handlingFee: UITextField!
    @IBOutlet weak var selectedDate: UIDatePicker!
    @IBOutlet weak var transferOutLabel: UILabel!
    @IBOutlet weak var note: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateWithdrawMoneyStyle()
    }
    
    func updateWithdrawMoneyStyle() {
        for view in allView {
            view.backgroundColor = UIColor(red: 231/255, green: 207/255, blue: 168/255, alpha: 0.4)
            view.layer.cornerRadius = 10
            view.layer.borderWidth = 1
            view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
        money.textColor = UIColor(red: 123/255, green: 139/255, blue: 111/255, alpha: 1)
        handlingFee.textColor = UIColor(red: 240/255, green: 164/255, blue: 141/255, alpha: 1)
        transferOutLabel.text = bankItems[0]
//        selectedDate.date = AddAccountViewController.selectedDate!
        money.addKeyboardReturn()
        handlingFee.addKeyboardReturn()
        note.addKeyboardReturn()
        addTapGesture()
    }
    
    func addTapGesture(){
            let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            view.addGestureRecognizer(tap)
        }
    
    @objc private func hideKeyboard(){
        self.view.endEditing(true)
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func addWithdrawMoneyButtonClicked(_ sender: UIButton) {
        let alter = UIAlertController(title: "提款", message: "確定要提款嗎", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "Cancle", style: .default, handler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            let money = Double(self.money.text ?? "") ?? 0.0
            let handlingFee = Double(self.handlingFee.text ?? "") ?? 0.0
            let date = self.selectedDate.date
            let transferOutString = self.transferOutLabel.text ?? ""
            let note = self.note.text ?? ""
            
            
            
            let account = Accounts(expenditureOrIncome: ExpenditureOrIncome.expenditure.rawValue, imageName: nil, money: handlingFee, date: date, category: "雜費", subtype: "提款手續費", note: note, bankAccounts: transferOutString, project: "現金", location: "")
            
            let withdrawalBank = WithdrawalBanks(money: money, handlingFee: handlingFee, transferOutName: transferOutString, transferOutMoney: money, date: date, note: note)
            
            AddAccountViewController.addAccountDelegate?.addWithdrawMoneyHandlingFee(account, withdrawalBank: withdrawalBank, handlingFee: handlingFee)

            self.dismiss(animated: true, completion: nil)
        }
        
        alter.addAction(cancleAction)
        alter.addAction(okAction)
        present(alter, animated: true, completion: nil)
    }
    
    @IBAction func transferOutButtonClciked(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "\(AllCategoriesTableViewController.self)") as? AllCategoriesTableViewController {
            controller.items = bankItems
            controller.itemsName = .transferOut
            controller.delegate = self
            present(controller, animated: true, completion: nil)
        }
    }

}

extension WithdrawMoneyViewController: AllCategoriesTableViewControllerDelegate {
    func getItemsString(_ allcategories: allCategories, _ itemsString: String) {
        transferOutLabel.text = itemsString
    }
    
    func getTransferOutString(_ transferOutString: String) {
        transferOutLabel.text = transferOutString
    }
    
    
}
