//
//  FeedViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit
import FirebaseFirestore

final class FeedViewController: UIViewController {
    
    private let viewModel: FeedViewModeling
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    init(viewModel: FeedViewModeling = FeedViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupTableView()
        viewModel.loadFeed(completion: nil)
        bindEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Feed"
    }
    
    private func bindEvents() {
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.shouldShowProgress = { [weak self] showProgress in
            showProgress ? self?.showProgressScreen() : self?.dismissProgressScreen()
        }
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.loadFeed() { [weak self] in
            self?.refreshControl.endRefreshing()
        }
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
            
            cell.setup(post: post)
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
                    self?.updateHeights(at: indexPath)
                }
            }
            
            cell.addNewComment = { [weak self] message in
                guard let postId = post.postId else { return }
                self?.viewModel.addComment(message, to: postId)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    private func updateHeights(at indexPath: IndexPath? = nil) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                guard let indexPath else { return }
                self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
            }
        }
    }
}

