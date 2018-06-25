//
//  ViewController.swift
//  CoreDataFinal
//
//  Created by Ricardo Moreno on 4/29/18.
//  Copyright © 2018 blackricks. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tabla: UITableView!
    var lugares = [Lugar]()
    var fetchResultController: NSFetchedResultsController<Lugar>!
    var contexto: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Lugar> = Lugar.fetchRequest()
        let orderByName = NSSortDescriptor(key: "nombre", ascending: true)
        fetchRequest.sortDescriptors = [orderByName]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
            lugares = fetchResultController.fetchedObjects!
        } catch let error as NSError {
            print("There was an error \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageSegue" {
            if let vc = segue.destination as? ImagenesLugaresViewController, let id = tabla.indexPathForSelectedRow {
                vc.imagenLugar = lugares[id.row]
            }
        } else if segue.identifier == "mapa" {
            let id = sender as! NSIndexPath
            let fila = lugares[id.row]
            let destino = segue.destination as! MapaViewController
            destino.coordLugares = fila
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lugares.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lugar = lugares[indexPath.row]
        cell.textLabel?.text = lugar.nombre
        cell.detailTextLabel?.text = lugar.descripcion
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let btnDelete = UITableViewRowAction(style: .destructive, title: "Borrar") { (action, indexPath) in
            let borrar = self.fetchResultController.object(at: indexPath)
            self.contexto.delete(borrar)
            do {
                try self.contexto.save()
            } catch  {
                print("Hubo un error")
            }
        }
        
        let btnMapa = UITableViewRowAction(style: .normal, title: "Mapa") { (action, indexPath) in
            self.performSegue(withIdentifier: "mapa", sender: indexPath)
        }
        btnMapa.backgroundColor = UIColor.blue
        
        let btnEdit = UITableViewRowAction(style: .normal, title: "Editar") { (action, indexPath) in
            print("editando")
        }
        return [btnDelete,btnMapa,btnEdit]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "imageSegue", sender: self)
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tabla.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tabla.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tabla.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tabla.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tabla.reloadRows(at: [indexPath!], with: .middle)
        default:
            tabla.reloadData()
        }
        lugares = controller.fetchedObjects as! [Lugar]
    }
}

