//
//  CerebroCalculadora.swift
//  Calculadora
//
//  Created by JOSE LEONARDO DIAZ on 24/5/16.
//  Copyright © 2016 MayorgaFirm Inc. All rights reserved.
//

import Foundation

class CerebroCalculadora {
    
    //El acumulador interno de la calculadora
    private var acumulador = 0.0
    
    //Enum para describir las posibles operaciones que puede realizar esta calculadora
    //Usamos el concepto de Generics para parametrizar cada tipo de operacion segun corresponda (Double o closures con parametros determinados)
    private enum Operacion {
        case Constante(Double)
        case OperacionUnaria((Double) -> Double)
        case OperacionBinaria((Double, Double) -> Double)
        case Igual
    }
    
    //El diccionario que almacena la cadena que representa a una operacion en particular
    // se muestran las posibles maneras de escribir un closure en swift
    private var operaciones: Dictionary<String, Operacion> = [
        "π": Operacion.Constante(M_PI),
        "℮": Operacion.Constante(M_E),
        "±": Operacion.OperacionUnaria({ -$0 }),
        "√": Operacion.OperacionUnaria(sqrt),
        "x": Operacion.OperacionBinaria({(operando1: Double, operando2: Double) -> Double in
                                            return operando1 * operando2
                                        }),
        "/": Operacion.OperacionBinaria({ operando1, operando2 in return operando1 / operando2 }),
        "-": Operacion.OperacionBinaria({ operando1, operando2 in operando1 - operando2 }),
        "+": Operacion.OperacionBinaria({ $0 + $1 }),
        "=": Operacion.Igual
    ]
    
    //Estructura de datos para describir una operacion binaria pendiente de ejecucio, el primer parametro sabemos que va a ser el acumulador al momento de crear la operacion pendiente
    private struct DefinicionOperacionBinaria {
        var funcionBinaria: (Double, Double) -> Double
        var primerOperando: Double
    }
    
    //Opcional de operacion pendiente
    private var operacionBinariaPendiente: DefinicionOperacionBinaria?
    
    //fija el operador sobre el cual hay que ejecutar una operacion
    func fijarOperando(operando: Double){
        acumulador = operando
    }
    
    //propiedad calculada de solo lectura donde va a estar el ultimo resultado de alguna operacion
    var resultado: Double {
        get {
            return acumulador
        }
    }
    
    //Dependiendo de la operacion a ejecutar se realiza la accion correspondiente
    func ejecutarOperacion(simbolo: String) {
        if let operacion = operaciones[simbolo] {
            switch operacion {
            case .Constante(let numero):
                //si es constante solo almacenamos el numero que sea en el acumulador
                acumulador = numero
            case .OperacionUnaria(let functionMatematicaUnaria):
                //ejecuta la funcion sobre el acumulador actual
                acumulador = functionMatematicaUnaria(acumulador)
            case .OperacionBinaria(let functionMatematicaBinaria): //funcion binaria
                //intenta ejecutar la operacion binaria pendiente si es que la hay (Esto para ejecutar cada operacion cuando se presionen por ejemplo numero1 + operacion1 + numero2 + operacion2 + numero3 + igual, y ver el resultado intermedio al ejecutar operacion2)
                ejecutarOperacionPendiente()
                operacionBinariaPendiente = DefinicionOperacionBinaria(funcionBinaria: functionMatematicaBinaria, primerOperando: acumulador)
            case .Igual:
                //intenta ejecutar la operacion binaria pendiente actual
                ejecutarOperacionPendiente()
            }
        }
    }
    
    //Ejecuta la operacion pendiente si existe con los datos con que se crearon
    private func ejecutarOperacionPendiente() {
        if nil != operacionBinariaPendiente {
            acumulador = operacionBinariaPendiente!.funcionBinaria(operacionBinariaPendiente!.primerOperando, acumulador)
            operacionBinariaPendiente = nil
        }
    }
    
    
}