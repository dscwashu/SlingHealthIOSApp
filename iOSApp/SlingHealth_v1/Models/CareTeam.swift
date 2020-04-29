//
//  CareTeam.swift
//  SlingHealth_v1
//
//  Created by Faith Letzkus on 3/8/20.
//  Copyright © 2020 Priyanshu. All rights reserved.
//

import Foundation

struct CareTeam: Decodable, Comparable {
    static func < (lhs: CareTeam, rhs: CareTeam) -> Bool {
           return lhs.physician < rhs.physician
    }
    //Codable
    var id: Int! //Should be the unique id in firebase
    var physician: String!
    var specialty: String!
    var physicianNumber: Int!
    var nurse: String!
    var caretaker: String!
    var caretakerNumber: Int!
}
