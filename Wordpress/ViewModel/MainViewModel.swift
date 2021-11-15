//
//  MainViewModel.swift
//  Wordpress
//
//  Created by Asil Arslan on 6.05.2021.
//

import Foundation
import SwiftyJSON

class MainViewModel: ObservableObject {
    
    @Published var headlinePosts = [Post]()
    @Published var posts = [Post]()
    @Published var categories = [Category]()
    @Published var page = 1
    @Published var isLoading = false
    @Published var isCategoryLoading = false
    @Published var isHeadlineLoading = false
    @Published var isFailed = false
    
    
    func fetchHeadlineData() {
        isHeadlineLoading = true
        guard let url = URL(string: URL_HEADLINE_POSTS) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Post].self, from: data) {
                    DispatchQueue.main.async {
                        self.isHeadlineLoading = false
                        self.headlinePosts = decodedResponse
                    }
                    return
                }
            }
            self.isHeadlineLoading = false
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
            
        }.resume()
    }
    
    func fetchLastData() {
        isLoading = true
        guard let url = URL(string: "\(URL_POSTS)&page=\(page)") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Post].self, from: data) {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.posts.append(contentsOf: decodedResponse)
                        //                            self.isLoading = false
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            DispatchQueue.main.async {
                self.isLoading = false
                self.isFailed = true
            }
            
        }.resume()
    }
    
    func fetchCategoryDatas(category: Category) {
        isLoading = true
        guard let url = URL(string: "\(URL_CATEGORY_POST)\(category.id)&page=\(page)") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Post].self, from: data) {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.posts.append(contentsOf: decodedResponse)
                        //                            self.isLoading = false
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            DispatchQueue.main.async {
                self.isLoading = false
                self.isFailed = true
            }
            
        }.resume()
    }
    
    func fetchCategoryData() {
        isCategoryLoading = true
        guard let url = URL(string: URL_CATEGORIES) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Category].self, from: data) {
                    DispatchQueue.main.async {
                        self.isCategoryLoading = false
                        self.categories = decodedResponse
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
        }.resume()
    }
}
