//
//  ViewController.swift
//  Calculadora
//
//  Transcribed by JOSE LEONARDO DIAZ on 24/5/16.
//

import UIKit

class ViewController: UIViewController {

    //propiedad pantalla donde se muestran los digitos presionados y el resultado de la operacion
    //el signo de exclamacion extrae el valor asociado del Optional(UILabel)
    @IBOutlet weak var pantalla: UILabel!
    
    // En programacion "Naming is everything", no se especifica el tipo por que el compilador puede determinar el tipo de dato automaticamente
    var usuarioEstaEnLaMitadDeEscritura = false;

    @IBAction func botonDigitoPresionado(sender: UIButton) {
        //Se extrae el valor asociado del Optional(String) retornado por sender.currentTitle
        let textoEnBoton = sender.currentTitle!
        
        //Valida si es la primera presión de boton para concatenar/remplazar el valor en pantalla
        if usuarioEstaEnLaMitadDeEscritura {
            let textoActualmenteEnPantalla = pantalla.text!
            pantalla.text = textoActualmenteEnPantalla + textoEnBoton
        } else {
            
            pantalla.text = textoEnBoton
        }
        
        usuarioEstaEnLaMitadDeEscritura = true
    }
    
    @IBAction func operacionPresionada(sender: UIButton) {
        //una vez presionada una operacion no se concatena el siguiente boton presionado a la pantalla
        usuarioEstaEnLaMitadDeEscritura = false
        
        if let operacionMatematica = sender.currentTitle {
            if operacionMatematica == "π" {
                pantalla.text = String(M_PI)
            }
        }
    }

}

