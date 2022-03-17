//
//  ReportViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/3/1.
//

import UIKit

class ReportViewController: UIViewController {

    let reportSelectedString: [String] = ["月報表", "年報表"]
    @IBOutlet weak var reportSegmented: UISegmentedControl!
    @IBOutlet weak var reportScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 0...(reportSelectedString.count - 1) {
            reportSegmented.setTitle(reportSelectedString[index], forSegmentAt: index)
        }
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func reportSelectedSegmented(_ sender: UISegmentedControl) {
        let point = CGPoint(x: reportScrollView.bounds.width * CGFloat(sender.selectedSegmentIndex), y: 0)
        reportScrollView.setContentOffset(point, animated: true)
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

extension ReportViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        reportSegmented.selectedSegmentIndex = Int(page)
        self.view.endEditing(true)
    }
}
