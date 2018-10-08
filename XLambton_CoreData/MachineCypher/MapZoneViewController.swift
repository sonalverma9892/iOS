//
//  MapZoneViewController.swift
//  MachineCypher
//
//  Created by Sonal Verma on 2018-08-04.
//  Copyright © 2018 Sonal Verma. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


class MapZoneViewController: UIViewController, CLLocationManagerDelegate {
    
//    var coreData = CoreDataConnection.sharedInstance
    var encryption:Encryption = Encryption()
    var agentArray:[Agent] = []
    var countryMissionI: [String] = []
    var countryMissionR: [String] = []
    var countryMissionP: [String] = []
    var countryArrayRed: [String] = []
    var countryArrayGreen: [String] = []
    var countryArrayBlue: [String] = []
     var locationArray: [CLLocationCoordinate2D] = []

    @IBOutlet weak var agentMap: MKMapView!
    @IBOutlet weak var lblMissionRed: UILabel!
    @IBOutlet weak var lblMissionGreen: UILabel!
    @IBOutlet weak var lblMissionBlue: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var activityBlue: UISlider!
    @IBOutlet weak var activityGreen: UISlider!
    @IBOutlet weak var activityRed: UISlider!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    
    var mapManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneTap))
        self.navigationItem.title = "Map Zone"
        self.navigationItem.rightBarButtonItem = doneButton
        myActivityIndicator.stopAnimating()
        myActivityIndicator.hidesWhenStopped = true
//        self.agentMap.delegate = self
        
        if (CLLocationManager.locationServicesEnabled()) {
            mapManager.delegate = self
            mapManager.desiredAccuracy = kCLLocationAccuracyBest
            mapManager.requestWhenInUseAuthorization()
            mapManager.startUpdatingLocation()
        }
        mapManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            mapManager.startUpdatingLocation()
        }
//
//        DispatchQueue.main.async {
//            self.mapManager.startUpdatingLocation()
//        }
//
        (countryMissionI, countryMissionR, countryMissionP) = fetchCountry()
        dump(countryMissionI)
        dump(countryMissionR)
        dump(countryMissionP)
        
        getAgentCountries()
       
    }
    
    func getAgentCountries(){
        
        let countryMissionIString = countryMissionI.joined(separator: "-")
        print("Country:", countryMissionIString)
        let countryMissionRString = countryMissionR.joined(separator: "-")
        print("Country:", countryMissionRString)
        let countryMissionPString = countryMissionP.joined(separator: "-")
        print("Country:", countryMissionPString)
        
        let countryMissionIDecrypted = encryption.decrypt(countryMissionIString)
        print(countryMissionIDecrypted)
        let countryMissionRDecrypted = encryption.decrypt(countryMissionRString)
        print(countryMissionRDecrypted)
        let countryMissionPDecrypted = encryption.decrypt(countryMissionPString)
        print(countryMissionPDecrypted)
        
        let arrayCountryMissionI = countryMissionIDecrypted.components(separatedBy: " ").dropLast()
        print(arrayCountryMissionI)
        let arrayCountryMissionR = countryMissionRDecrypted.components(separatedBy: " ").dropLast()
        print(arrayCountryMissionR)
        let arrayCountryMissionP = countryMissionPDecrypted.components(separatedBy: " ").dropLast()
        print(arrayCountryMissionP)
        
        
        for eachCountry in arrayCountryMissionI{
            getCoordinateFrom(address: eachCountry) { coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                // don't forget to update the UI from the main thread
//                DispatchQueue.main.async {
                    print(coordinate) // CLLocationCoordinate2D(latitude: -22.910863800000001, longitude: -43.204543600000001)
                    self.locationArray = [(coordinate)]
                    dump(self.locationArray)
                    
                    let annotation = MKPointAnnotation()
                    //                    self.agentMap.delegate = self
                    annotation.title = "I"
                    annotation.coordinate = self.locationArray[0]
                    self.agentMap.addAnnotation(annotation)
//                }
            }
        }
        
        for eachCountry in arrayCountryMissionR{
            getCoordinateFrom(address: eachCountry) { coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                // don't forget to update the UI from the main thread
//                DispatchQueue.main.async {
                    print(coordinate) // CLLocationCoordinate2D(latitude: -22.910863800000001, longitude: -43.204543600000001)
                    self.locationArray = [(coordinate)]
                    dump(self.locationArray)
                    
                    let annotation = MKPointAnnotation()
                    //                    self.agentMap.delegate = self
                    annotation.title = "R"
                    annotation.coordinate = self.locationArray[0]
                    self.agentMap.addAnnotation(annotation)
//                }
            }
        }
        
        for eachCountry in arrayCountryMissionP{
            getCoordinateFrom(address: eachCountry) { coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                // don't forget to update the UI from the main thread
//                DispatchQueue.main.async {
                    print(coordinate) // CLLocationCoordinate2D(latitude: -22.910863800000001, longitude: -43.204543600000001)
                    self.locationArray = [(coordinate)]
                    dump(self.locationArray)
                    
                    let annotation = MKPointAnnotation()
                    //                    self.agentMap.delegate = self
                    annotation.title = "P"
                    annotation.coordinate = self.locationArray[0]
                    self.agentMap.addAnnotation(annotation)
//                }
            }
        }
        
        //get the count of countries for each mission
        activityRed.maximumValue = Float(arrayCountryMissionI.count)
        activityRed.minimumValue = 0
        updateILabel(iSelected: 0);
        print("activityRed.maximumValue", activityRed.maximumValue)
        
        activityGreen.maximumValue = Float(arrayCountryMissionR.count)
        activityGreen.minimumValue = 0
         updateRLabel(rSelected: 0);
         print("activityGreen.maximumValue", activityGreen.maximumValue)
        
        activityBlue.maximumValue = Float(arrayCountryMissionP.count)
        activityBlue.minimumValue = 0
         updatePLabel(pSelected: 0);
         print("activityBlue.maximumValue", activityBlue.maximumValue)
    }
    
    @IBAction func missionISlider(_ sender: UISlider) {
        var valueI = Int(sender.value)
        print("valueI", valueI)
        
        if(valueI != 0){
            valueI = valueI - 1
        }else{
            return
        }
        if(countryMissionI != []){
            print("countryMissionI---",countryMissionI)
            let agentTarget = countryMissionI[valueI]
            let agentCountryDecrypted = encryption.decrypt(agentTarget)
            print("agentCountryDecryptedR", agentCountryDecrypted)
            updateImage(countrySelected: agentCountryDecrypted)
        }
    }
    
    @IBAction func missionRSlider(_ sender: UISlider) {
        var valueR = Int(sender.value)
        print("valueR", valueR)
        
        if(valueR != 0){
            valueR = valueR - 1
        }
        else{
            return
        }
        if(countryMissionR != []){
            print("countryMissionR---",countryMissionR)
            let agentTarget = countryMissionR[valueR]
            let agentCountryDecrypted = encryption.decrypt(agentTarget)
            print("agentCountryDecrypted", agentCountryDecrypted)
            updateImage(countrySelected: agentCountryDecrypted)
        }
    }
    
    @IBAction func missionPSlider(_ sender: UISlider) {
        var valueP = Int(sender.value)
        print("valueP", valueP)
        
        if(valueP != 0){
            valueP = valueP - 1
        }else{
            return
        }
        if(countryMissionP != []){
            print("countryMissionP---",countryMissionP)
            let agentTarget = countryMissionP[valueP]
            let agentCountryDecrypted = encryption.decrypt(agentTarget)
            print("agentCountryDecrypted", agentCountryDecrypted)
            updateImage(countrySelected: agentCountryDecrypted)
        }
    }
    
    
    
    func updateILabel(iSelected: Int){
      print("\(iSelected)/\(countryMissionI.count)")
    }
    func updateRLabel(rSelected: Int){
        print("\(rSelected)/\(countryMissionR.count)")
    }
    func updatePLabel(pSelected: Int){
        print("\(pSelected)/\(countryMissionP.count)")
    }
    
    
    
    func updateImage(countrySelected: String){
        // starts the download indicator
        myActivityIndicator.startAnimating()
        
        // getting the image's url
        var url = URL(string: "")
        
        switch countrySelected{

        case "afghanistan ":
            print("INSIDE SWITCH")
            url = URL(string: "http://upload.wikimedia.org/wikipedia/commons/a/a8/Afghanistan_Flag.jpg")
            break
        case "australia ":
            url = URL(string: "https://wallpaper-gallery.net/images/australia-wallpapers/australia-wallpapers-10.jpg")
            break
        case "bangladesh ":
            url = URL(string: "https://wallpaper-gallery.net/images/bangladesh-wallpaper/bangladesh-wallpaper-19.jpg")
            break
        case "brazil ":
             print("INSIDE SWITCH")
            url = URL(string: "https://wallpaper-gallery.net/images/wallpapers-brazil/wallpapers-brazil-1.jpg")
            break
        case "canada ":
            url = URL(string: "https://wallpaper-gallery.net/images/canada-city-wallpaper/canada-city-wallpaper-15.jpg")
            break
        case "france ":
            url = URL(string: "https://wallpaper-gallery.net/images/eiffel-tower-paris-france-wallpaper/eiffel-tower-paris-france-wallpaper-2.jpg")
            break
        case "germany ":
            url = URL(string: "https://wallpaper-gallery.net/images/wallpapers-germany/wallpapers-germany-1.jpg")
            break
        case "india ":
            url = URL(string: "https://wallpaper-gallery.net/images/india-wallpaper-desktop/india-wallpaper-desktop-1.jpg")
            break
        case "japan ":
            url = URL(string: "https://wallpaper-gallery.net/images/japan-flag-wallpaper/japan-flag-wallpaper-13.jpg")
            break
        case "singapore ":
            url = URL(string: "https://wallpaper-gallery.net/images/singapore-wallpaper/singapore-wallpaper-19.jpg")
            break
        case "southafrica ":
            url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Flag_of_South_Africa.svg/1200px-Flag_of_South_Africa.svg.png")
            break
        default:
            break
        }
        
        
        // creating the background thread
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            // Image Download
            let fetch = NSData(contentsOf: url! as URL)
//            print(fetch!)
            
            
            //Creating the main thread, that will update the user interface
            DispatchQueue.main.async {
                
                // Assign image dowloaded to image variable
                if let imageData = fetch {
                    self.countryImage.image = UIImage(data: imageData as Data)
                }
                
                // stops the download indicator
                self.myActivityIndicator.stopAnimating()
            }
        }
    }
    
    @objc func doneTap(){
        let missionUpdateSB : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let missionUpdateVC = missionUpdateSB.instantiateViewController(withIdentifier: "MissionUpdateStoryboard")
        self.navigationController?.pushViewController(missionUpdateVC, animated: true)
    }
    

//    func updateI(iSelected: Int){
//        pAgentOutOf.text = "\(pSelected)/\(Generic.pAgents.count)";
//    }
//    func updateR(rSelected: Int){
//        rAgentOutOf.text = "\(rSelected)/\(Generic.rAgents.count)";
//    }
//    func updateP(pSelected: Int){
//        iAgentOutOf.text = "\(iSelected)/\(Generic.iAgents.count)";
//    }
 

    
    
    
    
    func fetchCountry() -> ([String], [String], [String]) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Agent")
         do {
            agentArray = try context.fetch(fetch) as! [Agent]
            for value in agentArray{
                print(value.country!)
                print(value.mission!)
                if(value.mission! == "23|"){
                    countryArrayRed += [value.country!]
                }else if(value.mission! == "61|"){
                    countryArrayGreen += [value.country!]
                }else if(value.mission! == "53|"){
                    countryArrayBlue += [value.country!]
                }
//                print(countryArrayRed, countryArrayGreen, countryArrayBlue)
            }
         }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return (countryArrayRed, countryArrayGreen, countryArrayBlue)
    }
    

    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
            CLGeocoder().geocodeAddressString(address) { placemarks, error in
                completion(placemarks?.first?.location?.coordinate, error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard (locations.last as CLLocation?) != nil else { return }
        print("YES")

        let worldRegion = MKCoordinateRegionForMapRect(MKMapRectWorld);
        agentMap.region = worldRegion;

    }
    
}

extension MapZoneViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            print(annotation.title!!)
            if(annotation.title!! == "I"){
                annotationView.tintColor = .red
                 print(annotationView.tintColor)
            }else if(annotation.title!! == "R"){
                annotationView.tintColor = .blue
            }else if(annotation.title!! == "P"){
                 annotationView.tintColor = .green
            }
            return annotationView
        }
    }
    
}
