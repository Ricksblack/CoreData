//
//  MapaViewController.swift
//  CoreDataFinal
//
//  Created by Ricardo Moreno on 6/24/18.
//  Copyright © 2018 blackricks. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapaViewController: UIViewController {

    @IBOutlet weak var mapa: MKMapView!
    
    var coordLugares : Lugar!
    var manager = CLLocationManager()
    var latitudMapa : CLLocationDegrees!
    var longitudMapa: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        latitudMapa = coordLugares.latitud
        longitudMapa = coordLugares.longitud
    }
}

extension MapaViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let localizacion = CLLocationCoordinate2DMake(latitudMapa, longitudMapa)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: localizacion, span: span)
        mapa.setRegion(region, animated: true)
        
        let anotacion = MKPointAnnotation()
        anotacion.coordinate = (localizacion)
        anotacion.title = coordLugares.nombre
        anotacion.subtitle = coordLugares.description
        mapa.addAnnotation(anotacion)
        mapa.selectAnnotation(anotacion, animated: true)
    }
}
