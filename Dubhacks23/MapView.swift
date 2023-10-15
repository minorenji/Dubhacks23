import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
  @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)) // Set the initial region of the map
  @State private var locationManager = CLLocationManager() // Create a new CLLocationManager instance
  @State private var userLocationPin = LocationPin(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), type: .start) // Declare the userLocationPin variable as a @State variable

  @State private var photoLocations = [LocationPin]()
  
  var body: some View {
    ZStack(alignment: .bottom) { // Use a ZStack to layer the Map view and the camera button view
      Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow),
          annotationItems: ([userLocationPin] + photoLocations)) { pin in // Use the view to display the map and the user's location pin
        MapAnnotation(coordinate: pin.coordinate) {
          switch pin.type {
          case .start:
            Image(systemName: "mappin.and.ellipse.circle.fill")
              .resizable()
              .frame(width: 25, height: 25)
              .foregroundColor(.red)
          case .photo:
            Image(systemName: "camera.circle.fill")
              .resizable()
              .frame(width: 50, height: 50)
              .foregroundColor(.blue)
              .background(.white)
              .clipShape(Circle())
              .overlay(Circle().stroke(.black, lineWidth: 1))
          }

        }


      }
      
      NavigationLink {
        CameraView(addPhotoLocation: {
          if let location = locationManager.location?.coordinate { // Check if the location data is available


            photoLocations.append(LocationPin(coordinate: location, type: .photo))// Update the coordinate of the user's location pin
  // Update the title of the user's location pin
        }})
      } label:{
        Image(systemName: "camera")
          .resizable()
          .frame(width: 38, height: 32)
          .padding()
          .background(Color.white)
          .clipShape(RoundedRectangle(cornerRadius: 15))
          .shadow(radius: 5)
      }
      .padding(.bottom, 16) // Add padding to the bottom of the camera button view
    }
    .ignoresSafeArea()
    .onAppear {
      locationManager.requestWhenInUseAuthorization() // Request location authorization from the user
      locationManager.desiredAccuracy = kCLLocationAccuracyBest // Set the desired accuracy of the location data
      locationManager.startUpdatingLocation() // Start updating the location data
      
      if let location = locationManager.location?.coordinate { // Check if the location data is available
        region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)) // Update the region of the map to center on the user's current location
        
        DispatchQueue.main.async {
                    userLocationPin.coordinate = location // Update the coordinate of the user's location pin
          } // Update the coordinate of the user's location pin
// Update the title of the user's location pin
      }
    }
  }
}

enum PinType {
  case start
  case photo
}

struct LocationPin: Identifiable {
  let id = UUID()
  var coordinate: CLLocationCoordinate2D
  var type: PinType
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView()
  }
}
