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
    @State private var toast: Toast? = nil

    var body: some View {
        VStack{
            SearchBarView(searchText: $searchTerm, viewModel: viewModel, focus: _focusField)
                .background {
                    GeometryReader { geometry in
                        if viewModel.output.bookList.count == 0 {
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
                if viewModel.output.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    ScrollView{
                        LazyVStack {
                            ForEach(viewModel.output.bookList, id: \.itemID) { item in
                                NavigationLink {
                                    NavigationLazyView(SearchResultDetailView(viewModel: SearchResultDetailViewModel(), itemId: item.isbn13))
                                } label: {
                                    BookListRow(item: item)
                                        .onAppear {
                                            viewModel.action(.loadMoreItems(item: item))
                                        }
                                }
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
            
        }
        .onTapGesture(perform: {
            UIApplication.shared.endEditing()
        })
        .toastView(toast: $toast)
        .animation(.easeInOut, value: searchTerm)
        .animation(.easeInOut, value: focusField)
        .onReceive(viewModel.$output) { _ in
            checkForToast()
        }

    }
    
    private func checkForToast() {
        if viewModel.output.bookListZero {
            toast = Toast(style: .info, message: "검색하신 책이 없습니다. \n다른 검색어를 입력해주세요 :)")
        } else if viewModel.output.searchFailure {
            toast = Toast(style: .error, message: "네트워크 오류가 발생했습니다:( \n잠시후 시도해주세요!")
        } else {
            toast = nil
        }
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    @StateObject var viewModel: SearchViewModel
    @FocusState var focus: Bool
    
    var body: some View {
        HStack {
            Image(systemName: ImageName.search)
                .foregroundColor(
                    searchText.isEmpty ?
                    Color.gray : Color.black)
            TextField("책 제목 또는 작가를 검색해보세요!", text: $searchText)
                .autocorrectionDisabled(true)
                .foregroundColor(Color.black)
                .focused($focus, equals: true)
                .overlay(
                    Image(systemName: ImageName.searchCancel)
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
                    viewModel.output.isLoading = true
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


