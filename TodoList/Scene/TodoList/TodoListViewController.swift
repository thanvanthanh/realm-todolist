//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Thanh - iOS on 19/05/2022.
//

import UIKit
import Realm
import RealmSwift

class TodoListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var image: UIImageView!
    var items = [Results<TodoItem>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        //tableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: "TodoListTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        setupData()
        image.applyBlurEffect()
        // Do any additional setup after loading the view.
    }
    
    func setupData() {
        var todos: Results<TodoItem> {
            get {
                let predicate = NSPredicate(format: "finished == false", argumentArray: nil)
                let realm = try! Realm()
                return realm.objects(TodoItem.self).filter(predicate)
            }
        }
        
        var finished: Results<TodoItem> {
            get {
                let predicate = NSPredicate(format: "finished == true", argumentArray: nil)
                let realm = try! Realm()
                return realm.objects(TodoItem.self).filter(predicate)
            }
        }
        items.append(todos)
        items.append(finished)
    }
    
    func getTodoItem(names: String) -> TodoItem? {
        let realm = try! Realm()
        return realm.objects(TodoItem.self).filter("name == %@", names).first
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "Todo List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonAction))
    }
    
    @objc
    fileprivate func addButtonAction() {
        let addToVC = AddTodoViewController()
        addToVC.doneActionCallback = { [weak self] text in
            guard let text = text,
            let self = self else { return }
            if text.utf16.count > 0 {
                let newTodoItem = TodoItem()
                newTodoItem.name = text
                
                let realm = try! Realm()
                try! realm.write({
                    realm.add(newTodoItem)
                })
                self.tableView.reloadData()
            }
        }
        let nav = UINavigationController(rootViewController: addToVC)
        present(nav, animated: true, completion: nil)
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath)
        let finishedAction = UIContextualAction(style: .normal,
                                        title: "Finished") { [weak self] (action, view, completeHandler) in
            
            if let name = cell?.textLabel?.text,
               let todoItem = self?.getTodoItem(names: name) {
                let realm = try! Realm()
                try! realm.write({
                    todoItem.finished = true
                })
                tableView.reloadData()
            }
        }
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete",
                                              handler: { [weak self] (action, view, completeHandler) in
            if let name = cell?.textLabel?.text,
               let todoItem = self?.getTodoItem(names: name) {
                let realm = try! Realm()
                try! realm.write({
                    realm.delete(todoItem)
                })
                tableView.reloadData()
            }
            
        })
        return UISwipeActionsConfiguration(actions: [ deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath)
        let finishedAction = UIContextualAction(style: .normal,
                                        title: "Finished") { [weak self] (action, view, completeHandler) in
            
            if let name = cell?.textLabel?.text,
               let todoItem = self?.getTodoItem(names: name) {
                let realm = try! Realm()
                try! realm.write({
                    todoItem.finished = true
                })
                tableView.reloadData()
            }
        }
        finishedAction.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [finishedAction])
    }
}

extension TodoListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if items[section].isEmpty {
                return nil
            }
            return "TO-DO"
        default:
            if items[section].isEmpty {
                return nil
            }
            return "Finished"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .white
//        cell.textLabel?.textColor =
        switch indexPath.section {
        case 0:
            let todoItem = items[indexPath.section][indexPath.row]
            let attributedText = NSMutableAttributedString(string: todoItem.name)
            attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributedText.length))
            cell.textLabel?.attributedText = attributedText
            
        default:
            let todoItem = items[indexPath.section][indexPath.row]
            let attributedText = NSMutableAttributedString(string: todoItem.name)
            attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedText.length))
            cell.textLabel?.attributedText = attributedText
        }
        return cell
    }
    
    
}
extension UIImageView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}
