//
//  UserServices.swift
//  Movies
//
//  Created by Admin on 1/3/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Moya
import SVProgressHUD

enum UserServices {
    var  baseUrl : String {return "https://api.themoviedb.org/3/"}

    case discover(page : Int)
    case search(text : String,page : Int)
    case geners()
    case moviecast(id : Int)
    case people(id : Int)
    case similarMovie(id : Int,page : Int)
    var path : String{
        switch self {
        case .discover(let page):
            return "discover/movie?api_key=5c6a579731ab07c7411078d62d9a06b2&sort_by=popularity.desc&page=\(page)"
        case .search(let text,let page):
            return "search/movie?api_key=5c6a579731ab07c7411078d62d9a06b2&query=\(text)&page=\(page)"
        case .geners():
           return "genre/movie/list?api_key=5c6a579731ab07c7411078d62d9a06b2"
        case .moviecast(let id):
            return "movie/\(id)/credits?api_key=5c6a579731ab07c7411078d62d9a06b2"
        case .people(let castid):
            return "person/\(castid)?api_key=5c6a579731ab07c7411078d62d9a06b2"
        case .similarMovie(let id,let page):
            return "movie/\(id)/similar?api_key=5c6a579731ab07c7411078d62d9a06b2&page=\(page)"

        }
    }
    
    var method : HTTPMethod{
        switch self
        {
        case .discover( _):
            return .get
        case .search(_,_):
            return .get
        case .geners(_):
            return .get
        case .moviecast(_):
            return .get
        case .people(_):
            return .get
        case .similarMovie(_,_):
            return .get
        }

    }

}
func requsetData<T: Decodable>(apirequest : UserServices ,  parameter: [ String: Any] , decodingType: T.Type , success successCallback :  @escaping ( _ dataModel : T )->() )
{
    let requsetUrl = apirequest.baseUrl + apirequest.path
    let data = try! JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted)
    
    let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    if let json = json {
        print(json)
    }
    var request = URLRequest(url: URL.init(string:requsetUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!)
    request.httpMethod = apirequest.method.rawValue
//    request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
    
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
    SVProgressHUD.setCornerRadius(5)
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
    SVProgressHUD.setDefaultAnimationType(.flat)
    
    if  NetworkReachabilityManager()!.isReachable{
        SVProgressHUD.show(withStatus: "Loading....")
        Alamofire.request(request).responseJSON{ (response) in
            if let value = response.result.value {
                print(value)
                do {
                    if let dataDict = try? JSONSerialization.jsonObject(with: response.data!   , options: JSONSerialization.ReadingOptions.allowFragments) {
                        print(dataDict)
                        let   model : T =   try JSONDecoder().decode(decodingType.self, from: response.data!)
                        successCallback(model)
                        SVProgressHUD.dismiss()
                    }
                } catch let error {
                    print(error)
                    SVProgressHUD.showInfo(withStatus: "Connection Failed.")
                }
            }
        }
    }
    else{
        //TODO: show alet for user to check network
        print("error")
        SVProgressHUD.showInfo(withStatus: "Network Error!!")
    }
}




