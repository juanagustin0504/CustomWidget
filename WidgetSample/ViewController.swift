//
//  ViewController.swift
//  WidgetSample
//
//  Created by Webcash on 2020/12/10.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLb: UILabel! {
        didSet {
            self.titleLb.text = "홈으로 나간 뒤\n위젯을 추가해주세요."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

