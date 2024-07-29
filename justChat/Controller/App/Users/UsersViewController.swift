//
//  UsersViewController.swift
//  justChat
//
//  Created by Наталья Атюкова on 20.03.2023.
//

import UIKit

class UsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let service = Service.shared
    var users = [CurrentUsers]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "UserCellTableViewCell", bundle: nil), forCellReuseIdentifier: UserCellTableViewCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none //убирает полоски между строками в таблице
        
        getUsers()
    }
    
    func getUsers(){
        service.getAllUsers { users in
            self.users = users
            self.tableView.reloadData()
        }

        
    }

}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource{ // кол-во ячеек и взаимодействие с ячейками
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCellTableViewCell.reuseId, for: indexPath) as! UserCellTableViewCell
        cell.selectionStyle = .none //убирает выделение ячейки
        let cellName = users[indexPath.row] //считает яйчейки в бд
        cell.configCell(cellName.email)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { //высота ячеек
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userId = (users[indexPath.row].id)
        
        let vc = ChatViewController()
        
        vc.otherID = userId
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
