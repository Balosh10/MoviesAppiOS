//
//  alertCustom.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 31/01/22.
//

import Foundation
import UIKit

struct alertCustom {
    
    static var shared:alertCustom {
        return alertCustom()
    }
    
    func alertShow(_ targetVC: UIViewController,
                   title: String = "¡Ups!\n",
                   message: String,
                   actualizar:String = "OK",
                   completionHandler: @escaping (_ success:Bool)-> Void){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction((UIAlertAction(title: actualizar, style: .cancel, handler: {(action) -> Void in
                completionHandler(true)
            })))
            targetVC.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func alertOpciones(targetVC: UIViewController, title: String, message: String,completionHandler: @escaping (_ success:Bool)-> Void){
        let actionAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelarAlert = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        actionAlert.addAction(cancelarAlert)
        
        let logout = UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default) { (action) in
            completionHandler(true)
        }
        actionAlert.addAction(logout)
        targetVC.present(actionAlert, animated: true, completion: nil)
    }
    
    func actionSheet(targetVC: UIViewController, sender:UIButton? = nil, completionHandler: @escaping (_ success:Bool)-> Void){
        let actionSheetController: UIAlertController = UIAlertController(title: "Opciones", message: nil, preferredStyle: .actionSheet)
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Cerrar sesion", style: .default) { action -> Void in
            completionHandler(true)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .cancel) { action -> Void in }
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        if UIDevice.isPhone {
            targetVC.present(actionSheetController, animated: true, completion: nil)
        } else {
            actionSheetController.popoverPresentationController?.barButtonItem = targetVC.navigationItem.rightBarButtonItem
            targetVC.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    func actionSheetOpciones(targetVC: UIViewController, sender:UIButton? = nil, completionHandler: @escaping (_ success:Bool, _ response:Int)-> Void){
        let actionSheetController: UIAlertController = UIAlertController(title: "Opciones", message: nil, preferredStyle: .actionSheet)
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Cerrar sesion", style: .default) { action -> Void in
            completionHandler(true,1)
        }
        let ciclosAction: UIAlertAction = UIAlertAction(title: "Cambiar ciclo", style: .default) { action -> Void in
            completionHandler(true,2)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .cancel) { action -> Void in }
        actionSheetController.addAction(ciclosAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        if UIDevice.isPhone {
            targetVC.present(actionSheetController, animated: true, completion: nil)
        } else {
            actionSheetController.popoverPresentationController?.barButtonItem = targetVC.navigationItem.rightBarButtonItem
            targetVC.present(actionSheetController, animated: true, completion: nil)
        }
    }
}

