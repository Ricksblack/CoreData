//
//  AgregarViewController.swift
//  CoreDataFinal
//
//  Created by Ricardo Moreno on 4/29/18.
//  Copyright © 2018 blackricks. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class AgregarViewController: UIViewController {

    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var descripcion: UITextField!
    @IBOutlet weak var btnCoordenadas: UIButton!
    
    var locationManager = CLLocationManager()
    var latitud: CLLocationDegrees!
    var longitud: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }

    @IBAction func obtenerCoordenadas(_ sender: UIButton) {
        btnCoordenadas.setTitle("Lat: \(latitud!) - Long: \(longitud!)", for: .normal)
    }
    
    @IBAction func btnGuardar(_ sender: UIButton) {
        let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //la entidad es una clase
        let entityLugar = NSEntityDescription.insertNewObject(forEntityName: "Lugar", into: contexto) as! Lugar
        if let nombre = nombre.text, nombre != "", let desc = descripcion.text, desc != "" {
            entityLugar.nombre = nombre
            entityLugar.descripcion = desc
        }
        entityLugar.latitud = latitud
        entityLugar.longitud = longitud
        
        //select * from lugares by id desc limit 1
        let fetchRequest : NSFetchRequest<Lugar> = Lugar.fetchRequest()
        let orderById = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [orderById]
        fetchRequest.fetchLimit = 1
        do {
            let idResult = try contexto.fetch(fetchRequest)
            entityLugar.id = idResult[0].id + 1
        } catch let error as NSError {
            print("There was an error \(error)")
        }
        
        do {
            try contexto.save()
            nombre.text = ""
            descripcion.text = ""
            btnCoordenadas.setTitle("Obtener Coordenadas", for: .normal)
        } catch let error as NSError {
            print("There was an error \(error)")
        }
    }
}

extension AgregarViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.latitud = location.coordinate.latitude
            self.longitud = location.coordinate.longitude
        }
    }
}
