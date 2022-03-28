//
//  AddAccountViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/11.
//

import UIKit
protocol AddAccountViewControllerDelegate {
    func addIncomeAccount(_ account: Accounts)
    func addExpenditureAccount(_ account: Accounts)
    func addTransferMoneyHandlingFee(_ account: Accounts, bankAccount: BankAccounts, handlingFee: Double)
    func addWithdrawMoneyHandlingFee(_ account: Accounts, withdrawalBank: WithdrawalBanks, handlingFee: Double)
}


class AddAccountViewController: UIViewController {
    
    let accountSelectString: [String] = ["收入", "支出", "常用", "轉帳", "提款"]
    
    static let moveToIncomeNotification = Notification.Name("moveToIncome")
    static let moveToExpenditureNotification = Notification.Name("moveToExpenditure")
    
    static var addAccountDelegate: AddAccountViewControllerDelegate?
    static var selectedDate: Date?
    
    @IBOutlet weak var accountSegmented: UISegmentedControl!
    @IBOutlet weak var accountScrollView: UIScrollView!
    
    
    var currentRootViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor(red: 217/255, green: 191/255, blue: 132/255, alpha: 1)
        
        for index in 0...(accountSelectString.count - 1) {
            accountSegmented.setTitle(accountSelectString[index], forSegmentAt: index)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(moveToIncomeViewController), name: FrequentlyUsedViewController.frequentlyIncomeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveToExpenditureViewController), name: FrequentlyUsedViewController.frequentlyExpeditureNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func moveToIncomeViewController(_ noti: Notification) {
        
        if let user = noti.userInfo,
           let incomeAccount = user[ExpenditureOrIncome.income.rawValue] as? FrequentlyUsedIncome {
            NotificationCenter.default.post(name: AddAccountViewController.moveToIncomeNotification, object: nil, userInfo: [ExpenditureOrIncome.income.rawValue: incomeAccount])
            
            let point = CGPoint(x: 0, y: 0)
            accountScrollView.setContentOffset(point, animated: true)
            accountSegmented.selectedSegmentIndex = 0
        }
        
    }
    
    @objc func moveToExpenditureViewController(_ noti: Notification) {
        if let user = noti.userInfo,
           let expenditureAccount = user[ExpenditureOrIncome.expenditure.rawValue] as? FrequentlyUsedExpenditure {
            NotificationCenter.default.post(name: AddAccountViewController.moveToExpenditureNotification, object: nil, userInfo: [ExpenditureOrIncome.expenditure.rawValue: expenditureAccount])
            
            let point = CGPoint(x: accountScrollView.bounds.width * 1, y: 0)
            accountScrollView.setContentOffset(point, animated: true)
            accountSegmented.selectedSegmentIndex = 1
        }
        
        
    }
    @IBAction func dismissAddAccountViewButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AccountSelectedSegmented(_ sender: UISegmentedControl) {
        let point = CGPoint(x: accountScrollView.bounds.width * CGFloat(sender.selectedSegmentIndex), y: 0)
        accountScrollView.setContentOffset(point, animated: true)
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
    
}

extension AddAccountViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        accountSegmented.selectedSegmentIndex = Int(page)
        self.view.endEditing(true)
    }
}
