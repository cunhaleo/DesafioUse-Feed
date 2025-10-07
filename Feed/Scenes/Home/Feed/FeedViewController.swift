//
//  FeedViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit
import FirebaseFirestore

final class FeedViewController: UIViewController {
    
    private let viewModel = FeedViewModel()
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupTableView()
        viewModel.loadFeed()
        bindEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Feed"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    private func bindEvents() {
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.shouldShowLoading = { [weak self] shouldShow in
            DispatchQueue.main.async {
                if shouldShow {
                    self?.refreshControl.beginRefreshing()
                }
                else {
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.loadFeed()
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
    }
    
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as? FeedTableViewCell {
            let post = viewModel.posts[indexPath.row]
            let comments = viewModel.expandedComments(for: post.postId ?? "") ?? []
            
            cell.setup(name: post.name, date: post.formattedDate, post: post.message)
            updateHeights()
            
            if viewModel.isExpanded(postId: post.postId ?? "") {
                cell.fillComments(comments)
                updateHeights()
            }
            
            cell.didTapComments = { [weak self] in
                guard let postId = post.postId else { return }
                if self?.viewModel.isExpanded(postId: postId) == true {
                    self?.viewModel.clearComments(for: postId)
                    cell.hideComments()
                    self?.updateHeights()
                    return
                }
                
                self?.viewModel.fetchComments(for: postId) { [weak self] comments in
                    cell.fillComments(comments)
                    self?.updateHeights()
                }
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    private func updateHeights() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}
