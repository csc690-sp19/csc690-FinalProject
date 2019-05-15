//
//  TodoViewController.swift
//  csc690-TravelApp
//
//  Created by SiuChun Kung on 5/13/19.
//  Copyright © 2019 SiuChun Kung. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

var task = [(spotname: String, addr: String, URL: String)]()
//var task = [(spotname: String, addr: String)]()

class TodoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
//    var spot: Spot?
    var todoList = Todo()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as! TodoListCell
        
        let TodoData = task[(indexPath as NSIndexPath).row].self
        let spotname = TodoData.spotname 
        let addr = TodoData.addr
        let iconURL = URL(string: TodoData.URL)!
        
        cell.spotImage.af_setImage(withURL: iconURL)
        cell.title.text = spotname
        cell.address.text = addr
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            task.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
//            let saveData: [[String: Any]] = task.map{(["spotname": $0.spotname, "addr": $0.addr])
//            }
            let saveData: [[String: Any]] = task.map{(["spotname": $0.spotname, "addr": $0.addr, "URL": $0.URL])
            }
            UserDefaults.standard.set(saveData, forKey: "Todo")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        guard let loadData = defaults.object(forKey: "Todo") as? [[String: Any]] else {
            return
        }
//        task = loadData.map { (spotname: $0["spotname"] as! String, addr: $0["addr"] as! String)}
         task = loadData.map { (spotname: $0["spotname"] as! String, addr: $0["addr"] as! String, URL: $0["URL"] as! String)}


        tableview.rowHeight = 80
        tableview.delegate = self
        tableview.dataSource = self
        tableview.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableview.reloadData()
    }
    

  
}
