//
//  SpeakerDetailView.swift
//  iOSDevUK
//
//  Created by David Kababyan on 10/09/2022.
//

import SwiftUI

struct SpeakerDetailView: View {
    @StateObject private var viewModel: SpeakerDetailViewModel
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    init(speaker: Speaker) {
        self.init(viewModel: SpeakerDetailViewModel(speaker: speaker))
    }
    
    private init(viewModel: SpeakerDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    @ViewBuilder
    private func headerView() -> some View {
        
        HStack {
            RemoteImageView(url: viewModel.speaker.imageUrl)
                .cornerRadius(15)
                .scaledToFit()
                .frame(width: 100, height: 120)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.speaker.name)
                    .font(.title)
                    .minimumScaleFactor(0.7)

                if let twitterUrl = URL(string: "\(BaseUrl.twitter)\(viewModel.speaker.twitterId)") {
                    Link("Twitter: @\(viewModel.speaker.twitterId)", destination: twitterUrl)
                }
                if let linkedInUrl = URL(string: "\(BaseUrl.linkedIn)\(viewModel.speaker.linkedIn)") {
                    Link("LinkedIn: \(viewModel.speaker.linkedIn)", destination: linkedInUrl)
                }
                
                Spacer()
            }
            .padding(.bottom, 20)
        }
    }
    
    @ViewBuilder
    private func descriptionView() -> some View {
        Text("Biography")
            .font(.title2)
            .bold()
            .foregroundColor(.gray)
            .padding(.vertical)
        
        Text(viewModel.speaker.biography)
            .multilineTextAlignment(.leading)
            .padding(.bottom, 10)
    }
    
    @ViewBuilder
    private func sessionsRaw(session: Session) -> some View {
        VStack(alignment: .leading) {
            Text("\(session.title)")
                .font(.subheadline)
                .lineLimit(2)
                
            Text("\(session.duration)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.bottom, 10)
    }

    
    @ViewBuilder
    private func sessionsView() -> some View {

        if !viewModel.sessions.isEmpty {
            Text("Session(s)")
                .font(.title3)
                .foregroundColor(.gray)
                .bold()
                .padding(.vertical, 10)
            
            ForEach(viewModel.sessions) { session in
                
                NavigationLink(value: Destination.session(session)) {
                    sessionsRaw(session: session)
                }
            }
        }
    }
    
    @ViewBuilder
    private func main() -> some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                headerView()
                Divider()
                descriptionView()
                Divider()
                sessionsView()
            }
        }
        .scrollIndicators(.hidden)
        .padding()
        .alert(isPresented: $viewModel.showError, content: {
            Alert(title: Text("Error!"), message: Text(viewModel.fetchError?.localizedDescription ?? ""), dismissButton: .default(Text("OK")))
        })
    }
    
    var body: some View {
        main()
            .navigationBarTitleDisplayMode(.inline)
            .task(viewModel.getSpeakerSessions)
    }
}

struct SpeakerDetailView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView {
            SpeakerDetailView(speaker: DummyData.speakers[0])
        }
    }
}
