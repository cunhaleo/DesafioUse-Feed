//
//  HomeViewController.swift
//  Feed
//
//  Created by Leonardo Cunha on 01/10/21.
//

import UIKit

final class ProfileViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var labelInitials: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewInitials: UIView!
    @IBOutlet weak var viewUserSection: UIView!
    
    private let userSession: UserSessionProtocol
    private let authManager: AuthManaging
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(userSession:UserSessionProtocol = UserSession.shared, authManager: AuthManaging = FirebaseAuthManager()) {
        self.userSession = userSession
        self.authManager = authManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubjectsTableView()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Perfil"
    }
    
    // MARK: - Actions
    
    @IBAction func buttonLogout(_ sender: Any) {
        FirebaseAuthManager.logout()
        let viewController = SignInViewController()
        let navBar = UINavigationController(rootViewController: viewController)
        UIApplication.shared.windows.first?.rootViewController = navBar
    }
    
    //MARK: - Methods
    
    func setupUI() {
        view.backgroundColor = AssetsManager.colorDarkerBackground
 
        viewUserSection.layer.cornerRadius = 16
        viewUserSection.backgroundColor = AssetsManager.colorBackground

        viewInitials.layer.cornerRadius = 60
    }
    
    private func setDefaultImage() {
        let name = UserSession.shared.name
        labelName.text = name
        labelInitials.text = name?.getLettersInitiais()
    }
    
    private func setupSubjectsTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: viewUserSection.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
}
