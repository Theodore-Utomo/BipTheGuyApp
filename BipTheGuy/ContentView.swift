//
//  ContentView.swift
//  BipTheGuy
//
//  Created by Theodore Utomo on 9/22/24.
//

import SwiftUI
import AVFAudio
import PhotosUI

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateImage = true
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var bipImage = Image("clown")
    
    var body: some View {
        VStack {
            Spacer()
            bipImage
                .resizable()
                .scaledToFit()
                .scaleEffect(animateImage ? 1.0 : 0.9)
                .onTapGesture {
                    playSound(soundName: "punchSound")
                    animateImage = false
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.3)) {
                        animateImage = true
                    }
                }
            Spacer()
            PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
            }
            .onChange(of: selectedPhoto) {
                // Get data from PhotosPickerItem selectedPhoto
                // use data to create UIimage
                // use UIImage to create an Image
                // assign that image to bipImage
                Task {
                    do {
                        if let data = try await selectedPhoto?.loadTransferable(type: Data.self) { //loads raw data into the data variable
                            if let uiImage = UIImage(data: data) { // converts the data into a UIImage type
                                bipImage = Image(uiImage: uiImage) // Use UI image to convert it into an image
                            }
                        }
                    } catch {
                        print("😡 Error: loading failed \(error.localizedDescription)")
                    }
                }
            }
            
        }
        .padding()
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("ERROR: \(error.localizedDescription) creating audioPlayer.")
        }
    }
}

#Preview {
    ContentView()
}
