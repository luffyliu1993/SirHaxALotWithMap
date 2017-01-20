//
//  AdventureViewController.swift
//  SirHaxALot
//
//  Created by Kevin M Tran on 1/19/17.
//  Copyright © 2017 James Bruno. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
import AVFoundation
class AdventureViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    var userHeading = CLHeading()
//    var mapCam = 
    var dragons:[Dragification] = []
    var audioQueue = OperationQueue()
    var locationManager = CLLocationManager()
    var distanceToCarlos: CLLocationDistance = 0.0
    var userLocation = CLLocation()
    var carlosLocation = CLLocation()
    var carlosRegion = CLCircularRegion()
    var fightingDrag:Dragification!
    func randoDouble() -> Double{
        let num = Double(arc4random_uniform(20))-10
        return num
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        mapView.showsUserLocation = (status == .authorizedAlways)
//        mapCam.heading = locationManager.heading
//        mapView.camera = mapCam
    }
    func add() {
        //111302.61697430261
        
        // 0.000008984514715
        
        
        //        let randomNum = 40.0
        //        print("RandomNum is", randomNum)
        let radius = 5.0
        var dragon:Dragification!
        var goodDragon = false
        var someBadDragon = false
        
        while(!goodDragon){
            let latOffset = CLLocationDegrees(randoDouble()/111200)
            let longOffset = CLLocationDegrees(randoDouble()/111200)
            let coordinate = CLLocationCoordinate2D(latitude:  (locationManager.location?.coordinate.latitude)! - latOffset, longitude: (locationManager.location?.coordinate.longitude)! - longOffset)
            dragon = Dragification(coordinate:coordinate,radius:radius,identifier:"dragon",note:"I am a dragon",eventType:EventType.onEntry)
            someBadDragon = false
            carlosLocation = CLLocation(latitude:  coordinate.latitude, longitude: coordinate.longitude)
            for d in dragons{
                if carlosLocation.distance(from: CLLocation(latitude: d.coordinate.latitude, longitude: d.coordinate.longitude)) <= radius*2 {
                    someBadDragon = true
                    break;
                }
            }
            if(!someBadDragon){
                goodDragon = true
            }
            
        }
        print("there it is! \(carlosLocation)")
        
        //        startMonitoring(dragification: dragon)
        
        
        mapView.addAnnotation(dragon)
        //        self.stopMonitoring(dragification: dragon)
        self.dragons.append(dragon)
        
        let circle = MKCircle(center: dragon.coordinate, radius: dragon.radius)
        self.mapView.add(circle)
        
    }
    
    var dragonFlap: AVAudioPlayer!
    let dragonSound = NSDataAsset(name: "dragonFlap")!
    
    
    func playDragonFlap() {
        
        print("Playing: dragonTellCenter")
        let sound = NSDataAsset(name: "dragonFlap")!
        
        do {
            dragonFlap = try AVAudioPlayer(data: sound.data)
            guard let player = dragonFlap else { return }
            
            dragonFlap!.numberOfLoops = -1
//            dragonFlap!.pan = ((Float(self.command)-1.0) * -1.0)
            print("Playing Dragon Flap! Volume:", dragonFlap!.volume,"Panning:", dragonFlap!.pan)
//            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }

        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dragonSound = NSDataAsset(name: "dragonFlap")!
        
        do {
            dragonFlap = try AVAudioPlayer(data: dragonSound.data)
            guard let player = dragonFlap else { return }
            
            dragonFlap!.numberOfLoops = -1
            //            dragonFlap!.pan = ((Float(self.command)-1.0) * -1.0)
            player.prepareToPlay()
        } catch let error as NSError {
            print(error.description)
        }

        print("loaded")
        locationManager.delegate = self
        
        mapView.delegate = self
        print("location is long \(locationManager.location?.coordinate.longitude) and lat \(locationManager.location?.coordinate.latitude)")
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
//        locationManager.startUpdatingHeading()
        
        mapView.setRegion(MKCoordinateRegion(center:(locationManager.location?.coordinate)!,span:MKCoordinateSpan()), animated: true)
        for _ in 0..<3{
            add()
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let navigationController = segue.destination as! UINavigationController
        let battleViewController = navigationController.topViewController as! ViewController
        
        //        let battleViewController = segue.destination as! ViewController
        
        battleViewController.delegate = self
        battleViewController.dragitification = fightingDrag
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        userHeading = newHeading
        print("USER HEADING IS CURRENTLY \(userHeading)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("this is wherer you are at", locations[0])
        userLocation = locations[0]
        print(manager.distanceFilter)
        var distanceFromCarlos = userLocation.distance(from: carlosLocation)
        print("USER DISTANCE FROM CARLOS: \(distanceFromCarlos) meters from CARLOS")
        
        
         // Mark: Finding a dragon
        let firstDragon = CLLocation(latitude: dragons[0].coordinate.latitude, longitude: dragons[0].coordinate.longitude)
        var closestDragonDistance = userLocation.distance(from: firstDragon )
        for dragon in dragons{
            let dragonLocation = CLLocation(latitude: dragon.coordinate.latitude, longitude: dragon.coordinate.longitude)
            
            if userLocation.distance(from: dragonLocation) < closestDragonDistance{
                closestDragonDistance = userLocation.distance(from: dragonLocation)
            }
            
            
            
            
            if userLocation.distance(from: dragonLocation) < 5.0{
                
                
                //                    let dragonFound =  UIAlertController(title: "DARGON! WHATCH OUT!", message: "Wanna' slay this? Dargon? Name's Carlos.", preferredStyle: .alert)
                //                    let fightDragon = UIAlertAction(title: "Fight!", style: .default, handler: nil)
                //                    dragonFound.addAction(fightDragon)
                //                    self.present(dragonFound, animated: true, completion: nil)
                //                }
                //                locationManager.requestState(for: carlosRegion)
                
                locationManager.stopUpdatingLocation()
               DispatchQueue.main.async {
                    print("WE ARE IN ADD OPERATION")
                    self.dragonFlap.stop()
                    self.dragonFlap.stop()
                    self.dragonFlap.stop()
                    self.dragonFlap.stop()
                    self.dragonFlap.numberOfLoops = 0
                }
                fightingDrag = dragon
                performSegue(withIdentifier: "Go Fight", sender: self)
            }
        }
        
        if closestDragonDistance < 10.0{
            
            audioQueue.addOperation {
                self.dragonFlap.volume = Float(1.0)-(Float(closestDragonDistance)/Float(10.0))
                print(self.dragonFlap.volume)
                if !self.dragonFlap.isPlaying{
                    self.playDragonFlap()
                }
                
            }
        }else{
            
            dragonFlap.stop()
            dragonFlap.stop()
            dragonFlap.stop()
        }
        
        //    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        //        print("REGION STATE CHECK: Is user in region '\(region.identifier)? \(state.rawValue)")
        //    }
        
        //    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        //        print("Monitoring failed for region with identifier: \(region!.identifier)")
        //        locationManager.stopMonitoring(for: carlosRegion)
        //        print(error)
        //        locationManager.startMonitoring(for: carlosRegion)
        //    }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "dragon"
        
        if annotation is Dragification {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.image = UIImage(named:"carlos")
                annotationView?.frame = CGRect(origin: mapView.center, size: CGSize(width: 30, height: 30))
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .purple
            circleRenderer.fillColor = UIColor.green.withAlphaComponent(0.4)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func region(withDragification dragification: Dragification) -> CLCircularRegion {
        print("region")
        // 1
        let region = CLCircularRegion(center: dragification.coordinate, radius: dragification.radius, identifier: dragification.identifier)
        // 2
        region.notifyOnEntry = (dragification.eventType == .onEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func remove(dragification : Dragification){
        if let index = dragons.index(of: dragification){
            dragons.remove(at: index)
            dismiss(animated: true, completion: nil)
            locationManager.startUpdatingLocation()
        }
        self.mapView.removeAnnotation(dragification)
        removeCircle(dragification:dragification)
        print("remove")
    }
    
    func removeCircle(dragification: Dragification){
        for d in mapView.overlays{
            if let circle = d as? MKCircle{
                let coord = circle.coordinate
                if circle.radius == dragification.radius && coord.latitude == dragification.coordinate.latitude && coord.longitude == dragification.coordinate.longitude{
                    mapView?.remove(circle)
                    break
                }
            }
        }
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Delete geotification
        let dragification = view.annotation as! Dragification
        remove(dragification:dragification)
        
    }

}







