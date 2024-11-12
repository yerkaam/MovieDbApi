//
//  Actors.swift
//  assignment_7
//
//  Created by Yerdaulet Orynbay on 12.11.2024.
//

import Foundation

// Структура для данных актера
struct Actors: Codable {
    let adult: Bool
    let alsoKnownAs: [String]
    let biography: String
    let birthday: String
    let deathday: String?
    let gender: Int
    let homepage: String?
    let id: Int
    let imdbID: String
    let knownForDepartment: String
    let name: String
    let placeOfBirth: String
    let popularity: Double
    let profilePath: String
    
    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography, birthday, deathday, gender
        case homepage
        case id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
}
