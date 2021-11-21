//
//  HomeView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI
import Kingfisher


struct HomeView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    @Namespace var animation
    @Binding var showMenu : Bool
    @State var selectedCategory : Category = Category.home
    
//    var interstitial:Interstitial = Interstitial()
    
    var body: some View {
        
        ZStack {
            NavigationView {
                List {
                    
                    if IS_CATEGORIES_VISIBLE {
                        Section{
                            ScrollView(.horizontal, showsIndicators: false, content: {
                                
                                HStack(){
                                    TabButton(category: Category.home, selectedCategory: $selectedCategory, animation: animation)
                                        .onTabChanged{ (newCrop) in
                                            mainViewModel.isLoading = false
                                            mainViewModel.isFailed = false
                                            mainViewModel.posts.removeAll()
                                            mainViewModel.page = 1
                                            mainViewModel.fetchLastData()
                                        }
                                    ForEach(mainViewModel.categories){tab in
                                        
                                        // Tab Button...
                                        
                                        TabButton(category: tab, selectedCategory: $selectedCategory, animation: animation)
                                            .onTabChanged{ (category) in
                                                mainViewModel.isLoading = false
                                                mainViewModel.isFailed = false
                                                mainViewModel.posts.removeAll()
                                                mainViewModel.page = 1
                                                mainViewModel.fetchCategoryDatas(category:category)
                                            }
                                    }
                                }
                                .redacted(reason: mainViewModel.isCategoryLoading ? .placeholder : [])
                            })
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical)
                        }
                    }
                    
                    
                    if IS_HEADLINE_VISIBLE && selectedCategory.id == Category.home.id{
                        Section(header: HeaderView(text: "Headline")) {
                            
                            if HEADLINE_TYPE == .single {
                                ZStack {
                                    // embed as hidden in ZStack to remove right arrow
                                    NavigationLink(destination: NewsView(new: mainViewModel.posts.first ?? Post.default)) {
                                        //
                                    }
                                    .hidden()
                                    NewsHeadlineView(post: mainViewModel.headlinePosts.first ?? Post.default)
                                }
                            }else{
                                GeometryReader { geometry in
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 15) {
                                            ForEach(mainViewModel.headlinePosts) { item in
                                                NavigationLink(
                                                    destination: NewsView(new: item),
                                                    label: {
                                                        KFImage(URL(string: (item._embedded?.featuredmedia?.first?.media_details?.sizes?.medium?.source_url ?? EMPTY_IMAGE_URL)) ?? URL(string: EMPTY_IMAGE_URL)!)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: geometry.size.width - 50, height: 300)
                                                            .cornerRadius(35)
                                                            .overlay(
                                                                VStack(alignment: .leading) {
                                                                    Spacer()
                                                                    TitleAndDateView(post: item)
                                                                }
                                                                .padding()
                                                                .background(LinearGradient(gradient: Gradient(colors: [Color("ColorHeadline"), Color.clear]), startPoint: .bottom, endPoint: .top).cornerRadius(35))
                                                            )
                                                    })
                                            }
                                        }
                                        .redacted(reason: mainViewModel.isHeadlineLoading ? .placeholder : []) 
                                        .padding(.horizontal)
                                    }
                                }
                                .frame(height: 310).listRowInsets(EdgeInsets())
                            }
                        }
                    }
                    Section(header: HeaderView(text: "Latest")) {
                        ForEach (mainViewModel.posts) { row in
                            NavigationLink(destination: NewsView(new: row)) {
                                VStack {
                                    NewsRowView(post: row)
//                                        .padding(.leading)
                                }
                            }
                        }
                        HStack {
                            Image(systemName: "arrow.down")
                            Text("Scroll to new posts").font(.footnote)
                                .onAppear {
                                    if selectedCategory.id == Category.home.id {
                                        if !mainViewModel.isLoading && !mainViewModel.isFailed {
                                            mainViewModel.page = mainViewModel.page + 1
                                            mainViewModel.fetchLastData()
                                        }
                                    }else{
                                        if !mainViewModel.isLoading && !mainViewModel.isFailed {
                                            mainViewModel.page = mainViewModel.page + 1
                                            mainViewModel.fetchCategoryData()
                                        }
                                    }
                                    print("Reached end of scroll view")
                                }
                        }
                    }
                    .redacted(reason: mainViewModel.isLoading ? .placeholder : []) 
                }
                .navigationBarTitle(LocalizedStringKey("Home"))
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation{
                                
                                self.showMenu.toggle()
                            }
                        }, label: {
                            
                            Image(systemName: self.showMenu ? "xmark" : "line.horizontal.3")
                                .font(.title)
                                .foregroundColor(Color.black)
                        })
                    }
                })
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation{
                                mainViewModel.isFailed = false
                                mainViewModel.headlinePosts.removeAll()
                                mainViewModel.posts.removeAll()
                                mainViewModel.categories.removeAll()
                                mainViewModel.page = 1
                                mainViewModel.fetchHeadlineData()
                                mainViewModel.fetchLastData()
                                mainViewModel.fetchCategoryData()
                            }
                        }, label: {
                            
                            Image(systemName: "arrow.counterclockwise.circle")
                                .font(.title)
                                .foregroundColor(Color.black)
                        })
                    }
                })
            }
            // prevent iPad split view
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear(){
//                if !UserDefaults.standard.bool(forKey: "remove_ads") {
//                    self.interstitial.showAd()
//                }
            }
            
            if mainViewModel.isLoading {
//                ProgressView().progressViewStyle(CircularProgressViewStyle())
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showMenu: .constant(false))
    }
}
