//
//  TextViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/12.
//

import UIKit

class TextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("text Success")
    }
    

    @IBAction func textButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
