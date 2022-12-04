import SwiftUI
import CoreLocation

struct Stops: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var locationManager = LocationManager()
    @State var search = ""

    var searchList: some View {
        ForEach(Stop.searchStops(search, appState.stops)) { stop in
            StopView(stop: stop, addableToHistory: true)
        }
    }

    var sectionList: some View {
        Group {
            Section(header: ListSectionHeader(text: "stops.nearby")) {
                if locationManager.locationStatus != CLAuthorizationStatus.authorizedAlways && locationManager.locationStatus != CLAuthorizationStatus.authorizedWhenInUse {
                    HStack(alignment: .center) {
                        Spacer()
                        if locationManager.locationStatus == CLAuthorizationStatus.notDetermined {
                            ActivateLocation(requestAuthorization: self.locationManager.requestAuthorization)
                        } else {
                            LocationDenied()
                        }
                        Spacer()
                    }
                    .frame(height: 115)
                } else {
                    ForEach(Stop.getClosestStops(appState.stops, locationManager.lastLocation)) { stop in
                        StopView(stop: stop, autoFetch: true)
                    }
                }
            }
            .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 15))
            .textCase(.none)

            Section(header: ListSectionHeader(text: "stops.history")) {
                if appState.searchHistory.count == 0 {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("stops.historyPlaceholder")
                            .multilineTextAlignment(.center)
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                            .padding(.horizontal, 15)
                        Spacer()
                    }
                    .frame(height: 115)
                } else {
                    ForEach(appState.searchHistory, id: \.self) { id in
                        StopView(stop: self.appState.stops[id]!, collapsed: true, removableFromHistory: true)
                    }
                }
            }
            .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 15))
            .textCase(.none)
        }
    }

    var body: some View {
        NavigationView {
            List {
                if !search.isEmpty {
                    searchList
                } else {
                    sectionList
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("tabs.stops")
            .searchable(text: $search)
            .disableAutocorrection(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tabItem {
            Image(systemName: "mappin").imageScale(.large)
            Text("tabs.stops")
        }
    }
}

struct Stops_Previews: PreviewProvider {
    static var previews: some View {
        Stops()
    }
}
