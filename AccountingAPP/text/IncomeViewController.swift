//
//  IncomeViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/11.
//

import UIKit

class IncomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("IncomeView viewDidload")
    }
    override func viewDidAppear(_ animated: Bool) {
        print("IncomeView did appear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("IncomeView did disappear")
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
