//
//  AttendeeView.swift
//  iOSDevUK
//
//  Created by David Kababyan on 10/09/2022.
//

import SwiftUI

struct AttendeeView: View {
    @EnvironmentObject var viewModel: BaseViewModel
    @EnvironmentObject var router: NavigationRouter

    var categories: [String : [Location]] {
        .init(
            grouping: viewModel.locations,
            by: { $0.locationType.rawValue }
        )
    }
    
    @ViewBuilder
    private func navigationBarTrailingItem() -> some View {
        NavigationLink("All locations", value: Destination.locations(viewModel.locations))
    }
    
    @ViewBuilder
    private func informationView() -> some View {
        ForEach(viewModel.infoItems) { item in
            if let url = item.url {
                Link(destination: url) {
                    Text(item.name)
                        .fontWeight(.semibold)
                }
            } else {
                Text(item.name)
            }
        }
    }
    
    @ViewBuilder
    private func locationCategoryView() -> some View {
        
        ForEach(categories.keys.sorted(), id: \String.self) { key in
            
            Section {
                ForEach(categories[key] ?? [], id: \.id) { location in
                    
                    NavigationLink(value: Destination.locations([location])) {
                        Text(location.name)
                            .font(.subheadline)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                }
            } header: {
                let locationType: LocationType = LocationType(rawValue: key) ?? .other
                SectionHeaderView(title: locationType.name)
                    .font(.headline)
            }
        }
    }
    
    @ViewBuilder
    private func main() -> some View {
        
        Form {
            Section {
                informationView()
            } header: {
                SectionHeaderView(title: "Information")
                    .font(.headline)
            }
            
            Section { } header: {
                Text("Locations")
                      .font(.headline)
                      .foregroundColor(.primary)
            }
            .padding(.bottom, -10)
                
            locationCategoryView()
        }
    }

    var body: some View {
        NavigationStack(path: $router.attendeePath) {
            main()
                .navigationTitle("Attendee Info")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing, content: navigationBarTrailingItem)
                }
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .session(let session):
                        SessionDetailView(sessionId: session.id)
                    case .sessions(let sessions):
                        AllSessionsView(sessions: sessions)
                    case .speaker(let speaker):
                        SpeakerDetailView(speaker: speaker)
                    case .speakers(let speakers):
                        AllSpeakersView(speakers: speakers)
                    case .sponsor:
                        SponsorsView()
                    case .locations(let locations):
                        MapView(allLocations: locations)
                    case .savedSession(let savedSession):
                        SessionDetailView(sessionId: savedSession.id ?? "")
                    }
                }
        }
    }
}

struct AttendeeView_Previews: PreviewProvider {
    static var previews: some View {
        AttendeeView()
    }
}
