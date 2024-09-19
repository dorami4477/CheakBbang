//
//  EditBook.swift
//  CheakBbang
//
//  Created by 박다현 on 9/19/24.
//

import SwiftUI
import RealmSwift

struct EditBook: View {
    var book: MyBook
    @State private var rank: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isSaved = false
    @State private var readingState: ReadingState = .finished
    @State private var rating = 3.0
    private let realm: Realm = try! Realm()
    
    var body: some View {
        VStack {
            Text(book.title)
                .multilineTextAlignment(.center)
                .bold()
                .font(.system(size: 21))
                .padding(.bottom, 10)
            
            Text(book.originalTitle)
                .multilineTextAlignment(.center)
                .font(.system(size: 17))
            
            Divider()
                .padding(.vertical)
            
            Text("상태")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            HStack {
                radioSectionGroup(sectionTitle: "readingState", selectedItem: book.status, selectedColor: .accent) { index, state in
                    readingState = state
                }
            }
            
            Divider()
                .padding(.vertical)
            
            Text("내 평점")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            RratingHeartView(rating: $rating)
            
            Divider()
                .padding(.vertical)
            
            Text("독서 시작일")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            DatePicker(selection: $startDate, displayedComponents: .date) {}
                .labelsHidden()
                .padding(.bottom, 10)
            
            Text("독서 종료일")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            DatePicker(selection: $endDate, displayedComponents: .date) {}
                .labelsHidden()
            
            Spacer()
            
            Text("저장")
                .wrapToButton {
                    let data = realm.object(ofType: MyBook.self, forPrimaryKey: book.id)!
                    try! realm.write {
                        data.rate = rating
                        data.status = readingState
                        data.startDate = startDate
                        data.endDate = endDate
                    }
                    //viewModel.action(.addButtonTap(item: newItem))
                }

        }
        .padding()
        .fullScreenCover(isPresented: $isSaved, content: {
            AddBookAniView()
        })
        .onAppear{
            rating = book.rate
            startDate = book.startDate
            endDate = book.endDate
        }
    }
}
