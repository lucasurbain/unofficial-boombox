import SwiftUI
import AVFoundation

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    private var player: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    private var timer: Timer?

    private init() {}

    func playSound(named sounds: String, isTrainSound: Bool) {
        guard let url = Bundle.main.url(forResource: sounds, withExtension: "mp3") else { return }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.volume = isTrainSound ? 0.05 : 1.0

            player?.play()
            isPlaying = true
            duration = player?.duration ?? 0
            startTimer()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func stopSound() {
        player?.stop()
        isPlaying = false
        stopTimer()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.currentTime = self.player?.currentTime ?? 0
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func seekToTime(_ time: TimeInterval) {
        player?.currentTime = time
    }
}

struct Colors: Hashable {
    let id = UUID()
    let name: String
    let colors: Color
    let sounds: String
}

struct AudioView: View {
    @StateObject private var audioManager = AudioManager.shared
    @State private var isSliderVisible = false

    let colors: [Colors] = [
        Colors(name: "auto.headlight.high.beam.fill", colors: .red, sounds: "cop-siren"),
        Colors(name: "theatermask.and.paintbrush.fill", colors: .purple, sounds: "mario-money-sound"),
        Colors(name: "figure.archery", colors: .blue, sounds: "train"),
        Colors(name: "sun.min.fill", colors: .green, sounds: "train"),
        Colors(name: "car.fill", colors: .pink, sounds: "mario-start")
    ]

    let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 16) {
                    if AudioManager.shared.isPlaying && isSliderVisible {
                        CustomSlider(value: $audioManager.currentTime, in: 0...audioManager.duration)
                            .frame(height: 4)
                    }
                    
                    LazyVGrid(columns: gridLayout, spacing: 16) {
                        ForEach(colors, id: \.id) { audio in
                            Button {
                                let isTrainSound = audio.sounds == "train"
                                AudioManager.shared.stopSound()
                                AudioManager.shared.playSound(named: audio.sounds, isTrainSound: isTrainSound)
                                isSliderVisible = true
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25)
                                        .foregroundColor(audio.colors)
                                        .shadow(radius: 10)
                                        .frame(width: 100, height: 100)
                                    
                                    Image(systemName: audio.name)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.white)
                                }
                                .padding()
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color("DarkGray"))
            .frame(height: geometry.size.height)
            .ignoresSafeArea()
        }
    }
}

struct CustomSlider: View {
    var value: Binding<TimeInterval>
    var `in`: ClosedRange<TimeInterval>

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color("DarkGray"))
                    .frame(height: 4)
                
                Rectangle()
                    .foregroundColor(Color("Green"))
                    .frame(width: CGFloat(value.wrappedValue / `in`.upperBound) * geometry.size.width, height: 4)
            }
            .gesture(DragGesture().onChanged { gesture in
                let newValue = TimeInterval(gesture.location.x / geometry.size.width) * `in`.upperBound
                self.value.wrappedValue = min(max(`in`.lowerBound, newValue), `in`.upperBound)
            })
        }
        .frame(height: 4)
    }
}

struct AudioView_Previews: PreviewProvider {
    static var previews: some View {
        AudioView()
    }
}
