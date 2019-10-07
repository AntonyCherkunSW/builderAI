//
//  ViewController.swift
//  BuilderAITask
//
//  Created by User on 10/7/19.
//  Copyright © 2019 aCherkun. All rights reserved.
//

import UIKit

let postTableViewCellIdentifire = "PostTableViewCell"

class PostListController: UIViewController {
    @IBOutlet private weak var postsTableView: UITableView!
    private var posts = [Post]()
    private let postInterator = PostListInteractor()
    private var refreshControl = UIRefreshControl()
    private var selectionCounter = 0
    private var currentPage = 0
    private var isRefreshing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        self.postsTableView.allowsMultipleSelection = true
        self.postInterator.output = self
        self.title = "\(self.selectionCounter)"
        self.postsTableView.register(UINib(nibName: postTableViewCellIdentifire, bundle: nil), forCellReuseIdentifier: postTableViewCellIdentifire)
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.postsTableView.addSubview(refreshControl)
        
        self.loadMore()
    }
    
    @objc func refresh() {
        self.isRefreshing = true
        self.selectionCounter = 0
        self.title = "\(self.selectionCounter)"
        self.loadMore()
    }

    func updateTitle(up: Bool) {
        guard !isRefreshing else { return }
        self.selectionCounter += up ? 1 : -1
        self.title = "\(self.selectionCounter)"
    }
    
    func loadMore() {
        self.postInterator.fetchPosts(page: self.currentPage)
    }

}

extension PostListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.postsTableView.dequeueReusableCell(withIdentifier: postTableViewCellIdentifire) as! PostTableViewCell
        let post = self.posts[indexPath.row]
        cell.titleLabel.text = post.title
        cell.dateLabel.text = post.createdAt
        cell.isSelectedSwitch.isOn = post.isOn
        cell.selectionStyle = .none
        if indexPath.row == self.posts.count - 1 {
            self.loadMore()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.posts[indexPath.row].isOn = true
        let cell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
        cell.isSelectedSwitch.isOn = true
        self.updateTitle(up: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.posts[indexPath.row].isOn = false
        let cell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
        cell.isSelectedSwitch.isOn = false
        self.updateTitle(up: false)
    }
    
    
}

extension PostListController: PostListInteractorOutput {
    func updated(posts: [Post]) {
        DispatchQueue.main.async {
            self.currentPage += 1
            if self.currentPage == 1 {
                self.posts = posts
            } else {
                self.posts.append(contentsOf: posts)
            }
            self.refreshControl.endRefreshing()
            self.postsTableView.reloadData()
            self.isRefreshing = false
        }
    }
    
    
}

