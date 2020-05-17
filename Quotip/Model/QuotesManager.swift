//
//  QuotesManager.swift
//  Quotip
//
//  Created by Gautier Billard on 17/05/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation

class QuotesManager {
    
    static let shared = QuotesManager()
    
    private init() {
        
    }
    
    var currentUser: UserID?
    
    var decodedJson: ((QuoteModel)->Void)?
    var tags: ((Typeheads)->Void)?
    var logInAttempt: ((UserID)->Void)?
    var userNotRegistered: (()->Void)?
    
    enum RequestType{
        case quotes, tags, tagFilter
    }
    func logUser(withEmail email: String,andPassword password: String) {
        let url = "https://favqs.com/api/session"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.addValue("Token token=7905b5432c974305e0896ed0de69c124", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        let userlog = User(user: user(login: email, password: password))
        
        let jsonEncoder = JSONEncoder()
        do {
            let userJson = try jsonEncoder.encode(userlog)
            request.httpBody = userJson


//
            let requestAPI = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                if (error != nil) {
                    print(error!.localizedDescription)
                }
                if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                    
                }
                
                if error == nil {
                    do {
                        let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: String]
                        
                        if let token = object?["User-Token"],let login = object?["login"] {
                            let user = UserID(token: token ,login: login)
                            DispatchQueue.main.async {
                                self.currentUser = user
                                self.logInAttempt?(user)
                            }
                        }else{
                            
                        }
                        
                    }catch{
                        
                    }
                    
                }
                
            }
            requestAPI.resume()
        } catch {
            
        }
    }
    func addFavorite(quoteId: Int) {
        
        guard let user = currentUser else {
            userNotRegistered?()
            return
        }
        
        let url = "https://favqs.com/api/quotes/\(quoteId)/fav"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
                request.addValue("Token token=7905b5432c974305e0896ed0de69c124", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(user.token, forHTTPHeaderField: "User-Token")
        request.httpMethod = "PUT"
        
        let requestAPI = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                
            }
            
            if error == nil {
                
                print(response)
                
            }
            
        }
        requestAPI.resume()
        
        
    }
    func fetchUsersQuote(){
        guard let user = currentUser else {return}
        
        let url = "https://favqs.com/api/quotes/?filter=\(user.login)&type=user"
        fetchQuotes(url: url, type: .quotes)
    }
    func fetchTags() {
        fetchQuotes(url: "https://favqs.com/api/typeahead", type: .tags)
    }
    func fetchQuotes(withTag tag: String) {
        let url = "https://favqs.com/api/quotes/?filter=\(tag)&type=tag"
        fetchQuotes(url: url, type: .tagFilter)
        
    }
    func fetchQuotes(url: String? = "https://favqs.com/api/quotes" ,type: RequestType? = .quotes) {
        
        let request = NSMutableURLRequest(url: URL(string: url!)!)
        request.addValue("Token token=7905b5432c974305e0896ed0de69c124", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestAPI = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
            if (error != nil) {
                print(error as Any)
            }
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                //                print(httpStatus)
            }
            //             let responseAPI = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //             print("responseString = \(responseAPI)")
            
            if error == nil {
                
                let decoder = JSONDecoder()
                do {
                    switch type {
                    case .quotes,.tagFilter:
                        let decoded = try decoder.decode(QuoteModel.self, from: data!)
                        DispatchQueue.main.async {
                            self.decodedJson?(decoded)
                        }
                    case .tags:
                        let decoded = try decoder.decode(Typeheads.self, from: data!)
                        DispatchQueue.main.async {
                            self.tags?(decoded)
                        }
                    case .none:
                        break
                    }
                    
                }catch{
                    
                    switch type {
                    case .quotes,.tagFilter:
                        self.fetchQuotes()
                    case .tags:
                        self.fetchTags()
                    case .none:
                        break
                    }
                    //                    print("error while decoding JSON \(error)")
                }
                
                
            }
        }
        requestAPI.resume()
    }
    
    
}
