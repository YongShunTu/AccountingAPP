//
//  ExpenditureViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/11.
//

import UIKit

//class ExpenditureViewController: UIViewController {
//
//    @IBOutlet var selectView: [UIView]!
//    @IBOutlet weak var categoryView: UIView!
//    @IBOutlet weak var categoryLael: UILabel!
//
//    var currentCatrgoryViewController: UIViewController?
//    
//
//    var categoryString: String? {
//        didSet {
//            categoryLael.text = categoryString
//            self.categoryView.isHidden = true
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        categoryView.isHidden = true
//
//
//        // Do any additional setup after loading the view.
//        for view in selectView {
//            view.layer.cornerRadius = 10
//            view.layer.borderWidth = 1
//            view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
//        }
//        print("Expenditure viewDidload")
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        print("ExpenditureView did appear")
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        print("ExpenditureView did disappear")
//    }
//
//    func addViewControllerToContainerView(_ viewController: UIViewController, contaioner: UIView) {
//        if let targetView = viewController.view {
//            contaioner.addSubview(targetView)
//            targetView.translatesAutoresizingMaskIntoConstraints = false
//
//            contaioner.addConstraints([
//                NSLayoutConstraint(item: targetView, attribute: .top, relatedBy: .equal, toItem: contaioner, attribute: .top, multiplier: 1, constant: 0),
//                NSLayoutConstraint(item: targetView, attribute: .leading, relatedBy: .equal, toItem: contaioner, attribute: .leading, multiplier: 1, constant: 0),
//                NSLayoutConstraint(item: targetView, attribute: .bottom, relatedBy: .equal, toItem: contaioner, attribute: .bottom, multiplier: 1, constant: 0),
//                NSLayoutConstraint(item: targetView, attribute: .trailing, relatedBy: .equal, toItem: contaioner, attribute: .trailing, multiplier: 1, constant: 0)
//            ])
//        }
//    }
//
//    @IBAction func categorySelectButtonClicked(_ sender: UIButton) {
//        categoryView.isHidden = false
//        let viewController: UIViewController?
//        viewController = CategoryTableViewController()
//        viewController?.restorationIdentifier = "\(CategoryTableViewController.self)"
//        if let controller = viewController, controller.restorationIdentifier != currentCatrgoryViewController?.restorationIdentifier {
//            self.addChild(controller)
//            addViewControllerToContainerView(controller, contaioner: categoryView)
//            currentCatrgoryViewController?.removeFromParent()
//            currentCatrgoryViewController?.view.removeFromSuperview()
//            currentCatrgoryViewController = controller
//        }
//
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let controller = segue.destination as? CategoryTableViewController {
//                    }
//    }
//
//}
