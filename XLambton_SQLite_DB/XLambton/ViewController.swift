//
//  ViewController.swift
//  XLambton
//
//  Created by Sonal Verma on 2018-08-09.
//  Copyright © 2018 Sonal Verma. All rights reserved.
//

import UIKit

protocol AgentsDelegate {
    func save(_ agent: Agent) -> Bool
    func reload()
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var agents: [Agent] = []
    var db: DBManager?
    var encryption:Encryption = Encryption()
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        db = DBManager()
        agents.removeAll()
        if let db = db {
            agents = db.readValues()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let db = db {
            agents.removeAll()
            agents = db.readValues()
            tableView.reloadData()
        }
    }
    

   func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return agents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = agents[indexPath.row].name
        
        return cell
    }
    
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let db = db {
                let agent = agents[indexPath.row]
                let all = db.readValues()
                print("all",all)
                print(agent)
               
                db.delete(agent)
                agents.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    @IBAction func btnGo(_ sender: UIBarButtonItem) {
        let addAgentSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addAgentVC = addAgentSB.instantiateViewController(withIdentifier: "MapZoneStoryboard")
        self.navigationController?.pushViewController(addAgentVC, animated: true)
    }
    @IBAction func addAgent(_ sender: UIBarButtonItem) {
        let agentFormSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let agentFormVC = agentFormSB.instantiateViewController(withIdentifier: "AgentFormViewController")
        self.navigationController?.pushViewController(agentFormVC, animated: true)
    }
}

extension ViewController: AgentsDelegate {
    
    func save(_ agent: Agent) -> Bool {
        if let db = db {
            return db.save(agent)
        }
        return false
    }
    
    func reload() {
        self.tableView.reloadData()
    }
}


