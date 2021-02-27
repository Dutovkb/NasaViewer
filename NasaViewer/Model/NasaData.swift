//
//  NasaData.swift
//  NasaViewer
//
//  Created by Кирилл Дутов on 27.02.2021.
//

import UIKit

struct NasaData {
    
    var nasa_id: String?
    var title: String
    var date_created: String?
    var media_type: String?
    var href: String?
    var description: String?
    var date_created_sort: Date?
    var center: String?
    var photographer: String?
    var location: String?
    var keywords: [String]?
    
    init(nasa_id: String, title: String, date_created: String, media_type: String, href: String, description: String, date_created_sort: Date, center: String, photographer: String, location: String, keywords: [String]) {
        self.href = href
        self.nasa_id = nasa_id
        self.title = title
        self.date_created = date_created
        self.media_type = media_type
        self.description = description
        self.date_created_sort = date_created_sort
        self.center = center
        self.photographer = photographer
        self.location = location
        self.keywords = keywords
    }
}
