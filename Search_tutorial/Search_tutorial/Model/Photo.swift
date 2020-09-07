//
//  Photo.swift
//  Search_tutorial
//
//  Created by 강민채 on 2020/09/07.
//  Copyright © 2020 minchae. All rights reserved.
//

import Foundation

struct Photo: Codable{
    var thumnail: String
    var userName: String
    var likesCount: Int
    var createdAt: String
}
