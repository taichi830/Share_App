//
//  SecondViewController.swift
//  Article
//
//  Created by taichi on 2021/11/22.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var passedText = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = passedText
    }
    

}
