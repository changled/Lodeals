//
//  MapViewController.swift
//  
//
//  Created by Rachel Chang on 5/8/18.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        GMSServices.provideAPIKey("AIzaSyAiT47Oq_BwkPYpWlcx89OoGJP1omVz33c")
        let camera = GMSCameraPosition.camera(withLatitude: 35.300412, longitude: -120.677080, zoom: 18)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 35.300412, longitude: -120.677080)
        marker.title = "My apartment"
        marker.snippet = "Whooohoo home of the goal diggers :D"
        marker.map = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
