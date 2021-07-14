//
//  ObjectAnnouncement.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 29/04/21.
//

import UIKit

class ObjectAnnouncement: FireStorageCodable {
    var profilePic: UIImage?
    var profilePicLink: String?
    var announcementPics: [UIImage]?
    var announcementPicsLink: [String]?
    
    var id = UUID().uuidString
    var userId:String?
    var userName:String?
    var title: String?
    var description: String?
    var zipcode: String?
    var state: String?
    var city: String?
    var district: String?
    var insertDate:String?
  
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(userId, forKey: .userId)
        try container.encodeIfPresent(userName, forKey: .userName)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(zipcode, forKey: .zipcode)
        try container.encodeIfPresent(announcementPicsLink, forKey: .announcementPicsLink)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(district, forKey: .district)
        try container.encodeIfPresent(insertDate, forKey: .insertDate)
    }
  
    init() {}

    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decodeIfPresent(String.self, forKey: .userId)
        userName = try container.decodeIfPresent(String.self, forKey: .userName)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        zipcode = try container.decodeIfPresent(String.self, forKey: .zipcode)
        announcementPicsLink = try container.decodeIfPresent([String].self, forKey: .announcementPicsLink)
        state = try container.decodeIfPresent(String.self, forKey: .state)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        district = try container.decodeIfPresent(String.self, forKey: .district)
        insertDate = try container.decodeIfPresent(String.self, forKey: .insertDate)
    }
}

extension ObjectAnnouncement {
    private enum CodingKeys: String, CodingKey {
        case id
        case userId
        case userName
        case title
        case description
        case zipcode
        case announcementPicsLink
        case state
        case city
        case district
        case insertDate
    }
}

