//
//  ImagenesLugaresViewController.swift
//  CoreDataFinal
//
//  Created by Ricardo Moreno on 4/30/18.
//  Copyright © 2018 blackricks. All rights reserved.
//

import UIKit
import CoreData

class ImagenesLugaresViewController: UIViewController {

    @IBOutlet weak var coleccion: UICollectionView!
    var imagenLugar: Lugar!
    var id: Int16!
    var imagen: UIImage!
    var imagenes : [Imagen] = []
    var refrescar: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = imagenLugar.nombre
        id = imagenLugar.id
        coleccion.delegate = self
        coleccion.dataSource = self
        //para agregar el boton de la camara
        let btnRight = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(accionCamara))
        self.navigationItem.rightBarButtonItem = btnRight
        
        let itemSize = UIScreen.main.bounds.width / 3 - 3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        coleccion.collectionViewLayout = layout
        bringImages()
        
        refrescar = UIRefreshControl()
        coleccion.alwaysBounceVertical = true
        refrescar.tintColor = UIColor.green
        refrescar.addTarget(self, action: #selector(recargarDatos), for: .valueChanged)
        coleccion.addSubview(refrescar)
    }
    
    @objc func accionCamara() {
        let alert = UIAlertController(title: "Tomar foto", message: "Camara / Galeria", preferredStyle: .actionSheet)
        let accionCamara = UIAlertAction(title: "Tomar fotografia", style: .default) { (action) in
            self.openMedia(.camera)
        }
        let accionGaleria = UIAlertAction(title: "Ver fotos", style: .default) { (action) in
            self.openMedia(.photoLibrary)
        }
        
        let accionCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(accionCamara)
        alert.addAction(accionGaleria)
        alert.addAction(accionCancelar)
        present(alert, animated: true, completion: nil)
    }
    
    func openMedia(_ accion: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = accion
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func bringImages() {
        let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Imagen> = Imagen.fetchRequest()
        let idLugar = String(id)
        fetchRequest.predicate = NSPredicate(format: "id_lugar == %@", idLugar)
        do {
            imagenes = try contexto.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error \(error)")
        }
    }
    
    @objc func recargarDatos() {
        bringImages()
        coleccion.reloadData()
        refrescar.endRefreshing()
    }
}

extension ImagenesLugaresViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let capturedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        imagen = capturedImage
        let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entityImage = NSEntityDescription.insertNewObject(forEntityName: "Imagen", into: contexto) as! Imagen
        entityImage.id = UUID()
        entityImage.id_lugar = id
        entityImage.imagen = UIImagePNGRepresentation(imagen) as Data?
        imagenLugar.mutableSetValue(forKey: "imagen").add(entityImage)
        
        do {
            try contexto.save()
            bringImages()
            coleccion.reloadData() 
            dismiss(animated: true, completion: nil)
            print("Se guardo la imagen")
        } catch let error as NSError {
            print("No guardo \(error)")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ImagenesLugaresViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagenes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = coleccion.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImagenCollectionViewCell
        let imagen = imagenes[indexPath.row]
        if let imagen = imagen.imagen {
            cell.imagen.image = UIImage(data: imagen as Data)
        }
        return cell
    }
    
}
