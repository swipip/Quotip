//
//  UserModel.swift
//  Quotip
//
//  Created by Gautier Billard on 17/05/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation

struct User: Encodable {
    var user: user
}
struct user: Encodable {
    var login: String
    var password: String
}
struct UserID{
    var token: String
    var login: String
}
