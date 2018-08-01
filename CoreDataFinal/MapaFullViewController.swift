//
//  MapaFullViewController.swift
//  CoreDataFinal
//
//  Created by Ricardo Moreno on 7/29/18.
//  Copyright © 2018 blackricks. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapaFullViewController: UIViewController {

    @IBOutlet weak var mapa: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let annotation = getCoordinates() {
            mapa.addAnnotations(annotation)
        }
    }
    
    func getCoordinates() -> [MKAnnotation]? {
        let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Lugar> = Lugar.fetchRequest()
        
        do {
            let locations = try contexto.fetch(fetchRequest)
            var annotation = [MKAnnotation]()
            for item in locations {
                let newAnnotation = MKPointAnnotation()
                newAnnotation.coordinate.latitude = item.latitud
                newAnnotation.coordinate.longitude = item.longitud
                newAnnotation.title = item.nombre
                newAnnotation.subtitle = item.descripcion
                annotation.append(newAnnotation)
            }
            return annotation
        } catch let error as NSError {
            print("Hubo un error \(error)")
        }
        return nil
    }

}
