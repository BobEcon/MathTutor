//
//  ContentView.swift
//  MathTutor
//
//  Created by Robert Beachill on 06/03/2025.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var guessedNumber = ""
    @State private var firstNumText = ""
    @State private var secondNumText = ""
    @State private var answerText = ""
    @State private var playAgainSeen = false
    @State private var textFieldDisabled = false
    @State private var buttonDisabled = true
    @State private var audioPlayer: AVAudioPlayer!
    @FocusState private var textFieldIsFocused: Bool
    private let emojis = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"]
    
    
    var body: some View {
        VStack {
            VStack { // Prof uses Group{} but I prefer my way
                Text(firstNumText)
                Text("+")
                Text(secondNumText)
            }
            .font(.system(size: 80)).lineLimit(2)
            .minimumScaleFactor(0.5)
            .multilineTextAlignment(.center)
//            .border(Color.gray, width: 1)
            .frame(height: 300)
            
            
//            Spacer()
            
                Text("\(firstNumber) + \(secondNumber) = ")
                .font(.largeTitle)
         
           TextField("", text: $guessedNumber)
               .textFieldStyle(.roundedBorder)
               .frame(width: 50)
               .overlay {
                   RoundedRectangle(cornerRadius: 5)
                       .stroke(Color.gray, lineWidth: 1)
               }
               .font(.title)
               .multilineTextAlignment(.center)
               .keyboardType(.numberPad)
               .onChange(of: guessedNumber) {
                   guessedNumber = guessedNumber.trimmingCharacters(in: .letters).trimmingCharacters(in: .punctuationCharacters).trimmingCharacters(in: .symbols)
                   buttonDisabled = guessedNumber.isEmpty

               }
               .focused($textFieldIsFocused)
               .disabled(textFieldDisabled)
           
           Button("Guess") {
               //TODO:
               textFieldIsFocused = false
               checkAnswer()
               
           }
           .buttonStyle(.borderedProminent)
           .disabled(buttonDisabled)
           
            Spacer()
        
            if playAgainSeen {
                if answerText == "Correct!" {
                    Text(answerText)
                        .font(.largeTitle)
                        .foregroundStyle(.green)
                        .fontWeight(.heavy)
                } else {
                    Text(answerText)
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                }
                Button("Play Again?") {
                    //TODO:
                    guessedNumber = ""
                    playAgainSeen = false
                    textFieldDisabled = false
                    firstNumber = Int.random(in: 1...10)
                    secondNumber = Int.random(in: 1...10)
                    // Two different ways to choose a random element in the emojis array
                    firstNumText = String(repeating: emojis[Int.random(in: 0..<emojis.count)], count: firstNumber)
                    secondNumText = String(repeating: emojis.randomElement()!, count: secondNumber)
                }
            }
            
//            Spacer()
            
        }
        .padding()
        .onAppear() {
            firstNumber = Int.random(in: 1...10)
            secondNumber = Int.random(in: 1...10)
            firstNumText = String(repeating: emojis[Int.random(in: 0..<emojis.count)], count: firstNumber)
            secondNumText = String(repeating: emojis[Int.random(in: 0..<emojis.count)], count: secondNumber)
        }
        
    }
    
    func checkAnswer() {
        if Int(guessedNumber) == firstNumber + secondNumber {
            
            answerText = "Correct!"
            playSound(soundName: "correct")
            
        } else {
            answerText = "Sorry, the correct answer is \(firstNumber + secondNumber)"
            playSound(soundName: "wrong")
        }
//        guessedNumber = ""
        buttonDisabled = true
        playAgainSeen = true
        textFieldDisabled = true
    }
    
    func playSound(soundName: String) {
        if audioPlayer != nil && audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        guard let soundFile = NSDataAsset(name: soundName) else
        {
            print("😡 Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer =  try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print(" 😡 ERROR: \(error.localizedDescription) creating audioPlayer")
        }
    }
}

#Preview {
    ContentView()
}
