//
//  SearchView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchTerm = ""
    @StateObject var viewModel: SearchViewModel

    var body: some View {
        VStack{
            SearchBarView(searchText: $searchTerm, viewModel: viewModel)
                .animation(.easeInOut, value: searchTerm)
            
            if !searchTerm.isEmpty {
                ScrollView{
                    LazyVStack {
                        ForEach(viewModel.output.bookList.item, id: \.itemID) { item in
                            BookListRow(item: item)
                        }
                    }
                }

            }
        }
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ?
                    Color.red : Color.green)
            TextField("책 제목을 검색해보세요!", text: $searchText)
                .autocorrectionDisabled(true)
                .foregroundColor(Color.green)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(Color.green)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            searchText = ""
                            UIApplication.shared.endEditing()
                        }
                    , alignment: .trailing
                )
                .onSubmit {
                    print($searchText.wrappedValue)
                    viewModel.action(.searchOnSubmit(search: $searchText.wrappedValue))
                }
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.gray)
                .shadow(
                    color: Color.green.opacity(0.5),
                    radius: 10, x: 0, y: 0)
        )
        .padding()
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel())
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
