//
//  FeedViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit
import FirebaseFirestore

class FeedViewController: UIViewController {
    
    private let db = Firestore.firestore()
    private var posts: [PostModel] = []
    private var users: [UserModel] = []
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var refreshing: UIScreenEdgePanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        stractPosts()
        refreshPosts()
    }
    
    func refreshPosts() {
        refreshControl.attributedTitle = NSAttributedString(string: "Atualizando")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        stractPosts()
        tableView.reloadData()
    }
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
        tableView.reloadData()
    }
    
    private func stractPosts() {
        db.collection("Posts").getDocuments { query, error in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                self.posts.removeAll()
                //self.users.removeAll()
                for document in query?.documents ?? []{
                    let dict = document.data()
                    let message = dict["message"] as? String ?? ""
                    let userId = dict["userId"] as? String ?? ""
                    let model = PostModel(message: message, userId: userId)
                    self.posts.append(model)
                    self.stractUsernames(userId)
                }
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
            }
        }
        
    }
    private func stractUsernames(_ userId: String) {
            
            db.collection("users").document(userId).getDocument() { (document, err) in //Pegando name com ID do usuario
            if let err = err {
                print(err.localizedDescription)
            } else {
                let dict = document?.data() ?? [:]
                let email = dict["email"] as? String ?? ""
                let name = dict["name"] as? String ?? ""
                let usermodel = UserModel(email: email, name: name)
                
                self.users.append(usermodel)
                
                }
            }
        }
}


extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as? FeedTableViewCell {
            let post = posts[indexPath.row]
          //  let username = users[indexPath.row]
            cell.setup(name: "Leonardo", date: "Sexta Feira", post: post.message)
          return cell
        }else{
            return UITableViewCell()
        }
    }
    
    
    
    
    
    
}
