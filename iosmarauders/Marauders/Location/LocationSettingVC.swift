//
//  LocationSettingVC.swift
//  Marauders
//
//  Created by somsak on 24/2/2564 BE.
//

import UIKit

class LocationSettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        UserDefaults.standard.set(true, forKey: "locationSettingVC")
    }
    
    @IBAction func openSettingAction(_ sender: Any) {
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
}
