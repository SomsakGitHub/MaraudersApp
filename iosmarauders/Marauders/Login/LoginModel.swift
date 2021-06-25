//
//  LoginModel.swift
//  Marauders
//
//  Created by somsak on 24/2/2564 BE.
//

import Foundation
import Alamofire
import SwiftyJSON
import CryptoSwift

protocol LoginModelDelegate {
    func didFinishLogin(_ status: StatusWebServiceEnum)
}

class LoginModel{

    private var loginModelDelegate: LoginModelDelegate?

    init(view: LoginModelDelegate) {
        self.loginModelDelegate = view
    }

    func login(email: String, password: String){

//        print("email", email)
//        print("password", password)
//
//        let passwordCrypto = password.sha512()
//        print("sha: \(passwordCrypto)")

        let service = ServiceWrapper()
        let parameters: Parameters = ["email": "email", "password": "passwordCrypto"]
        var urlRequest = URLRequest(url:  URL(string: WebServiceURL.login)!)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 10 // secs
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        service.serviceResponse(request: urlRequest) { (response, status) in
            self.loginModelDelegate?.didFinishLogin(status)
        }
    }
}
