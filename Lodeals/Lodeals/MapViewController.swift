//
//  MapViewController.swift
//
//
//  Created by Rachel Chang on 5/8/18.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var myView: UIView!
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        //thugs cottage: (35.300412, -120.677080)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showCurrLocation() {
        let camera = GMSCameraPosition.camera(withLatitude: (self.manager.location?.coordinate.latitude)!, longitude: (self.manager.location?.coordinate.longitude)!, zoom: 18)
        let mapView = GMSMapView.map(withFrame: CGRect.init(x: 0, y: 0, width: self.myView.frame.size.width, height: self.myView.frame.size.height), camera: camera)
        let marker = GMSMarker()
        
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        marker.position = camera.target
        marker.snippet = "Current location!"
        //        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        self.myView.addSubview(mapView)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrLocation()
        self.manager.stopUpdatingLocation()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

