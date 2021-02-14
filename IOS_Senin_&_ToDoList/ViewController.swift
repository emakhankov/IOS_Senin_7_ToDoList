//
//  ViewController.swift
//  IOS_Senin_&_ToDoList
//
//  Created by Jenya on 14.02.2021.
//

import UIKit

class ToDoItem {
    var text: String
    var isCompleted: Bool
    
    init(_ text: String)
    {
        self.text = text
        self.isCompleted = false
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
   
    
    var items: [ToDoItem] = [ToDoItem("to do item 1"), ToDoItem("to do item 2"), ToDoItem("to to item 3")]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageAdd: UIImageView!
    
    func deleteItem(itemIndex: Int)
    {
        items.remove(at: itemIndex)
        tableView.deleteRows(at: [IndexPath(row: itemIndex, section: 0)], with: .automatic)
        
        // Это нужно чтобы обновить индексы в тадице после удаления яцейки
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //addItem()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.initCell(item: items[indexPath.row], itemIndex: indexPath.row, viewController: self)
        
        //cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
    func addItem() {
        
       let ac =  UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Enter text"
        }
        
        let addButton = UIAlertAction(title: "Add", style: .default, handler: { (alertAction) in
            if ac.textFields?[0].text != "" {
                
                self.items.insert(ToDoItem(ac.textFields?[0].text ?? ""), at: 0)
                
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)  // Анимационно вставляем строчки
            }
        })
        
        let cancelButton  = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(addButton)
        ac.addAction(cancelButton)
        
        present(ac, animated: true, completion: nil)
    }
    
}


extension ViewController {
    
    // эта хрень есть у tableView и така как мы отнаследовалиь то эта хрень доступна
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var y = scrollView.contentOffset.y
        
        if y < -100 {
            y = -100
        }
        
        if y < -20 {
            imageAdd.alpha = 1
            imageAdd.frame = CGRect(x: 0, y: 98, width: UIScreen.main.bounds.size.width, height: -y)
        } else {
            imageAdd.alpha = 0
        }
        
       
        //print(scrollView.contentOffset)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //print("Законим перетягивание")
        
        if scrollView.contentOffset.y < -100 {
            addItem()
        }
    }
    
}
