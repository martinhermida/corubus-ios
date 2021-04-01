import SwiftUI

struct StopDetails: View {
    let stop: Stop
    @State var linesETAs: [Int: [String]]?
    @State private var timer: Timer?
    
    func pollLinesETAs() {
        self.timer = self.stop.pollLinesETAs { linesETAs in
            self.linesETAs = linesETAs
        }
    }
    
    var body: some View {
        GeometryReader { g in
            ScrollView {
                HStack {
                    Text(stop.name)
                        .font(.system(size: 34, weight: .bold))
                        .padding()
                    Spacer()
                }
                
                List {
                    Section(header: ListSectionHeader(text: "stop.ETAsTitle")) {
                        Connections(stop: stop, expanded: true, linesETAs: linesETAs)
                            .padding(.vertical, 7)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .frame(width: g.size.width, height: g.size.height - 130, alignment: .center)
            }
            .background(Color(UIColor.systemGray6))
            .navigationBarTitle(String(stop.id), displayMode: .inline)
        }
        .onAppear {
            self.pollLinesETAs()
            print("hola")
        }
        .onDisappear {
            self.timer?.invalidate()
            print("adios")
        }
    }
}
