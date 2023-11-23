//
//  MovieSearchResponse.swift
//  LorenzoProject
//
//  Created by Lorenzo on 22/11/2023.
//

import Foundation

struct MovieSearchResponse: Codable {
    let results: [MovieResult]

    // Ajoutez d'autres propriétés si nécessaire
}

struct MovieResult: Codable {
    let overview: String

    // Ajoutez d'autres propriétés si nécessaire
}
