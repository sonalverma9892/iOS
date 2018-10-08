//
//  ViewController.swift
//  MachineCypher
//
//  Created by Sonal Verma on 2018-07-30.
//  Copyright © 2018 Sonal Verma. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var coreData = CoreDataConnection.sharedInstance
    var country = [String]()
    var agentData:[Agent] = []
    
//    var Agent: [NSManagedObject] {
//
//        get {
//
//            var resultArray:Array<NSManagedObject>!
//            let managedContext = coreData.persistentContainer.viewContext
//            //2
//            let fetchRequest =
//                NSFetchRequest<NSManagedObject>(entityName: CoreDataConnection.kItem)
//            //3
//            do {
//                resultArray = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! Array<NSManagedObject>
////                if let results = resultArray, results.count > 0 {
////                    let entityModel = results[0] as? Agent
////                    country = [entityModel?.country as! String]
////                }
//
//            } catch let error as NSError {
//                print("Could not fetch. \(error), \(error.userInfo)")
//            }
//            return resultArray
//        }
//
//    }
//
    
    @IBOutlet weak var tableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "List of Agents"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.fetchData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        
//        coreData.deleteDataCoreData()
        
    }
    
    @IBAction func goButton(_ sender: UIBarButtonItem) {
        let addAgentSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addAgentVC = addAgentSB.instantiateViewController(withIdentifier: "MapZoneStoryboard")
        self.navigationController?.pushViewController(addAgentVC, animated: true)
    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
        self.fetchData()
        self.tableView.reloadData()
    }

    @IBAction func addAgent(_ sender: UIBarButtonItem) {
        let agentFormSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let agentFormVC = agentFormSB.instantiateViewController(withIdentifier: "AgentFormViewController")
        self.navigationController?.pushViewController(agentFormVC, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let name = agentData[indexPath.row]
        cell.textLabel!.text = name.name!
        return cell
    }
    
    func fetchData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            agentData = try context.fetch(Agent.fetchRequest())
            dump(agentData)
        }catch{
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            let commit = agentData[indexPath.row]
            context.delete(commit)
            agentData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
           do{
             try context.save()
           }catch{
            print(error)
            }
        }
    }
    
}


