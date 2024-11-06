//
//  DataManager.swift
//  Health-Assistant
//
//  Created by 강희창 on 11/7/24.
//

import Foundation
import Alamofire

struct User: Codable {
    let uid: String
    let name: String
    var nickname: String
    let blood_type: String
    let gender: String
    let birth_year: Int
    var profile_image: String
    
    static let dummy = User(uid: "aa@aa.com", name: "aa", nickname: "ss", blood_type: "Rh+ B", gender: "male", birth_year: 2000, profile_image: "image")
}

final class DataManager: ObservableObject {
    @Published var data: User? = nil
    private var defaultURL: URLComponents = URLComponents()
    
    init() {
        let urlString: String = Bundle.main.infoDictionary?["UrlString"] as! String
        defaultURL.scheme = "https"
        defaultURL.host = urlString
    }
    
    func login() async throws {
        defaultURL.path = "/user/signup"
        guard let url = defaultURL.url else {
            return
        }
        let parameters: [String: Any] = ["uid": "asdfa@asdfsa.com", "name": "Awift", "nickname": "Swift", "blood_type": "RHA", "gender": "", "birth_year": 2000,  "profile_image": "asdfasd"]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
