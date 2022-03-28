//
//  AnnualReportViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/3.
//

import UIKit

class AnnualReportViewController: UIViewController {
    
    @IBOutlet weak var pathView: UIView!
    @IBOutlet weak var selectedYearPickerView: UIPickerView!
    @IBOutlet weak var selectedYearButton: UIButton!
    @IBOutlet weak var selectPickerViewBlockingView: UIView!
    @IBOutlet weak var annualReportTableView: UITableView!
    @IBOutlet weak var totalRevenue: UILabel!
    
    var accounts = [Accounts]() {
        didSet {
            specificYearsInAccounts = fetchSpecificYearsInAccounts(self.accounts, yearString)
        }
    }
    
    
    var specificYearsInAccounts = [Accounts]() {
        didSet {
            calculatePercentage()
            showPathView()
            totalRevenue.text = "總營收：\(NumberStyle.currencyStyle().string(from: NSNumber(value: calculateMonthlyIncome(.allIncome)))!)"
            annualReportTableView.reloadData()
        }
    }
    
    var years: [String] = []
    var yearString: String = "" {
        didSet {
            selectedYearButton.setTitle(yearString, for: .normal)
            specificYearsInAccounts = fetchSpecificYearsInAccounts(self.accounts, yearString)
        }
    }
    
    var percentages: [Dictionary<String, Double>.Element] = [] {
        didSet {
            let subviews = self.pathView.subviews
            for subview in subviews {
                subview.removeFromSuperview()
            }
        }
    }
    
    let layerColor: [UIColor] = [
        UIColor(red: 162/255, green: 126/255, blue: 126/255, alpha: 1),
        UIColor(red: 250/255, green: 234/255, blue: 211/255, alpha: 1),
        UIColor(red: 181/255, green: 196/255, blue: 177/255, alpha: 1),
        UIColor(red: 224/255, green: 205/255, blue: 207/255, alpha: 1),
        UIColor(red: 193/255, green: 203/255, blue: 215/255, alpha: 1),
        UIColor(red: 201/255, green: 192/255, blue: 211/255, alpha: 1),
        UIColor(red: 218/255, green: 218/255, blue: 216/255, alpha: 1),
        UIColor(red: 123/255, green: 139/255, blue: 111/255, alpha: 1),
        UIColor(red: 150/255, green: 84/255, blue: 84/255, alpha: 1),
        UIColor(red: 134/255, green: 150/255, blue: 167/255, alpha: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        selectPickerViewBlockingView.alpha = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let accounts = Accounts.loadAccount() {
            self.accounts = accounts
            fetchYears()
            selectedYearPickerView.reloadAllComponents()
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
    func showPathView() {
        
        let aDegree = CGFloat.pi / 180
        let radius: CGFloat = 125
        let incomeTotal = calculateMonthlyIncome(.allIncome)
        var startDegree: CGFloat = 270
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 2*(radius), height: 2*(radius)))
        
        var layerColorIndex = 0
        
        for percentage in percentages {
            if incomeTotal != 0 {
                let value = percentage.value / incomeTotal * 100
                let endDegree = startDegree + 360 * value / 100
                let percentagePath = UIBezierPath()
                percentagePath.move(to: view.center)
                percentagePath.addArc(withCenter: view.center, radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * endDegree, clockwise: true)
                
                let percentageLayer = CAShapeLayer()
                percentageLayer.path = percentagePath.cgPath
                percentageLayer.fillColor = layerColor[layerColorIndex].cgColor
                layerColorIndex += 1
                view.layer.addSublayer(percentageLayer)
                view.addSubview(self.createLabel(percentage: value, percentageText: percentage.key, starDegree: startDegree, radius: radius, aDegree: aDegree, center: view.center))
                self.pathView.addSubview(view)
                startDegree = endDegree
            }
        }
    }
    
    func animateCircle(time: TimeInterval, layer: CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        // 指定動畫時長
        animation.duration = time
        // 動畫是，從沒圓，到滿圓
        animation.fromValue = 0
        animation.toValue = 1
        // 指定動畫的時間函數，保持勻速
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        // 視圖具體的位置，與動畫結束的效果一致
        layer.strokeEnd = 1.0
        // 開始動畫
        layer.add(animation, forKey: "animateCircle")
    }
    
    func createLabel(percentage: CGFloat, percentageText: String, starDegree: CGFloat, radius: CGFloat, aDegree: CGFloat, center: CGPoint) -> UILabel {
        let textCenterDegree = starDegree + 360 * percentage / 2 / 100
        let textPath = UIBezierPath(arcCenter: center, radius: radius + 15, startAngle: aDegree * textCenterDegree, endAngle: aDegree * textCenterDegree, clockwise: true)
        
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 9)
        label.numberOfLines = 2
        label.textAlignment = .center
        if percentage >= 3 {
            label.text = "\(percentageText)\n\(String(format: "%.2f", percentage))%"
        }
        label.sizeToFit()
        label.center = textPath.currentPoint
        return label
    }
    
    func fetchYears() {
        let yearMonth = self.accounts.reduce(into: [String:Int]()) { (counts, accounts) in
            let dateForMatter = DateFormatter()
            dateForMatter.dateFormat = "yyyy年"
            let date = dateForMatter.string(from: accounts.date)
            counts[date, default: 1] += 0
        }
        years = yearMonth.keys.sorted(by: >)
    }
    
    func fetchSpecificYearsInAccounts(_ accounts: [Accounts], _ date: String) -> [Accounts] {
        let newArray = accounts.filter { account in
            let dateForMatter = DateFormatter()
            dateForMatter.dateFormat = "yyyy年"
            let day = dateForMatter.string(from: account.date)
            if day == date {
                return true
            }else{
                return false
            }
            
        }
        return newArray
    }
    
    func calculateMonthlyIncome(_ income: allIncome) -> Double {
        let total = self.specificYearsInAccounts.reduce(0.0) { partialResult, accounts in
            if accounts.expenditureOrIncome == ExpenditureOrIncome.income.rawValue {
                switch income {
                case .income:
                    if accounts.category == "收入" {
                        return partialResult + accounts.money
                    }
                case .allIncome:
                    return partialResult + accounts.money
                }
            }
            return partialResult
        }
        return total
    }
    
    func calulateMothlyExpenses() -> Double {
        let total = self.specificYearsInAccounts.reduce(0.0) { partialResult, accounts in
            if accounts.expenditureOrIncome == ExpenditureOrIncome.expenditure.rawValue {
                return partialResult + accounts.money
            }
            return partialResult
        }
        return total
    }
    
    func calculatePercentage() {
        let percentageReport = self.specificYearsInAccounts.reduce(into: [String: Double]()) { counts, accounts in
            var money = accounts.money
            let incomeTotal = self.calculateMonthlyIncome(.income)
            let expensesTotal = self.calulateMothlyExpenses()
            let percentage = (incomeTotal - expensesTotal) / incomeTotal
            switch ExpenditureOrIncome.init(rawValue: accounts.expenditureOrIncome) {
            case .income:
                if accounts.category == "收入" {
                    money *= percentage
                }
                counts[accounts.category, default: 0] += money
            case .expenditure:
                counts[accounts.category, default: 0] += money
            case .none:
                break
            }
        }
        
        self.percentages = percentageReport.sorted(by: { firstDictionary, secondDictionary in
            return firstDictionary.value > secondDictionary.value
        })
    }
    
}

extension AnnualReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        percentages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = annualReportTableView.dequeueReusableCell(withIdentifier: "\(ReportTableViewCell.self)", for: indexPath) as? ReportTableViewCell else
        { return UITableViewCell() }
        let account = percentages[indexPath.row]
        let totalmoney = calculateMonthlyIncome(.allIncome)
        cell.categoryLabel.text = account.key
        cell.moneyLabel.text = NumberStyle.currencyStyle().string(from: NSNumber(value: account.value))!
        cell.percentageLabel.text = "\(String(format: "%.2f", account.value / totalmoney * 100))%"
        cell.reportPhoto.image = UIImage(named: account.key)
        
        cell.categoryLabel.textColor = layerColor[indexPath.row]
        cell.moneyLabel.textColor = layerColor[indexPath.row]
        cell.percentageLabel.textColor = layerColor[indexPath.row]
        
        return cell
    }
    
    
}

extension AnnualReportViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        years[row]
    }
    
    @IBAction func showYearPickerViewButtonClicked(_ sender: UIButton) {
        if years == [] {
            let alter = UIAlertController(title: "目前無資料喔", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alter.addAction(action)
            present(alter, animated: true, completion: nil)
        }else{
            showYearPickerView()
        }
    }
    
    @IBAction func closeYearPickerViewButtonClciked(_ sender: UIButton) {
        closeYearPickerView()
    }
    
    @IBAction func selectYearButtonClicked(_ sender: UIButton) {
        let yearIndex = selectedYearPickerView.selectedRow(inComponent: 0)
        yearString = years[yearIndex]
        closeYearPickerView()
    }
    
    func showYearPickerView() {
        if let yearIndex = years.firstIndex(of: yearString) {
            self.selectedYearPickerView.selectRow(yearIndex, inComponent: 0, animated: false)
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
            self.selectPickerViewBlockingView.alpha = 1
            self.view.layoutIfNeeded()
        }
        
    }
    
    func closeYearPickerView() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
            self.selectPickerViewBlockingView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
}
