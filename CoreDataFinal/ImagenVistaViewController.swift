//
//  ImagenVistaViewController.swift
//  CoreDataFinal
//
//  Created by Ricardo Moreno on 6/24/18.
//  Copyright © 2018 blackricks. All rights reserved.
//

import UIKit
import CoreData

class ImagenVistaViewController: UIViewController {

    @IBOutlet weak var imagen: UIImageView!
    
    var imagenLugar: Imagen?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = imagenLugar {
            imagen.image = UIImage(data: image.imagen as Data!)
        }
    }
    
    @IBAction func eliminar(_ sender: UIButton) {
        let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Imagen> = Imagen.fetchRequest()
        let id = imagenLugar?.id
        fetchRequest.predicate = NSPredicate(format: "id == %@", id! as CVarArg)
        //borrando un elemento que no viene de una tabla
        
        let objeto = try! contexto.fetch(fetchRequest)
        for res in objeto {
            contexto.delete(res)
        }
        
        do {
            try contexto.save()
            navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("No elimino", error)
        }
    }
    
}
