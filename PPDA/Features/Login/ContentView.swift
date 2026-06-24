import SwiftUI

struct ContentView: View {
    @State private var correo = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var usuarioNombre: String?
    @State private var usuarioRol: String?
    @State private var token: String?
    @State private var perfilUsuario: UsuarioPerfil?

    var body: some View {
        if let perfilUsuario {
            MainView(usuario: perfilUsuario)
        } else {
            loginView
        }
    }
    private var loginView: some View {
        VStack(spacing: 20) {
            Text("PPDA")
                .font(.largeTitle)
                .bold()

            Text("Iniciar sesión")
                .font(.title2)

            TextField("Correo", text: $correo)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)

            SecureField("Contraseña", text: $password)
                .textFieldStyle(.roundedBorder)

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }

            Button {
                Task {
                    await iniciarSesion()
                }
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Entrar")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)

            Spacer()
        }
        .padding()
    }
    @MainActor
    private func iniciarSesion() async {
        errorMessage = nil
        usuarioNombre = nil
        usuarioRol = nil
        token = nil

        let correoLimpio = correo
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        let passwordLimpio = password
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if correoLimpio.isEmpty {
            errorMessage = "El correo es obligatorio"
            return
        }

        if passwordLimpio.isEmpty {
            errorMessage = "La contraseña es obligatoria"
            return
        }

        isLoading = true

        do {
            let respuesta = try await APIClient.shared.login(
                correo: correoLimpio,
                password: passwordLimpio
            )

            TokenStore.shared.token = respuesta.token
            let perfil = try await APIClient.shared.obtenerPerfil(token: respuesta.token)

            print("Perfil obtenido:")
            print("Nombre:", perfil.usuario.nombre)
            print("Rol:", perfil.usuario.rol)

            if let estudiante = perfil.usuario.estudiante {
                print("Estudiante ID:", estudiante.id)
                print("Grupo:", estudiante.grupo?.nombre ?? "Sin grupo")
            }

            if let acudiente = perfil.usuario.acudiente {
                print("Acudiente ID:", acudiente.id)
                print("Estudiantes asociados:", acudiente.estudiantes?.count ?? 0)
            }
            token = respuesta.token
            usuarioNombre = respuesta.usuario.nombre
            usuarioRol = respuesta.usuario.rol
            perfilUsuario = perfil.usuario
            
            print("Token recibido:", respuesta.token)
            print("Usuario:", respuesta.usuario.nombre)
            print("Rol:", respuesta.usuario.rol)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

#Preview {
    ContentView()
}
