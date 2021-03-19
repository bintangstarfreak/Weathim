//
//  SettingsVC.swift
//  Weathim
//
//  Created by Bintang Aria Ramadhan on 19/03/21.
//  Copyright © 2021 Starfreak. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var changeCityTextField: UITextField!
    var  delegate: ChangeCityDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        changeCityTextField.layer.cornerRadius = 10
        changeCityTextField.layer.borderColor = UIColor.darkGray.cgColor
        changeCityTextField.layer.borderWidth = 1.0
    }
    
    @IBAction func changeCityTapped(_ sender: Any) {
        if changeCityTextField.text != "" {
         let city = changeCityTextField.text!
            delegate?.changeCity(city: city)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

    // oper data dari mainVC ke SettingsVC, protocol ini buat ganti kota
    protocol ChangeCityDelegate {
          func changeCity(city: String)
    
}
