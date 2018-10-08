//
//  AddAgentViewController.swift
//  XLambton
//
//  Created by Sonal Verma on 2018-08-09.
//  Copyright © 2018 Sonal Verma. All rights reserved.
//

import UIKit

class AddAgentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
     var encryption:Encryption = Encryption()

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var missionPicker: UIPickerView!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var pickerMission: [String] = [String]()
    var pickerCountry: [String] = [String]()
    
    var delegate: AgentsDelegate? = nil
    var agent: Agent?
    var db: DBManager = DBManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let agent = agent {
            txtName.text = agent.name
            txtEmail.text = agent.email

        } else {
            self.agent = Agent(name: "", email: "", mission: "", country: "", date: "")
        }

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
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return pickerMission[row]
        } else if pickerView.tag == 2{
            return pickerCountry[row]
        }
        return ""
    }

    @IBAction func btnSave(_ sender: UIButton) {
        var result = false
        
        let nameRegx = "^[a-zA-Z]{4,}(?: [a-zA-Z]+){0,2}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegx)
        let emailRegx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegx)
        
        if((txtName.text!.isEmpty) || (txtEmail.text!.isEmpty)){
            let infoAlert = UIAlertController(title: "Error", message: "Fields cannot be empty", preferredStyle: .alert)
            infoAlert.addAction(UIAlertAction(title: "Try Again", style: .destructive, handler: nil))
            self.present(infoAlert, animated: true, completion: nil)
            return
        } else if(emailTest.evaluate(with: txtEmail.text) == false){
            let infoAlert = UIAlertController(title: "Error", message: "Invalid Email Address", preferredStyle: .alert)
            infoAlert.addAction(UIAlertAction(title: "Try Again", style: .destructive, handler: nil))
            self.present(infoAlert, animated: true, completion: nil)
            return
        }else if(nameTest.evaluate(with: txtName.text) == false){
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
        
        let nameToEncrypt = txtName.text
        print(nameToEncrypt!)
        let agentNameEncrypted = encryption.encrypt(value: nameToEncrypt!)
        print(agentNameEncrypted)
        let emailToEncrypt = txtEmail.text
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
        print(dateEncrypted)
        
        let name = agentNameEncrypted
        let email = agentEmailEncrypted
        let mission = agentMissionEncrypted
        let country = agentCountryEncrypted
        let date = dateEncrypted
        
        agent = Agent(name: name, email: email, mission: mission, country: country, date: date)
        result = db.save(agent!)
    
        
        if result {
            let alert = UIAlertController(title: "Saved", message: "Agent \(name) saved", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { _ in
                    DispatchQueue.main.async { [unowned self] in
                        self.delegate?.reload()
                        self.navigationController?.popViewController(animated: true)
                    }
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Agent \(name) not saved", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

}
