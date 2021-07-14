//
//  ZipcodeResponse.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 02/05/21.
//

import Foundation

// MARK: - ZipcodeResponse
struct ZipcodeResponse: Codable {
    let cep: String
    let logradouro: String
    let complemento: String
    let bairro: String
    let localidade: String
    let uf: String
    let ibge: String
    let gia: String
    let ddd: String
    let siafi: String

    enum CodingKeys: String, CodingKey {
        case cep
        case logradouro
        case complemento
        case bairro
        case localidade
        case uf
        case ibge
        case gia
        case ddd
        case siafi
    }
}

