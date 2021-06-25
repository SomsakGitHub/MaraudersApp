//
//  BaseVC.swift
//  Marauders
//
//  Created by somsak on 24/2/2564 BE.
//

import UIKit

class BaseVC: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let loadingTextLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func startLoading() {
        strLabel = UILabel(frame: CGRect(x: 55, y: 0, width: 400, height: 66))
        strLabel.text = "Loading..."
        strLabel.font = UIFont(name: "Apple Color Emoji", size: 12)
        strLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 170, height: 66)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        // Set up its size (the super view bounds usually)
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 66, height: 66)
        // Start the loading animation
        self.activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(self.activityIndicator)
        effectView.contentView.addSubview(strLabel)
        self.activityIndicator.transform = CGAffineTransform(scaleX: 1.4, y: 1.4);
        effectView.center = view.center
        
        // Add it to the view where you want it to appear
        view.addSubview(effectView)
    }
    
    func stopLoading() {
        strLabel.removeFromSuperview()
        effectView.removeFromSuperview()
                
        // To remove it, just call removeFromSuperview()
        activityIndicator.removeFromSuperview()
    }
    
    func alert(title: String, completion:@escaping (Bool) -> Void){
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completion(true)
        }))

        self.present(alert, animated: true)
    }
    
    func inputTextFieldsAlert(title: String, message: String, placeholder: String, completion:@escaping (String?) -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = placeholder
        })

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            if let code = alert.textFields?.first?.text {
                completion(code)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Send mail again.", style: .default, handler: { action in

            completion(nil)
        }))

        self.present(alert, animated: true)
    }
}
