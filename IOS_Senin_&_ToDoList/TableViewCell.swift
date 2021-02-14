//
//  TableViewCell.swift
//  IOS_Senin_&_ToDoList
//
//  Created by Jenya on 14.02.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    var item: ToDoItem!
    var itemIndex: Int!
    var viewConroller: ViewController!
    
    
    @IBOutlet weak var viewParent: UIView!
    
    @IBOutlet weak var imageCheck: UIImageView!
    
    @IBOutlet weak var labelToDoText: UILabel!
    
    @IBOutlet weak var imageTrash: UIImageView!
    
    
    func initCell(item: ToDoItem, itemIndex: Int, viewController: ViewController)
    {
        self.item = item
        self.itemIndex = itemIndex
        self.viewConroller = viewController
        
        self.viewParent.transform = .identity
        
        self.labelToDoText.text = item.text
        setChecked()
        addTap()
        addPan()
        
    }
    
    
    func setChecked() {
        
        if item.isCompleted {
            imageCheck?.image = UIImage(systemName: "checkmark.circle")
        } else {
            imageCheck?.image = UIImage(systemName: "circle")
        }
        
        UIView.animate(withDuration: 0.2) {
            
            self.imageCheck.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } completion: { (bool) in
            self.imageCheck.transform = .identity
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func addTap() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap))
        imageCheck?.gestureRecognizers = [tap]
        
    
        
    }
    
    @objc func tap() {

        item.isCompleted = !item.isCompleted
        setChecked()
    }
    
    func addPan() {
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan))
        pan.delegate = self // Хотим чтобы жест передавался также дальше
        viewParent.gestureRecognizers = [pan]
         
    }
    
    var centerParentView: CGPoint!
    @objc func pan(prg: UIPanGestureRecognizer) {
        print(prg.translation(in: viewParent))
        
        if prg.state == .began {
            centerParentView = viewParent.center;
        }
        
        let dx = prg.translation(in: viewParent).x
        //let newCenter = CGPoint(x: centerParentView.x + dx, y: centerParentView.y)
        
        if dx < 0 {
            contentView.backgroundColor = UIColor.red
        } else {
            contentView.backgroundColor = UIColor.orange
        }
        
        viewParent.transform = CGAffineTransform(translationX: dx, y: 0)
        //viewParent.center = newCenter
        
        if prg.state == .ended {
            
            if dx < -100 {
                
                // удаляем
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewParent.transform = CGAffineTransform(translationX: -500, y: 0)
                }) { (bool) in
                    self.viewConroller.deleteItem(itemIndex: self.itemIndex)
                }
                return
            }
            
            
            if dx > 100 {
                //Поменять состояние
                
                UIView.animate(withDuration: 0.2) {
                    self.viewParent.transform = .identity
                } completion: { (bool) in
                    self.item.isCompleted = !self.item.isCompleted
                    self.setChecked()
                }
                return
                
            }
            
            
            UIView.animate(withDuration: 0.2) {
                self.viewParent.transform = .identity
            }
 
        }
        
    }
    
    //Здесь просто передаем дальше
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        return true
    }

}
