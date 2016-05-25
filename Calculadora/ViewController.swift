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
    private var usuarioEstaEnLaMitadDeEscritura = false;
    
    //Propiedad calculada para no estar haciendo "Casting" (String->Double y Double->String) al obtener y fijar el valor en la pantalla durante la ejecucion de una operacion
    private var valorEnPantalla: Double {
        get {
            return Double(pantalla.text!)!
        }
        set {
            pantalla.text = String(newValue)
        }
    }
    
    //La logica de la calculadora esta en la clase CerebroCalculadora
    private var cerebro = CerebroCalculadora()

    private var programaGuardado: CerebroCalculadora.ListaDePropiedades?

    @IBAction func guardarPrograma() {
        programaGuardado = cerebro.programa
    }
    
    @IBAction func recuperarPrograma() {
        if programaGuardado != nil {
            cerebro.programa = programaGuardado!
            valorEnPantalla = cerebro.resultado
        }
    }
    
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
        //Si el usuario escribe un numero y luego presiona una operacion se le informa al cerebro
        // para que lo tenga en cuenta y luego de ejecutar el igual u otra operacion vaya realizando el calculo
        if usuarioEstaEnLaMitadDeEscritura {
            usuarioEstaEnLaMitadDeEscritura = false
            
            cerebro.fijarOperando(valorEnPantalla)
        }
        
        //El cerebro determina el tipo de operacion que tiene que hacer con el operando anterior
        if let operacionMatematica = sender.currentTitle {
            cerebro.ejecutarOperacion(operacionMatematica)
        }
        
        //en cualquier caso el cerebro siempre tiene el resultado de la ultima operacion ejecutada
        valorEnPantalla = cerebro.resultado
    }

}







