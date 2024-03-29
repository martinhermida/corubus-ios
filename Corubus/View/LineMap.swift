import SwiftUI
import MapKit

struct LineMap: View {
    let returnJourney: Bool
    let line: Line
    @Environment(\.colorScheme) var colorScheme
    @State var routes = [MKPolyline?](repeating: nil, count: 2)

    var body: some View {
        ZStack {
            MapView(line: line, route: routes[returnJourney ? 1 : 0])
                .blur(radius: routes[0] == nil ? CGFloat(7) : CGFloat(0))
                .animation(.default)
                .edgesIgnoringSafeArea(.all)
                .zIndex(1)
                .onAppear {
                    line.getPath { routes = $0 }
                }
            
            if routes[0] == nil {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white.opacity(0.4))
                    .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.2)))
                    .zIndex(2)
            }
        }
    }
}
