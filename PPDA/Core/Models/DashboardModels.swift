//
//  DashboardModels.swift
//  PPDA
//
//  Created by Mateo Cardona Marin on 24/06/26.
//

import Foundation

struct DashboardResponse: Decodable {
    let mensaje: String
    let dashboard: DashboardData
}

struct DashboardData: Decodable {
    let noticias: [DashboardNoticia]
    let eventos: [DashboardEvento]
    let galeria: [DashboardGaleriaItem]
}

struct DashboardNoticia: Decodable, Identifiable {
    let id: Int
    let titulo: String
    let descripcion: String?
    let color: String?
    let orden: Int?
    let activo: Bool?
    let creadoEn: String?
    let actualizadoEn: String?
}

struct DashboardEvento: Decodable, Identifiable {
    let id: Int
    let titulo: String
    let fecha: String
    let color: String?
    let orden: Int?
    let activo: Bool?
    let creadoEn: String?
    let actualizadoEn: String?
}

struct DashboardGaleriaItem: Decodable, Identifiable {
    let id: Int
    let titulo: String
    let descripcion: String?
    let imagenUrl: String?
    let orden: Int?
    let activo: Bool?
    let creadoEn: String?
    let actualizadoEn: String?
}
