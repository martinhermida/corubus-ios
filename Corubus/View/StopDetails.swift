import SwiftUI
import MapKit

struct StopDetails: View {
    let stop: Stop
    
    func openMap() {
        let mapItem = MKMapItem(
            placemark: MKPlacemark(
                coordinate: CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
            )
        )
        mapItem.name = stop.name
        mapItem.openInMaps()
    }
    
    var body: some View {
        List {
            Section(header:
                HStack(alignment: .center) {
                    Spacer()
                    Text(stop.name)
                        .font(Font.title2.bold())
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .textCase(nil)
                        .padding(.top, 5)
                    Spacer()
                }
            ) {
                EmptyView()
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            Section(header: ListSectionHeader(text: "stop.ETAsTitle")) {
                ConnectionsList(stop: stop)
            }

            MapView(stop: stop)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .frame(height: 200, alignment: .center)
                .onTapGesture(perform: openMap)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(String(stop.id), displayMode: .inline)
    }
}
