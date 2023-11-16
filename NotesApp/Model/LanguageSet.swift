//
//  LanguageSet.swift
//  NotesApp
//
//  Created by jusong on 11/16/23.
//

import SwiftUI

struct Language {
    var image: String
    var name: String
    var colorCode: String
    
    init(image: String, name: String, colorCode: String) {
        self.image = image
        self.name = name
        self.colorCode = colorCode
    }
}

struct LanguageSet {
    static var contents: [Language] = [
        Language(image: "ic_swift", name: "swift", colorCode: "F05138")
    ]
}
