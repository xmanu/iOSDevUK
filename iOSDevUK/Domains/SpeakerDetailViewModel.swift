//
//  SpeakerDetailViewModel.swift
//  iOSDevUK
//
//  Created by David Kababyan on 20/09/2022.
//

import SwiftUI

final class SpeakerDetailViewModel: ObservableObject {

    @Environment(\.openURL) var openURL
    
    @Published private(set) var sessions:[Session] = []
    @Published private(set) var speaker: Speaker
    
    init(speaker: Speaker) {
        self.speaker = speaker
    }
    
    @MainActor
    @Sendable func getSpeakerSessions() async {
        do {
            sessions = try await FirebaseRepository().getDocuments(from: .Session, where: "speakerIds", arrayContains: speaker.id) ?? []
        } catch {
            print("Error getting sessions")
        }
    }

    
    func showTwitterAccount() {
        guard let url = URL(string: "https://twitter.com/\(speaker.twitterId)") else { return }
        self.openURL(url)
    }

    func showLinkedInAccount() {
        guard let url = URL(string: "https://linkedIn.com/in/\(speaker.linkedIn)") else { return }
        self.openURL(url)
    }
}
