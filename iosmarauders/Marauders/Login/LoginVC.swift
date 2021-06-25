//
//  LoginVC.swift
//  Marauders
//
//  Created by somsak on 23/2/2564 BE.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class LoginVC: BaseVC, LoginModelDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var googleSignIn = GIDSignIn.sharedInstance()
    private var viewModel: LoginModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = LoginModel(view: self)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
//        if self.emailTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty {
//            self.alert(title: "Please enter a username and password.") { (bool) in }
//        }else{
//            login()
//        }
        
        redirectView()
    }
    
    func login(){
        self.startLoading()
        self.viewModel.login(
            email: self.emailTextField.text!,
            password: self.passwordTextField.text!
        )
    }
    
    @IBAction func googleLoginBtnAction(_ sender: UIButton) {
        self.googleAuthLogin()
    }
    
    @IBAction func facebookLoginBtnAction(_ sender: UIButton) {
        self.facebookAuthLogin()
    }
    
    func googleAuthLogin() {
        self.googleSignIn?.presentingViewController = self
        self.googleSignIn?.clientID = "69307359716-vdnamal5866cpk7ohiqa8073h5qcql2a.apps.googleusercontent.com"
        self.googleSignIn?.delegate = self
        self.googleSignIn?.signIn()
    }
    
    func facebookAuthLogin(){
        
        let loginManager = LoginManager()
        
        if let _ = AccessToken.current {
            // Access token available -- user already logged in
            // Perform log out
            
            // 2
            loginManager.logOut()
            
        } else {
            // Access token not available -- user already logged out
            // Perform log in
            
            // 3
            loginManager.logIn(permissions: [], from: self) {(result, error) in
                
                // 4
                // Check for error
                guard error == nil else {
                    // Error occurred
                    print(error!.localizedDescription)
                    return
                }
                
                // 5
                // Check for cancel
                guard let result = result, !result.isCancelled else {
                    print("User cancelled login")
                    return
                }
                
                // Successfully logged in
                // 6
                print("isLoggedIn", true)
                
                // 7
                Profile.loadCurrentProfile { (profile, error) in
                    print("Profile.current?.name", Profile.current?.name as Any)
                }
            }
        }
    }
    
    func didFinishLogin(_ status: StatusWebServiceEnum) {
        self.startLoading()

        switch status {
        case .success:
            self.alert(title: "Login success."){(bool) in
                self.redirectView()
            }
            break
        case .badRequest:
            self.alert(title: "Failed to login."){(bool) in }
            break
        default:
            break
        }
    }
    
    func didFinishGoogleAuthLogin(){
        redirectView()
    }
    
    func redirectView(){
        
        let userModel = UserModel(accessToken: "12345999")
        UserCoreData().saveUserData(userData: userModel)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController()
    }

}

extension LoginVC: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard let user = user else {
            print("Uh oh. The user cancelled the Google login.")
            return
        }
        
        let userId = user.userID ?? ""
        print("Google User ID: \(userId)")
        
        let userIdToken = user.authentication.idToken ?? ""
        print("Google ID Token: \(userIdToken)")
        
        let userFirstName = user.profile.givenName ?? ""
        print("Google User First Name: \(userFirstName)")
        
        let userLastName = user.profile.familyName ?? ""
        print("Google User Last Name: \(userLastName)")
        
        let userEmail = user.profile.email ?? ""
        print("Google User Email: \(userEmail)")
        
        let googleProfilePicURL = user.profile.imageURL(withDimension: 150)?.absoluteString ?? ""
        print("Google Profile Avatar URL: \(googleProfilePicURL)")
        
//        didFinishgoogleAuthLogin()
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}
