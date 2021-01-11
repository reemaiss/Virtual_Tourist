//
//  locationPhotoResponse.swift
//  Virtual_Tourist_Rema
//
//  Created by Rema alsuwailm on 26/05/1442 AH.
//

import Foundation

struct getLocationPhotoResponse: Codable{
    var photos: [String]
}

struct  locationPhotoResponse: Codable{
    var photos: PhotoList
}

struct PhotoList: Codable{
    var photo: [PhotoObj]
}

struct PhotoObj: Codable{
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int64
    var title: String
    var ispublic: Int64
    var isfriend: Int64
    var isfamily: Int64
}
