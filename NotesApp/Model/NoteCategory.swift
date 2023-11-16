//
//  NoteCategory.swift
//  NotesApp
//
//  Created by Balaji Venkatesh on 24/10/23.
//

import SwiftUI
import SwiftData

@Model // 힙 영역에 참조되어 있어서 class로 모델링한게 아닐까
class NoteCategory {
    var categoryTitle: String
    /// Relationship
    @Relationship(deleteRule: .cascade, inverse: \Note.category) // 이 변수가 삭제될때마다 SwiftData에 관련 항목을 모두 삭제
    var notes: [Note]?
    
    init(categoryTitle: String) {
        self.categoryTitle = categoryTitle
    }
}
