//
//  SessionDetailView.swift
//  iOSDevUK
//
//  Created by David Kababyan on 03/10/2022.
//

import SwiftUI
import CoreData

struct SessionDetailView: View {
    @Environment(\.managedObjectContext) var moc
    
    @StateObject private var viewModel: SessionDetailViewModel
    
    init(sessionId: String) {
        self.init(viewModel: SessionDetailViewModel(sessionId: sessionId))
    }
    
    private init(viewModel: SessionDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    @ViewBuilder
    private func headerView() -> some View {
        ZStack(alignment: .bottomLeading) {
            Image(ImageNames.img1)
                .resizable()
                .frame(height: 250)
                .aspectRatio(contentMode: .fit)
            
            Text(viewModel.session?.title ?? "Loading...")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding([.horizontal, .bottom])
        }
    }
    
    @ViewBuilder
    private func descriptionView() -> some View {
        VStack(alignment: .leading) {
            Text("Description")
                .font(.title3)
                .foregroundColor(.gray)
                .bold()
                .padding(.vertical)
            
            Text(viewModel.session?.content ?? "Loading...")
                .multilineTextAlignment(.leading)
                .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func speakersView() -> some View {
        
        VStack(alignment: .leading) {
            Text("Speaker(s)")
                .font(.title3)
                .foregroundColor(.gray)
                .bold()
                .padding(.bottom)
            
            ForEach(viewModel.speakers ?? []) { speaker in
                NavigationLink {
                    SpeakerDetailView(speaker: speaker)
                } label: {
                    Text(speaker.name)
                        .font(.title3)
                        .padding(.bottom, 5)
                }
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func locationView(_ location: Location) -> some View {
        
        VStack(alignment: .leading) {
            Text("Location")
                .font(.title3)
                .foregroundColor(.gray)
                .bold()
                .padding(.bottom)

                NavigationLink {
                        MapView(allLocations: [location])
                } label: {
                    Text(location.name)
                        .font(.subheadline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
            
        }
        .padding()
    }
    
    @ViewBuilder
    private func navigationBarTrailingItem() -> some View {
        Button {
            viewModel.addToMySession(moc: moc)
        } label: {
            Image(systemName: ImageNames.bookmark)
        }
    }

    
    @ViewBuilder
    private func main() -> some View {

        ScrollView {
            VStack(alignment: .leading) {
                headerView()
                descriptionView()
                if let speakers = viewModel.speakers, !speakers.isEmpty {
                    speakersView()
                }
                if let location = viewModel.location {
                    locationView(location)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    var body: some View {
        main()
            .edgesIgnoringSafeArea(.top)
            .task {
                //TODO: Why its called on pop
                await viewModel.fetchSession()
                await viewModel.fetchSpeakers()
                await viewModel.fetchLocation()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: navigationBarTrailingItem)
            }
    }
}

struct SessionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SessionDetailView(sessionId: DummyData.session.id)
        }
    }
}
