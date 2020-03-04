//
//  Medication.swift
//  SlingHealth_v1
//
//  Created by Faith Letzkus on 1/19/20.
//  Copyright © 2020 Priyanshu. All rights reserved.
//

import Foundation

struct Medication: Decodable, Comparable {
    static func < (lhs: Medication, rhs: Medication) -> Bool {
        return lhs.startDate < rhs.startDate
    }
    //Codable
    var id: Int! //Should be the unique id in firebase
    var name: String!
    var dose: String!
    var startDate: Date!
    var frequency: String!
    var prescriber: String!
    var notes: String!
    var stillTaking: Bool!
}



//    
//    enum CodingKeys: String, CodingKey {
//        case name
//        case description
//        case startDate
//        case frequency
//        case notes
//        case user
//    }
//}
