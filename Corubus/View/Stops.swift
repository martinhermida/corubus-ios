import SwiftUI
import CoreLocation

struct Stops: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var searchBar = SearchBar()
    @ObservedObject var locationManager = LocationManager()

    var searchList: some View {
        ForEach(Stop.searchStops(searchBar.text, appState.stops)) { stop in
            StopView(stop: stop, addableToHistory: true)
        }
    }

    var sectionList: some View {
        Group {
            Section(header: ListSectionHeader(text: "stops.nearby")) {
                if locationManager.locationStatus != CLAuthorizationStatus.authorizedAlways && locationManager.locationStatus != CLAuthorizationStatus.authorizedWhenInUse {
                    VStack(alignment: .center) {
                        if locationManager.locationStatus == CLAuthorizationStatus.notDetermined {
                            ActivateLocation(requestAuthorization: self.locationManager.requestAuthorization)
                        } else {
                            LocationDenied()
                        }
                    }
                    .frame(maxWidth: .infinity, idealHeight: 115)
                } else {
                    ForEach(Stop.getClosestStops(appState.stops, locationManager.lastLocation)) { stop in
                        StopView(stop: stop, autoFetch: true)
                    }
                }
            }
            Section(header: ListSectionHeader(text: "stops.history")) {
                if appState.searchHistory.count == 0 {
                    VStack(alignment: .center) {
                        Text("stops.historyPlaceholder")
                            .multilineTextAlignment(.center)
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                            .padding(.horizontal, 15)
                    }
                    .frame(maxWidth: .infinity, idealHeight: 115)
                } else {
                    ForEach(appState.searchHistory, id: \.self) { id in
                        StopView(stop: self.appState.stops[id]!, collapsed: .collapsed)
                    }
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                if searchBar.searchController.isActive {
                    searchList
                } else {
                    sectionList
                }
            }
            .navigationBarTitle("tabs.stops")
            .add(searchBar)
        }

        .tabItem {
           Image(systemName: "mappin").font(.system(size: 22))
           Text("tabs.stops")
        }
    }
}

struct Stops_Previews: PreviewProvider {
    static var previews: some View {
        Stops()
    }
}
