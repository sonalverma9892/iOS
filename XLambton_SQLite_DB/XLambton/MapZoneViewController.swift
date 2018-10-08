//
//  MapZoneViewController.swift
//  XLambton
//
//  Created by Sonal Verma on 2018-08-10.
//  Copyright © 2018 Sonal Verma. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapZoneViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var sliderBlue: UISlider!
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    var encryption:Encryption = Encryption()
    var mapManager = CLLocationManager()
    
    var agents: [Agent] = []
    var db: DBManager?
    
    var countryMissionI: [String] = []
    var countryMissionR: [String] = []
    var countryMissionP: [String] = []
    var countryArrayRed: [String] = []
    var countryArrayGreen: [String] = []
    var countryArrayBlue: [String] = []
    var locationArray: [CLLocationCoordinate2D] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneTap))
        self.navigationItem.title = "Map Zone"
        self.navigationItem.rightBarButtonItem = doneButton
        myActivityIndicator.stopAnimating()
        myActivityIndicator.hidesWhenStopped = true
        
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
        
        DispatchQueue.main.async {
            self.mapManager.startUpdatingLocation()
        }
        
        db = DBManager()
        agents.removeAll()
        if let db = db {
            agents = db.readValues()
        }
        
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
                DispatchQueue.main.async {
                    print(coordinate) // CLLocationCoordinate2D(latitude: -22.910863800000001, longitude: -43.204543600000001)
                    self.locationArray = [(coordinate)]
                    dump(self.locationArray)
                
                    let annotation = MKPointAnnotation()
                    annotation.title = "I"
                    annotation.coordinate = self.locationArray[0]
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
        
        for eachCountry in arrayCountryMissionR{
            getCoordinateFrom(address: eachCountry) { coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                // don't forget to update the UI from the main thread
                DispatchQueue.main.async {
                    print(coordinate) // CLLocationCoordinate2D(latitude: -22.910863800000001, longitude: -43.204543600000001)
                    self.locationArray = [(coordinate)]
                    dump(self.locationArray)
                
                    let annotation = MKPointAnnotation()
                    annotation.title = "R"
                    annotation.coordinate = self.locationArray[0]
                    self.mapView.addAnnotation(annotation)
               }
            }
        }
        
        for eachCountry in arrayCountryMissionP{
            getCoordinateFrom(address: eachCountry) { coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                // don't forget to update the UI from the main thread
                DispatchQueue.main.async {
                    print(coordinate) // CLLocationCoordinate2D(latitude: -22.910863800000001, longitude: -43.204543600000001)
                    self.locationArray = [(coordinate)]
                    dump(self.locationArray)
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = "P"
                    annotation.coordinate = self.locationArray[0]
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
        
        //get the count of countries for each mission
        sliderRed.maximumValue = Float(arrayCountryMissionI.count)
        sliderRed.minimumValue = 0
        updateILabel(iSelected: 0);
        print("activityRed.maximumValue", sliderRed.maximumValue)
        
        sliderGreen.maximumValue = Float(arrayCountryMissionR.count)
        sliderGreen.minimumValue = 0
        updateRLabel(rSelected: 0);
        print("activityGreen.maximumValue", sliderGreen.maximumValue)
        
        sliderBlue.maximumValue = Float(arrayCountryMissionP.count)
        sliderBlue.minimumValue = 0
        updatePLabel(pSelected: 0);
        print("activityBlue.maximumValue", sliderBlue.maximumValue)
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
            url = URL(string: "http://upload.wikimedia.org/wikipedia/commons/a/a8/Afghanistan_Flag.jpg")
            break
        case "australia ":
            url = URL(string: "https://wallpaper-gallery.net/images/australia-wallpapers/australia-wallpapers-10.jpg")
            break
        case "bangladesh ":
            url = URL(string: "https://wallpaper-gallery.net/images/bangladesh-wallpaper/bangladesh-wallpaper-19.jpg")
            break
        case "brazil ":
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
            
            //Creating the main thread, that will update the user interface
            DispatchQueue.main.async {
                
                // Assign image dowloaded to image variable
                if let imageData = fetch {
                    self.countryImageView.image = UIImage(data: imageData as Data)
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
    
    func fetchCountry() -> ([String], [String], [String]) {
        
        for value in agents{
            print(value.country)
            print(value.mission)
            if(value.mission == "23|"){
                countryArrayRed += [value.country]
            }else if(value.mission == "61|"){
                countryArrayGreen += [value.country]
            }else if(value.mission == "53|"){
                countryArrayBlue += [value.country]
            }
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
        mapView.region = worldRegion;
        
    }

    @IBAction func SliderPBlue(_ sender: UISlider) {
        var valueP = Int(lroundf(sender.value))
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
    
    
    @IBAction func sliderRGreen(_ sender: UISlider) {
        var valueR = Int(lroundf(sender.value))
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
    
    @IBAction func sliderIRed(_ sender: UISlider) {
        var valueI = Int(lroundf(sender.value))
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
