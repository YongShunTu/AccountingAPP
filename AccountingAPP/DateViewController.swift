//
//  DateViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/15.
//

import UIKit

class DateViewController: UIViewController {

    @IBOutlet var dateWeekend: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        changeDate()
    }
    
    func changeDate() {
        dateWeekend.datePickerMode = .dateWeekend
        
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
