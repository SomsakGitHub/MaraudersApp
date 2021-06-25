//
//  ServiceWrapper.swift
//  Marauders
//
//  Created by somsak on 24/2/2564 BE.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol ServiceWrapperProtocol {
    func serviceResponse(request: URLRequest, completion: @escaping (Data?,StatusWebServiceEnum) -> Void)
}

class ServiceWrapper: ServiceWrapperProtocol {

    func serviceResponse(request: URLRequest,completion : @escaping (Data?,StatusWebServiceEnum) -> Void) {
        AF.request(request).responseJSON { (response) in
            
            print("requestURL: \(request)")
            print("status code: \(String(describing: response.response?.statusCode))")
            print("data: \(String(describing: response.result))")
            
            switch response.response?.statusCode {
                case 200:
                    completion(response.data!, .success)
                    break
//                case 204:
//                    completion(nil, .noContent)
//                    break
                case 400:
                    completion(response.data!, .badRequest)
                    break
//                case 401:
//                    completion(response.data!, .unAuthorized)
//                    break
//                case 500:
//                    completion(response.data!, .internalServerError)
//                    break
                case nil:
                    completion(nil, .null)
                    break
                default :
                    completion(response.data!, .internalServerError)
            }
        }
    }
}
