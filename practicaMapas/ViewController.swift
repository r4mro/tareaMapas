//
//  ViewController.swift
//  practicaMapas
//
//  Created by Ricardo Roman Landeros on 10/01/16.
//  Copyright © 2016 lagunahack. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    private let manejador = CLLocationManager()
    
    let filtro = 60.0
    var distancia = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        manejador.distanceFilter = filtro
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse
        {
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            var punto = CLLocationCoordinate2D()
            punto.latitude = manejador.location!.coordinate.latitude
            punto.longitude = manejador.location!.coordinate.longitude
            let regionRadius: CLLocationDistance = 1000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(punto, regionRadius, regionRadius)
            mapa.setRegion(coordinateRegion, animated: true)
            let pin = MKPointAnnotation()
                    pin.title = "Inicio de la trayectoria"
                    pin.subtitle = "0 metros"
                    pin.coordinate = punto
                    mapa.addAnnotation(pin)
       }
        else
        {
            manejador.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        distancia = distancia + filtro
        var punto = CLLocationCoordinate2D()
        punto.latitude = manejador.location!.coordinate.latitude
        punto.longitude = manejador.location!.coordinate.longitude
        
        let pin = MKPointAnnotation()
        pin.title = "\(punto.latitude) y \(punto.longitude)"
        pin.subtitle = "\(distancia) metros"
        pin.coordinate = punto
        mapa.addAnnotation(pin)
    }


    @IBAction func tipoMapa(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            mapa.mapType = MKMapType.Standard
        case 1:
            mapa.mapType = MKMapType.Satellite
        case 2:
            mapa.mapType = MKMapType.Hybrid
        default:
            mapa.mapType = MKMapType.Standard
        }
    }
}

