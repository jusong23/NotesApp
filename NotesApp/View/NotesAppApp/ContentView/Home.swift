//
//  Home.swift
//  NotesApp
//
//  Created by Balaji Venkatesh on 24/10/23.
//

import SwiftUI
import SwiftData

struct Home: View {
    /// List Selection (Going to use this as a Tab to filter the selected cateogry notes)
    @State private var selectedTag: String? = "All Notes"
    /// Quering All Categories
    @Query(animation: .snappy) private var categories: [NoteCategory]
    /// Model Context
    @Environment(\.modelContext) private var context
    /// View Properties
    @State private var addCategory: Bool = false
    @State private var categoryTitle: String = ""
    @State private var requestedCategory: NoteCategory?
    @State private var deleteRequest: Bool = false
    @State private var renameRequest: Bool = false
    /// Dark Mode Toggle
    @State private var isDark: Bool = true
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTag) {
                Text("All Notes")
                    .tag("All Notes")
                    .foregroundStyle(selectedTag == "All Notes" ? Color.primary : .gray)
                
                Text("Favourites")
                    .tag("Favourites")
                    .foregroundStyle(selectedTag == "Favourites" ? Color.primary : .gray)
                
                /// User Created Categories
                Section {
                    ForEach(categories) { category in
                        if (isExist(category.categoryTitle)) {
                            HStack() {
                                Image("ic_swift")
                                
                                Text(category.categoryTitle)
                                    .tag(category.categoryTitle)
                                    .foregroundStyle(selectedTag == category.categoryTitle ? Color.primary : .gray)
                                    /// Some basic Editing Options
                                    .contextMenu {
                                        Button("Rename") {
                                            /// Placing the Already Having title in the TextField
                                            categoryTitle = category.categoryTitle
                                            requestedCategory = category
                                            renameRequest = true
                                        }
                                        
                                        Button("Delete") {
                                            categoryTitle = category.categoryTitle
                                            requestedCategory = category
                                            deleteRequest = true
                                        }
                                    }
                                    .background(Color(hex: getColor(category.categoryTitle)))
                                    .foregroundColor(.white)
                                    .cornerRadius(4)
                                    .font(.title3)
                                    .listRowBackground(isDark ? Color(hex: "575452") : Color(hex: "E2E1DF"))
                            }

                        } else {
                            Text(category.categoryTitle)
                                .tag(category.categoryTitle)
                                .foregroundStyle(selectedTag == category.categoryTitle ? Color.primary : .gray)
                                /// Some basic Editing Options
                                .contextMenu {
                                    Button("Rename") {
                                        /// Placing the Already Having title in the TextField
                                        categoryTitle = category.categoryTitle
                                        requestedCategory = category
                                        renameRequest = true
                                    }
                                    
                                    Button("Delete") {
                                        categoryTitle = category.categoryTitle
                                        requestedCategory = category
                                        deleteRequest = true
                                    }
                                }
                                .listRowBackground(isDark ? Color(hex: "575452") : Color(hex: "E2E1DF"))
                        }
                    }
                } header: {
                    HStack(spacing: 5) {
                        Text("Categories")
                        
                        Button("", systemImage: "plus") {
                            addCategory.toggle()
                        }
                        .tint(.gray)
                        .buttonStyle(.plain)
                    }
                }
            }
            .background(isDark ? Color(hex: "575452") : Color(hex: "#E2E1DF"))
        } detail: {
            /// Notes View With Dynamic Filtering Based on the Category
            NotesView(category: selectedTag, allCategories: categories)
        }
        .navigationTitle(selectedTag ?? "Notes")
        /// Adding Category Alert
        .alert("Add Category", isPresented: $addCategory) {
            TextField("Work", text: $categoryTitle)
            
            Button("Cancel", role: .cancel) {
                categoryTitle = ""
            }
            
            Button("Add") {
                /// Adding New Category to Swift Data
                let category = NoteCategory(categoryTitle: categoryTitle)
                context.insert(category)
                categoryTitle = ""
            }
        }
        /// Rename Alert
        .alert("Rename Category", isPresented: $renameRequest) {
            TextField("Work", text: $categoryTitle)
            
            Button("Cancel", role: .cancel) {
                categoryTitle = ""
                requestedCategory = nil
            }
            
            Button("Rename") {
                if let requestedCategory {
                    requestedCategory.categoryTitle = categoryTitle
                    categoryTitle = ""
                    self.requestedCategory = nil
                }
            }
        }
        /// Delete Alert
        .alert("Are you sure to delete \(categoryTitle) category?", isPresented: $deleteRequest) {
            Button("Cancel", role: .cancel) {
                categoryTitle = ""
                requestedCategory = nil
            }
            
            Button("Delete", role: .destructive) {
                if let requestedCategory {
                    context.delete(requestedCategory)
                    categoryTitle = ""
                    self.requestedCategory = nil
                }
            }
        }
        /// Tool Bar Items
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 10) {
                    Button("", systemImage: "plus") {
                        /// Adding New Note
                        let note = Note(content: "", imageUrl: "") // (1) Note 프로퍼티 초기화
                        context.insert(note)
                    }
                    
                    Button("", systemImage: isDark ? "sun.min" : "moon") {
                        /// Dark - Light Mode
                        isDark.toggle()
                    }
                    .contentTransition(.symbolEffect(.replace))
                }
            }
        }
        .preferredColorScheme(isDark ? .dark : .light)
    }
    
    func isExist(_ categoryTitle: String) -> Bool {
        if (LanguageSet.contents.contains(where: { $0.name == categoryTitle })) { return true } else { return false }
    }
    
    func getColor(_ categoryTitle: String) -> String {
        if let index = LanguageSet.contents.firstIndex(where: { $0.name == categoryTitle }) {
            return LanguageSet.contents[index].colorCode
        }
        return ""
    }
}

#Preview {
    ContentView()
}
