//
//  AddAgentViewController.swift
//  MachineCypher
//
//  Created by Sonal Verma on 2018-07-30.
//  Copyright © 2018 Sonal Verma. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class AddAgentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
     var coreData = CoreDataConnection.sharedInstance
     var encryption:Encryption = Encryption()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    @IBOutlet weak var lblAgentName: UILabel!
    @IBOutlet weak var txtAgentName: UITextField!
    @IBOutlet weak var lblAgentEmail: UILabel!
    @IBOutlet weak var txtAgentEmail: UITextField!
    @IBOutlet weak var missionPicker: UIPickerView!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    
    var pickerMission: [String] = [String]()
    var pickerCountry: [String] = [String]()
    var pickerDate: [String] = [String]()
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Add Agent"
        
        // Hide the navigation bar on the this view controller
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Agents"
        
        // Connect data:
        missionPicker.delegate = self
        missionPicker.dataSource = self
        countryPicker.delegate = self
        countryPicker.dataSource = self
        

        pickerMission = ["I", "R", "P"]
        pickerCountry = ["Afghanistan","Australia","Bangladesh","Brazil","Canada","France","Germany","India","Japan","Singapore","SouthAfrica"]
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return pickerMission.count
        } else if pickerView.tag == 2{
            return pickerCountry.count
        }else if pickerView.tag == 3{
            return pickerDate.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return pickerMission[row]
        } else if pickerView.tag == 2{
            return pickerCountry[row]
        }else if pickerView.tag == 3{
            return pickerDate[row]
        }
        return ""
    }
    
    func saveToCoreData(_ name: String){
        var myStringArr = name.components(separatedBy: " ")
        dump(myStringArr)
        let agent = coreData.createManagedObject(entityName: CoreDataConnection.kItem) as! Agent
        
        agent.name = myStringArr[0]
        agent.email = myStringArr[1]
        agent.mission = myStringArr[2]
        agent.country = myStringArr[3]
        
        coreData.saveDatabase { (success) in
            
            if (success){
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            }
            
        }
    }
    
    
    @IBAction func btnSaveAgent(_ sender: UIButton) {
        
        let nameRegx = "^[a-zA-Z]{4,}(?: [a-zA-Z]+){0,2}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegx)
        let emailRegx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegx)
        
        if((txtAgentName.text!.isEmpty) || (txtAgentEmail.text!.isEmpty)){
            let infoAlert = UIAlertController(title: "Error", message: "Fields cannot be empty", preferredStyle: .alert)
            infoAlert.addAction(UIAlertAction(title: "Try Again", style: .destructive, handler: nil))
            self.present(infoAlert, animated: true, completion: nil)
            return
        } else if(emailTest.evaluate(with: txtAgentEmail.text) == false){
            let infoAlert = UIAlertController(title: "Error", message: "Invalid Email Address", preferredStyle: .alert)
            infoAlert.addAction(UIAlertAction(title: "Try Again", style: .destructive, handler: nil))
            self.present(infoAlert, animated: true, completion: nil)
            return
        }else if(nameTest.evaluate(with: txtAgentName.text) == false){
            let infoAlert = UIAlertController(title: "Error", message: "Name Not Valid", preferredStyle: .alert)
            infoAlert.addAction(UIAlertAction(title: "Try Again", style: .destructive, handler: nil))
            self.present(infoAlert, animated: true, completion: nil)
            return
        }
        
        datePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        print(selectedDate)
        
        let nameToEncrypt = txtAgentName.text
        print(nameToEncrypt!)
        let agentNameEncrypted = encryption.encrypt(value: nameToEncrypt!)
        print(agentNameEncrypted)
        let emailToEncrypt = txtAgentEmail.text
        print(emailToEncrypt!)
        let agentEmailEncrypted = encryption.encrypt(value: emailToEncrypt!)
        print(agentEmailEncrypted)
        let missionToEncrypt = pickerMission[missionPicker.selectedRow(inComponent: 0)]
        print(missionToEncrypt)
        let agentMissionEncrypted = encryption.encrypt(value: missionToEncrypt)
        print(agentMissionEncrypted)
        let countryToEncrypt = pickerCountry[countryPicker.selectedRow(inComponent: 0)]
        print(countryToEncrypt)
        let agentCountryEncrypted = encryption.encrypt(value: countryToEncrypt)
        print(agentCountryEncrypted)
        let dateEncrypted = encryption.encrypt(value: selectedDate)
        
        let combineString = agentNameEncrypted + " " + agentEmailEncrypted + " " + agentMissionEncrypted + " " + agentCountryEncrypted + " " + dateEncrypted
        print(combineString)
        
        
        if(txtAgentName?.text != "" && txtAgentEmail?.text != ""){
            let newAgent = NSEntityDescription.insertNewObject(forEntityName: "Agent", into: context)
            newAgent.setValue(agentNameEncrypted, forKey: "name")
            newAgent.setValue(agentEmailEncrypted, forKey: "email")
            newAgent.setValue(agentMissionEncrypted, forKey: "mission")
            newAgent.setValue(agentCountryEncrypted, forKey: "country")
            newAgent.setValue(dateEncrypted, forKey: "date")
            
            do{
                try context.save()
            }catch{
                print(error)
            }
        }
        
//        self.saveToCoreData(combineString)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
//        self.dismiss(animated: true, completion: nil);

        
    }

}

