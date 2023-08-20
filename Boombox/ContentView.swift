//
//  ContentView.swift
//  Boombox
//
//  Created by lucas urbain on 03.08.23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var isBluetoothSheetPresented = false
    let numberOfSounds = AudioView().colors.count
    
    var body: some View {
        NavigationView {
           VStack {
               Spacer()
               
               TabView(selection: $selectedTab) {
                   AudioView()
                       .tabItem {
                           Image(systemName: "music.note")
                           Text("Audio")
                       }
                       .tag(0)
                   DataView(audioManager: AudioManager.shared, numberOfSounds: AudioView().colors.count)
                       .tabItem {
                           Image(systemName: "chart.bar")
                           Text("Data")
                       }
                       .tag(1)
               }
           }
           .background(Color("DarkGray"))
           .navigationBarTitle("", displayMode: .inline)
           .toolbar {
               ToolbarItem(placement: .navigationBarTrailing) {
                   addNavigationBarImage()
               }
           }
           .edgesIgnoringSafeArea(.bottom)
           .foregroundColor(.white)
           .accentColor(Color("Green")) // Change to Color("Green")
           .onAppear {
               UITabBar.appearance().unselectedItemTintColor = UIColor(.gray)
           }
       }
    }
    
    private func addNavigationBarImage() -> some View {
        return Button(action: {
            openBluetoothSettings()
        }) {
            Image(systemName: "car.front.waves.up.fill")
                .font(.system(size: 12, weight: .semibold, design: .default))
                .frame(width: 42, height: 42)
                .foregroundColor(Color("DarkGray"))
                .background(Color("Green"))
                .clipShape(Circle())
                .shadow(radius: 10)
                .padding()
        }
    }
    
    private func openBluetoothSettings() {
        guard let url = URL(string: "App-Prefs:root=Bluetooth") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
