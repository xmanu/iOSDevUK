//
//  InfoView.swift
//  iOSDevUK
//
//  Created by David Kababyan on 10/09/2022.
//

import SwiftUI

struct InfoView: View {
    @EnvironmentObject var router: NavigationRouter
    let firebaseAuth = FirebaseAuthentication.shared
    @State var showLoginView = false
    
    @ViewBuilder
    private func navigationBarTrailingItem() -> some View {
        if firebaseAuth.hasCurrentUser {
            NavigationLink("Admin", value: InfoDestination.admin)
        } else {
            Button("Admin") {
                showLoginView = true
            }
            .sheet(isPresented: $showLoginView, onDismiss: {
                if firebaseAuth.hasCurrentUser {
                    router.infoPath.append(InfoDestination.admin)
                }
            }, content: {
                LoginView()
            })
        }
    }
    
    var body: some View {
        NavigationStack(path: $router.infoPath) {
            Form {
                NavigationLink("Inclusivity", value: InfoDestination.inclusivity)
                NavigationLink("Sponsors", value: InfoDestination.sponsors)
                NavigationLink("About iOSDevUK", value: InfoDestination.aboutApp)
                NavigationLink("App Information", value: InfoDestination.appInformation)
            }
            .navigationTitle("Info")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: navigationBarTrailingItem)
            }
            .navigationDestination(for: InfoDestination.self) { destination in
                switch destination {
                case .inclusivity:
                    InclusivityView()
                case .sponsors:
                    SponsorsView()
                case .aboutApp:
                    AboutView()
                case .appInformation:
                    AppInformationView()
                case .admin:
                    AdminView()
                case .adminSpeakers:
                    AdminSpeakers()
                case .adminAddSpeaker(let speaker):
                    AddSpeakerView(viewModel: AdminSpeakerViewModel(speaker: speaker))
                case .adminSessions:
                    AdminSessions()
                case .adminAddSession(let session):
                    AddSession(viewModel: AdminSessionViewModel(session: session))
                case .adminLocations:
                    AdminLocations()
                case .adminAddLocation(let location):
                    AddLocation(viewModel: AdminLocationViewModel(location: location))
                case .adminSponsors:
                    AdminSponsors()
                case .adminAddSponsor(let sponsor):
                    AddSponsorView(viewModel: AdminSponsorViewModel(sponsor: sponsor))
                }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
