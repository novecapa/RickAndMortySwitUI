//
//  CharactersListView.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 11/6/24.
//

import SwiftUI

struct CharactersListView: View {

    enum Constants {
        static let columnNumber: CGFloat = 2
        static let columnSpacing: CGFloat = 4
        static let nameAndStatusHeight: CGFloat = 26
        static let cornerRadius: CGFloat = 12
        static let animationDuration: CGFloat = 0.32
        static let backgroundColor: Color = Color.gray.opacity(0.1)
        static let overlayBackColor: Color = Color.black.opacity(0.8)
    }

    @State var viewModel: CharactersListViewModel
    @State private var isZoomed = false
    @State private var selectedChar: Character?

    private let gridItems: [GridItem] = [
        GridItem(.flexible(), spacing: Constants.columnSpacing),
        GridItem(.flexible(), spacing: Constants.columnSpacing)
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                let frameSize = geometry.size.width / Constants.columnNumber
                NavigationStack {
                    ScrollViewReader { scroll in
                        ScrollView {
                            LazyVGrid(columns: gridItems,
                                      spacing: Constants.columnSpacing) {
                                ForEach(viewModel.characters, id: \.id) { character in
                                    CharacterCell(character,
                                                  frameSize: frameSize - Constants.columnSpacing)
                                        .frame(width: frameSize - Constants.columnSpacing,
                                               height: frameSize + Constants.nameAndStatusHeight)
                                        .onAppear {
                                            if character == viewModel.characters.last {
                                                viewModel.fetchCharacters()
                                            }
                                        }
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: Constants.animationDuration)) {
                                                isZoomed.toggle()
                                                selectedChar = character
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, Constants.columnSpacing)
                        }
                        .onChange(of: viewModel.scrollToTop) {
                            if viewModel.scrollToTop {
                                withAnimation {
                                    scroll.scrollTo(viewModel.firstItemId, anchor: .top)
                                    viewModel.scrollToTop = false
                                }
                            }
                        }
                        .navigationTitle("Rick and Morty".localized())
                        .navigationBarTitleDisplayMode(.inline)
                        .searchable(text: $viewModel.searchText,
                                    placement: .navigationBarDrawer(displayMode: .always),
                                    prompt: "Search by name".localized())
                        .navigationBarItems(trailing: Text("\(viewModel.characters.count) \("characters".localized())")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        )
                        .onAppear {
                            viewModel.fetchCharacters()
                        }
                        .background(Constants.backgroundColor)
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error".localized()),
                  message: Text(viewModel.errorMessage),
                  dismissButton: .default(Text("OK".localized())))
        }
        .overlay(
            Group {
                if isZoomed,
                   let character = selectedChar {
                    Constants.overlayBackColor
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: Constants.animationDuration)) {
                                isZoomed.toggle()
                                selectedChar = nil
                            }
                        }
                    CharacterDetailBuilder().build(character)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: Constants.animationDuration)) {
                                isZoomed.toggle()
                            }
                        }
                    .transition(.scale)
                    .cornerRadius(Constants.cornerRadius)
                }
            }
        )
    }
}

#Preview {
    CharactersListBuilder().build()
}
