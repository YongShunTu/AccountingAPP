//
//  PathViewController.swift
//  AccountingAPP
//
//  Created by 塗詠順 on 2022/2/27.
//

import UIKit

class PathViewController: UIViewController {
    
    @IBOutlet weak var pathView: UIView!
    
    var accounts = [Accounts]()
    
    let aDegree = CGFloat.pi / 180
    let radius: CGFloat = 100
    var startDegree: CGFloat = 270
    let percentages: [CGFloat] = [25, 25, 30, 20]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let accounts = Accounts.loadAccount() {
            self.accounts = accounts
        }
        showPathView()
    }
    
    
    func showPathView() {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 2*(radius), height: 2*(radius)))
        
        for percentage in percentages {
            let endDegree = startDegree + 360 * percentage / 100
            let percentagePath = UIBezierPath()
            percentagePath.move(to: view.center)
            print("\(pathView.center)")
            percentagePath.addArc(withCenter: view.center, radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * endDegree, clockwise: true)
            let percentageLayer = CAShapeLayer()
            percentageLayer.path = percentagePath.cgPath
            percentageLayer.fillColor  = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor
            pathView.layer.addSublayer(percentageLayer)
            pathView.addSubview(createLabel(percentage: percentage, starDegree: startDegree, center: view.center))
            startDegree = endDegree
        }
    }
    
    func createLabel(percentage: CGFloat, starDegree: CGFloat, center: CGPoint) -> UILabel {
        let textCenterDegree = starDegree + 360 * percentage / 2 / 100
        let textPath = UIBezierPath(arcCenter: center, radius: radius / 2, startAngle: aDegree * textCenterDegree, endAngle: aDegree * textCenterDegree, clockwise: true)
        
        let label = UILabel()
        label.backgroundColor = UIColor.yellow
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "\(percentage)%"
        label.sizeToFit()
        label.center = textPath.currentPoint
        print("\(textPath.currentPoint)")
        return label
    }
    
    
//    func showPathView2() {
//        let aDegree = CGFloat.pi / 180
//        let lineWidth: CGFloat = 40
//        let radius: CGFloat = 50
//        var startDegree: CGFloat = 270
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 2*(radius+lineWidth), height: 2*(radius+lineWidth)))
//        let center = CGPoint(x: lineWidth + radius, y: lineWidth + radius)
//        let percentages: [CGFloat] = [30, 30, 40]
//        for percentage in percentages {
//            let endDegree = startDegree + 360 * percentage / 100
//            let percentagePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * endDegree, clockwise: true)
//            let percentageLayer = CAShapeLayer()
//            percentageLayer.path = percentagePath.cgPath
//            percentageLayer.strokeColor  = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1).cgColor
//            percentageLayer.lineWidth = lineWidth
//            percentageLayer.fillColor = UIColor.clear.cgColor
//            view.layer.addSublayer(percentageLayer)
//            startDegree = endDegree
//        }
//        
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
