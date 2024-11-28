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
    var name: String
    var nickname: String
    var blood_type: String
    var gender: String
    var birth_year: Int
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
    
    func saveUserData(uid: String, password: String) {
        data = User(uid: uid, name: "", nickname: "", blood_type: "", gender: "", birth_year: 0, profile_image: "")
    }
    
    func updateUserProfile(name: String, nickname: String, birthYear: Int, gender: String, bloodType: String, profileImage: String) {
        data?.name = name
        data?.nickname = nickname
        data?.blood_type = bloodType
        data?.gender = gender
        data?.birth_year = birthYear
        data?.profile_image = profileImage
    }
    
    func signUp() async throws {
        guard let data = data else {
                    print("Error: User data is not set")
                    return
                }
        
        defaultURL.path = "/user/signup"
        guard let url = defaultURL.url else {
            return
        }
        
        let parameters: [String: Any] = [
                    "uid": data.uid,
                    "name": data.name,
                    "nickname": data.nickname,
                    "blood_type": data.blood_type,
                    "gender": data.gender,
                    "birth_year": data.birth_year,
                    "profile_image": data.profile_image
                ]
        
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
