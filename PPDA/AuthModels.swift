
struct LoginRequest: Encodable {
    let correo: String
    let password: String
}

struct LoginResponse: Decodable {
    let mensaje: String
    let token: String
    let usuario: Usuario
}

struct Usuario: Decodable {
    let id: Int
    let nombre: String
    let correo: String
    let rol: String
    let activo: Bool
}

struct APIErrorResponse: Decodable {
    let mensaje: String
}

struct PerfilResponse: Decodable {
    let mensaje: String
    let usuario: UsuarioPerfil
}

struct UsuarioPerfil: Decodable {
    let id: Int
    let nombre: String
    let correo: String
    let rol: String
    let activo: Bool
    let estudiante: EstudiantePerfil?
    let acudiente: AcudientePerfil?
}

struct EstudiantePerfil: Decodable {
    let id: Int
    let documento: String?
    let grupoId: Int?
    let activo: Bool
    let grupo: GrupoPerfil?
    let acudientes: [RelacionAcudientePerfil]?
}

struct AcudientePerfil: Decodable {
    let id: Int
    let nombre: String
    let telefono: String?
    let correo: String?
    let estudiantes: [RelacionEstudiantePerfil]?
}

struct GrupoPerfil: Decodable {
    let id: Int
    let nombre: String
    let grado: String?
    let activo: Bool
}

struct RelacionAcudientePerfil: Decodable {
    let parentesco: String?
    let acudiente: AcudienteBasico
}

struct AcudienteBasico: Decodable {
    let id: Int
    let nombre: String
    let telefono: String?
    let correo: String?
}

struct RelacionEstudiantePerfil: Decodable {
    let parentesco: String?
    let estudiante: EstudianteBasico
}

struct EstudianteBasico: Decodable {
    let id: Int
    let nombre: String
    let documento: String?
    let grupoId: Int?
    let activo: Bool
    let grupo: GrupoPerfil?
}
