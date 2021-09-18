//
//  Constants.swift
//  S3BankiOS
//
//  Created by Adriano Carnaroli.
//  Copyright © 2021 Adriano Carnaroli. All rights reserved.
//

import Foundation
import UIKit


struct Constants {
    static let btnOk = "OK"
    static let yes = "Sim"
    static let no = "Não"
    static let btnCancel = "Cancelar"
    static let openSettings = "Configurações"
    static let errorColor = UIColor(hexString: "#E70000") // vermelho
    static let textColor = UIColor(hexString: "#4A4A4A") //cinza escuro
    static let buttonColor = UIColor(hexString: "#C95D33") // laranja
    static let buttonDisabledColor = UIColor(hexString: "#EFEFEF") //cinza claro
    static let textDisableColor = UIColor(hexString: "#939393") //cinza escuro
    static let linkButton = UIColor(hexString: "#C95D33") // marrom escuro

    static let cpfMask = "###.###.###-##"
    static let cpfMaskNumbers = "000.000.000-00"
    static let cellphoneMaskNumbers = "(00) 00000-0000"
    static let cellphoneMaskKey = "(##) #####-####"
    static let dateMask = "00/00/0000"
    static let zipcodeMask = "#####-###"

    static let imageEyeOn = "eyeOn"
    static let imageEyeOff = "eyeOff"

    static let defaultServiceError = "Não foi possível processar sua solicitação no momento. Tente novamente mais tarde."

}
