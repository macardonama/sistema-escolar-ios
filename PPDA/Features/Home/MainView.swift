import SwiftUI

struct MainView: View {
    let usuario: UsuarioPerfil

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Dashboard PPDA")
                    .font(.largeTitle)
                    .bold()

                VStack(spacing: 8) {
                    Text("Bienvenido")
                        .font(.headline)

                    Text(usuario.nombre)
                        .font(.title2)
                        .bold()

                    Text("Rol: \(usuario.rol)")
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                if let estudiante = usuario.estudiante {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Perfil estudiante")
                            .font(.headline)

                        Text("Estudiante ID: \(estudiante.id)")

                        if let grupo = estudiante.grupo {
                            Text("Grupo: \(grupo.nombre)")
                        }

                        Text("Acudientes asociados: \(estudiante.acudientes?.count ?? 0)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                if let acudiente = usuario.acudiente {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Perfil acudiente")
                            .font(.headline)

                        Text("Acudiente ID: \(acudiente.id)")
                        Text("Estudiantes asociados: \(acudiente.estudiantes?.count ?? 0)")

                        if let estudiantes = acudiente.estudiantes, !estudiantes.isEmpty {
                            Divider()

                            Text("Mis acudidos")
                                .font(.headline)

                            ForEach(estudiantes, id: \.estudiante.id) { relacion in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(relacion.estudiante.nombre)
                                        .font(.subheadline)
                                        .bold()

                                    Text("Parentesco: \(relacion.parentesco ?? "No registrado")")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)

                                    if let grupo = relacion.estudiante.grupo {
                                        Text("Grupo: \(grupo.nombre)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Text("Estado: \(relacion.estudiante.activo ? "Activo" : "Inactivo")")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 6)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Inicio")
        }
    }
}

#Preview {
    MainView(
        usuario: UsuarioPerfil(
            id: 1,
            nombre: "Mateo Cardona",
            correo: "mateo@test.com",
            rol: "ADMINISTRATIVO",
            activo: true,
            estudiante: nil,
            acudiente: nil
        )
    )
}
//
//  MainView.swift
//  PPDA
//
//  Created by Mateo Cardona Marin on 23/06/26.
//

