//
//  Note.swift
//  NotesApp
//
//  Created by Balaji Venkatesh on 24/10/23.
//

import SwiftUI
import SwiftData

@Model
class Note {
    var content: String
    var imageUrl: String
    var isFavourite: Bool = false
    var category: NoteCategory?
    
    init(content: String, imageUrl: String, category: NoteCategory? = nil) {
        self.content = content
        self.imageUrl = imageUrl
        self.category = category
    }
}
