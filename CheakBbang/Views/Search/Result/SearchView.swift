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
    @State private var addNew = false
    @State private var toast: Toast? = nil

    var body: some View {
        VStack{
            SearchBarView(searchText: $searchTerm, viewModel: viewModel, focus: _focusField, toast: $toast)
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
                                    NavigationLazyView(SearchResultDetailView(viewModel: SearchResultDetailViewModel(), item: item))
                                } label: {
                                    BookListRow(item: item, addNew: $addNew)
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
        .navigationTitle("도서검색")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if addNew {
                toast = Toast(style: .success, message: "책이 추가되었습니다. :)")
                addNew = false
            } else {
                toast = nil
            }
        }

    }
    
    private func checkForToast() {
        if viewModel.output.bookListZero {
            toast = Toast(style: .info, message: "검색하신 책이 없습니다. \n다른 검색어를 입력해주세요 :)")
        } else if viewModel.output.searchFailure != "" {
            toast = Toast(style: .error, message: viewModel.output.searchFailure)
        } else {
            toast = nil
        }
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    @StateObject var viewModel: SearchViewModel
    @FocusState var focus: Bool
    @Binding var toast: Toast?
    
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
                            viewModel.output.bookList = []
                            viewModel.output.isLoading = false
                            viewModel.output.bookListZero = false
                            viewModel.output.searchFailure = ""
                            UIApplication.shared.endEditing()
                        }
                    , alignment: .trailing
                )
                .onSubmit {
                    if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        toast = Toast(style: .warning, message: "검색어를 입력해주세요.")
                    } else {
                        toast = nil
                        viewModel.output.isLoading = true
                        viewModel.action(.searchOnSubmit(search: $searchText.wrappedValue))
                    }

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
    }
}


