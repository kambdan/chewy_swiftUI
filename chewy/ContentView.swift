//
//  ContentView.swift
//  chewy
//
//  Created by Juan Cambizaca on 5/11/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var showLocationPicker = false
        @State private var selectedLocation: String = "San Francisco"
        @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    var body: some View {
        VStack {
            Text("Chewy")
                .bold()
            Image("dog")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Soy un golden retriever de 2 años. Me encanta jugar con mis juguetes y correr por el parque.")
                .padding()
        }
        .padding()
        
        VStack (alignment: .leading) {
            HStack {
                makeIconTextContainer(imageName: "birthday", description: "2 años de edad")
                    .frame(maxWidth: .infinity)
                makeIconTextContainer(imageName: "location", description: "San Francisco")
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        showLocationPicker = true
                     }
                    
            }
           
                makeIconTextContainer(imageName: "golden", description: "Golden Gate    ")
                .frame(maxWidth: .infinity, alignment: .leading)
             
            
        }
        .padding(.horizontal)
        Spacer()
        Button(action: {
            // Acción del botón
        }) {
            Text("Iniciar configuración")
                .padding()
                .frame(maxWidth: .infinity) // Ocupa todo el ancho
                .background(Color(red: 242/255, green: 69/255, blue: 13/255))
                .foregroundColor(.white)
                .cornerRadius(30) // Esquinas redondeadas
                .padding(.horizontal)
                .bold()
        }
        .sheet(isPresented: $showLocationPicker) {
            LocationPickerView(selectedLocation: $selectedLocation, isPresented: $showLocationPicker)
        }}
    
    func makeIconTextContainer(imageName: String, description: String) -> some View {
        HStack(spacing: 8) {
            Image(imageName)
            Text(description)
                .bold()
        }
        
        .padding()
        .frame(maxWidth: UIScreen.main.bounds.width * 0.45)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(red: 232/255, green: 214/255, blue: 207/255), lineWidth: 1)
        )
  
    }
}

struct LocationPickerView: View {
    @Binding var selectedLocation: String
    @Binding var isPresented: Bool
    @State private var searchText = ""
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    ))
    
    private let locations = [
        "San Francisco",
        "Los Angeles",
        "New York",
        "Chicago",
        "Miami",
        "Seattle",
        "Boston",
        "Denver"
    ]
    
    var filteredLocations: [String] {
        if searchText.isEmpty {
            return locations
        }
        return locations.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Nuevo Mapa con sintaxis iOS 17
                Map(position: $cameraPosition) {
                    Annotation("Seleccionar Ubicación", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                    }
                }
                .frame(height: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding()
                
                // Barra de búsqueda
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Buscar ubicación", text: $searchText)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Lista de ubicaciones
                List(filteredLocations, id: \.self) { location in
                    Button(action: {
                        selectedLocation = location
                        isPresented = false
                    }) {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.blue)
                            Text(location)
                            Spacer()
                            if location == selectedLocation {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Seleccionar Ubicación")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
