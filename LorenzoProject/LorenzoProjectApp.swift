//
//  LorenzoProjectApp.swift
//  LorenzoProject
//
//  Created by Lorenzo on 20/11/2023.
//

import SwiftUI

@main
struct LorenzoProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(myMovieList: MovieList(movies: []))
        }
    }
}
