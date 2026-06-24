import Foundation

final class APIClient {
    static let shared = APIClient()

    private let baseURL = URL(string: "https://sistema-escolar-backend-wlfg.onrender.com")!

    private init() {}

    func login(correo: String, password: String) async throws -> LoginResponse {
        let url = baseURL.appendingPathComponent("/api/auth/login")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = LoginRequest(correo: correo, password: password)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(
                domain: "APIError",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Respuesta inválida del servidor"]
            )
        }

        if !(200...299).contains(httpResponse.statusCode) {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw NSError(
                    domain: "APIError",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: apiError.mensaje]
                )
            }

            throw NSError(
                domain: "APIError",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "Error desconocido"]
            )
        }

        return try JSONDecoder().decode(LoginResponse.self, from: data)
    }
    func obtenerPerfil(token: String) async throws -> PerfilResponse {
        let url = baseURL.appendingPathComponent("/api/auth/perfil")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(
                domain: "APIError",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Respuesta inválida del servidor"]
            )
        }

        if !(200...299).contains(httpResponse.statusCode) {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw NSError(
                    domain: "APIError",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: apiError.mensaje]
                )
            }

            throw NSError(
                domain: "APIError",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "Error desconocido"]
            )
        }

        return try JSONDecoder().decode(PerfilResponse.self, from: data)
    }
    
    func obtenerDashboard(token: String) async throws -> DashboardResponse {
        let url = baseURL.appendingPathComponent("/api/dashboard")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(
                domain: "APIError",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Respuesta inválida del servidor"]
            )
        }

        if !(200...299).contains(httpResponse.statusCode) {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw NSError(
                    domain: "APIError",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: apiError.mensaje]
                )
            }

            throw NSError(
                domain: "APIError",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "Error desconocido"]
            )
        }

        return try JSONDecoder().decode(DashboardResponse.self, from: data)
    }
}
