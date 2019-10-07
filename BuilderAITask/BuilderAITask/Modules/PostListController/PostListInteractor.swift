//
//  PostListControllerInteractor.swift
//  BuilderAITask
//
//  Created by User on 10/7/19.
//  Copyright © 2019 aCherkun. All rights reserved.
//

import Foundation

protocol PostListInteractorOutput {
    func updated(posts: [Post])
}

class PostListInteractor {
    private var dataTask: URLSessionDataTask?
    private var posts = [Post]()
    private var hasData = true
    
    var output: PostListInteractorOutput?
    
    func fetchPosts(page: Int) {
           let defaultSession = URLSession(configuration: .default)
       
       
           dataTask?.cancel()
               

           guard let url = URL(string: "https://hn.algolia.com/api/v1/search_by_date?tags=story&page=\(page)" ) else {
               return
           }
             dataTask =
               defaultSession.dataTask(with: url) { [weak self] data, response, error in
               defer {
                 self?.dataTask = nil
               }
               if let error = error {
                   print(error.localizedDescription)
               } else if
                 let data = data,
                 let response = response as? HTTPURLResponse,
                 response.statusCode == 200 {
                   if let posts = self?.parseToPosts(data: data) {
                       self?.output?.updated(posts: posts)
                   }
               }
             }
            
             dataTask?.resume()
       }
    
    private func parseToPosts(data: Data?) -> [Post]? {
        var posts: [Post]?
        if let jsonData = data
        {
            let decoder = JSONDecoder()
            do {
                let wrapper = try decoder.decode(PostWrapper.self, from: jsonData)
                posts = wrapper.hits.map { Post(from: $0)}
            } catch {
                print(error.localizedDescription)
            }
        }
        return posts
    }
}

