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
    @FocusState private var focusField: Bool
    @State var isAnimating: Bool = false

    var body: some View {
        VStack{
            SearchBarView(searchText: $searchTerm, viewModel: viewModel, focus: _focusField)
                .background {
                    GeometryReader { geometry in
                        if viewModel.output.bookList.totalResults == 0 {
                            Image(ImageName.searchBack)
                                .resizable()
                                .frame(width: geometry.size.width, height: geometry.size.width * 1.18)
                                .offset(x: isAnimating ? 0 : geometry.size.width, y:  isAnimating ? -40 : 260)
                        }
                    }
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isAnimating = true
                        }
                    }
                }
            
            if !searchTerm.isEmpty || focusField {
                ScrollView{
                    LazyVStack {
                        ForEach(viewModel.output.bookList.item, id: \.itemID) { item in
                            BookListRow(item: item)
                        }
                    }
                }
                .onAppear{
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isAnimating = false
                    }
                }
            }
            
        }
        .animation(.easeInOut, value: searchTerm)
        .animation(.easeInOut, value: focusField)
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    @StateObject var viewModel: SearchViewModel
    @FocusState var focus: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ?
                    Color.gray : Color.black)
            TextField("책 제목을 검색해보세요!", text: $searchText)
                .autocorrectionDisabled(true)
                .foregroundColor(Color.black)
                .focused($focus, equals: true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(Color.black)
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
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.black, lineWidth: 4)
                )
        )
        .padding(.horizontal)
        .navigationTitle("도서검색")
        .navigationBarTitleDisplayMode(.inline)
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
