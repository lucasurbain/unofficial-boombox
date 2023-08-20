// DataView.swift
// Boombox
// Created by lucas urbain on 03.08.23.

import SwiftUI

struct DataView: View {
    @ObservedObject var audioManager: AudioManager
    let numberOfSounds: Int

    var body: some View {
        VStack(spacing: 20) {
            Text("Informations de l'application")
                .font(.title)
                .foregroundColor(.white)
                .padding()

            InfoRow(title: "Version", value: getAppVersion())
            InfoRow(title: "Développeur", value: "Copyright © 2023 Lucas Urbain | All Rigths Reserved.")
            InfoRow(title: "Nombre de sons disponibles", value: "\(numberOfSounds)")

            Spacer()
        }
        .background(Color("DarkGray").ignoresSafeArea())
    }

    private func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return "Version \(version)"
        }
        return "Version inconnue"
    }
}

struct InfoRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView(audioManager: AudioManager.shared, numberOfSounds: 5)
    }
}
