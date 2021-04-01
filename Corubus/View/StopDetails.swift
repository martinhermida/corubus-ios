import SwiftUI
import MapKit

struct StopDetails: View {
    let stop: Stop
    @State var linesETAs: [Int: [String]]?
    @State private var timer: Timer?
    
    init(stop: Stop, linesETAs: [Int: [String]]?) {
        self.stop = stop
        self.linesETAs = linesETAs
    }
    
    func pollLinesETAs() {
        self.timer = self.stop.pollLinesETAs { linesETAs in
            self.linesETAs = linesETAs
        }
    }
    
    var body: some View {
        GeometryReader { g in
            ScrollView {
                HStack(alignment: .top, spacing: 15) {
                    Text(String(stop.id))
                        .font(Font.title2.bold())
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7))
                        .background(Color.black)
                        .cornerRadius(5)
                        .padding(.top, -2)
                    Text(stop.name)
                        .font(Font.title.bold())
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(EdgeInsets(top: 30, leading: 25, bottom: 15, trailing: 15))
                
                List {
                    Section(header: ListSectionHeader(text: "stop.ETAsTitle")) {
                        Connections(stop: stop, expanded: true, linesETAs: linesETAs)
                            .padding(.vertical, 7)
                    }
                    .textCase(.none)

                    MapView(stop: stop)
                        .frame(height: 200, alignment: .center)
                        .padding(EdgeInsets(top: -10, leading: -20, bottom: -10, trailing: -20))
                        .onTapGesture {
                            let mapItem = MKMapItem(
                                placemark: MKPlacemark(
                                    coordinate: CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
                                )
                            )
                            mapItem.name = stop.name
                            mapItem.openInMaps()
                        }
                }
                .listStyle(InsetGroupedListStyle())
                .frame(height: g.size.height - 130, alignment: .center)
            }
            .background(Color(UIColor.systemGray6))
            .navigationBarTitle(String(stop.id), displayMode: .inline)
        }
        .onAppear {
            self.pollLinesETAs()
        }
        .onDisappear {
            self.timer?.invalidate()
        }
    }
}
