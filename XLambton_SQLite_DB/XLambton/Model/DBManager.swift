//
//  DBManager.swift
//  XLambton
//
//  Created by Sonal Verma on 2018-08-09.
//  Copyright © 2018 Sonal Verma. All rights reserved.
//

import Foundation
import SQLite3

class DBManager {
    
    var db: OpaquePointer?
    
    init(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("XLambton.sqlite")
        
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Agents (name TEXT, email TEXT PRIMARY KEY, mission TEXT, country TEXT, date TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    
    func readValues() -> [Agent] {
        var agents: [Agent] = []
        
        let queryAgents = "SELECT * FROM Agents"
        
        var readAgent:OpaquePointer?
        
        if sqlite3_prepare(db, queryAgents, -1, &readAgent, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return []
        }
        
        while(sqlite3_step(readAgent) == SQLITE_ROW) {
            let name = String(cString: sqlite3_column_text(readAgent, 0))
            let email = String(cString: sqlite3_column_text(readAgent, 1))
            let mission = String(cString: sqlite3_column_text(readAgent, 2))
            let country = String(cString: sqlite3_column_text(readAgent, 3))
            let date = String(cString: sqlite3_column_text(readAgent, 4))
            
            var agent = Agent(name: name, email: email, mission: mission, country: country, date: date)
            
            agents.append(agent)
//            sqlite3_finalize(readAgent)
        }
        sqlite3_finalize(readAgent)
        return agents
    }
    
    func save(_ agent: Agent) -> Bool{
        let name = agent.name
        let email = agent.email
        let mission = agent.mission
        let country = agent.country
        let date = agent.date
        print(name)
        print(email)
        print(mission)
        print(country)
        print(date)
        
        if name.isEmpty {
            return false
        }
        
        // New Friend
            var saveNew: OpaquePointer?
            let query = "INSERT INTO Agents (name, email, mission, country, date) VALUES ('\(name)', '\(email)', '\(mission)', '\(country)', '\(date)')"
            
            if sqlite3_prepare(db, query, -1, &saveNew, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return false
            }
            
            //executing the query to insert values
            if sqlite3_step(saveNew) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting friend: \(errmsg)")
                return false
            }
            
            let queryID = "SELECT last_insert_rowid()"
            
            if sqlite3_prepare(db, queryID, -1, &saveNew, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return false
            }
            sqlite3_finalize(saveNew)
        return true
    }
    
    func delete (_ agent: Agent) {
        print(agent.email)
        let query = "DELETE FROM Agents WHERE email = '\(agent.email)'"
        print(query)
        
        var deleteAgent: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &deleteAgent, nil) == SQLITE_OK {
            if sqlite3_step(deleteAgent) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteAgent)
    }
}
