import SwiftUI

struct DashboardView: View {
    @State private var dashboard: DashboardData?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if isLoading {
                    ProgressView("Cargando dashboard...")
                        .frame(maxWidth: .infinity)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }

                if let dashboard {
                    noticiasSection(dashboard.noticias)
                    eventosSection(dashboard.eventos)
                    galeriaSection(dashboard.galeria)
                }
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .task {
            await cargarDashboard()
        }
    }

    @MainActor
    private func cargarDashboard() async {
        guard dashboard == nil else { return }

        guard let token = TokenStore.shared.token else {
            errorMessage = "No hay sesión activa."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let respuesta = try await APIClient.shared.obtenerDashboard(token: token)
            dashboard = respuesta.dashboard
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func noticiasSection(_ noticias: [DashboardNoticia]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Noticias institucionales")
                .font(.title2)
                .bold()

            if noticias.isEmpty {
                Text("No hay noticias disponibles.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(noticias) { noticia in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(noticia.titulo)
                            .font(.headline)

                        if let descripcion = noticia.descripcion {
                            Text(descripcion)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }

    private func eventosSection(_ eventos: [DashboardEvento]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Próximos eventos")
                .font(.title2)
                .bold()

            if eventos.isEmpty {
                Text("No hay eventos disponibles.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(eventos) { evento in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(evento.titulo)
                            .font(.headline)

                        Text(evento.fecha)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }

    private func galeriaSection(_ galeria: [DashboardGaleriaItem]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Galería institucional")
                .font(.title2)
                .bold()

            if galeria.isEmpty {
                Text("No hay elementos en la galería.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(galeria) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.titulo)
                            .font(.headline)

                        if let descripcion = item.descripcion {
                            Text(descripcion)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
}
