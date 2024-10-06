//
//  FancyEffectDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 04/10/2024.
//

import SwiftUI
import VisualKit

struct FancyEffectDemo: View {
    
    @State var effectTrigger: Bool = false
    @State var effectTrigger2: Bool = false
    @State var effectTrigger3: Bool = false
    @State var speedMultiplier: Double = 1
    @State var effectRepeat: EffectRepeat = .none
    @State var repeatCount: Double = 3
    @State var pauseDuration: Double = 0
    @State var pauseEvery: Double = 3

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Button {
                effectTrigger.toggle()
            } label: {
                ZStack {
                    Capsule()
                        .fill(.red)
                        .frame(width: 200, height: 50)
                    Text("Shake")
                        .foregroundStyle(.white)
                        .bold()
                }
            }
            .fancyEffect(trigger: $effectTrigger, effect: .shake(), speedMultiplier: speedMultiplier, repeatEffect: effectRepeat)
            
            Button {
                effectTrigger2.toggle()
            } label: {
                ZStack {
                    Capsule()
                        .fill(.red)
                        .frame(width: 200, height: 50)
                    Text("Bounce simple")
                        .foregroundStyle(.white)
                        .bold()
                }
            }
            .fancyEffect(trigger: $effectTrigger2, effect: .bounce(asymmetric: false), speedMultiplier: speedMultiplier, repeatEffect: effectRepeat)
            
            Button {
                effectTrigger3.toggle()
            } label: {
                ZStack {
                    Capsule()
                        .fill(.red)
                        .frame(width: 200, height: 50)
                    Text("Bounce asymmetric")
                        .foregroundStyle(.white)
                        .bold()
                }
            }
            .fancyEffect(trigger: $effectTrigger3, effect: .bounce(asymmetric: true), speedMultiplier: speedMultiplier, repeatEffect: effectRepeat)
                        
            HStack {
                Text("Speed multiplier")
                Spacer()
                Slider(value: $speedMultiplier, in: 0.0...10.0, step: 0.1)
                Text(String(format: "%.1f", speedMultiplier))
                    .frame(width: 25)
            }
            
            Picker("Repetition", selection: $effectRepeat) {
                ForEach([EffectRepeat.none, EffectRepeat.count(Int(repeatCount)), EffectRepeat.forever(pause: pauseDuration, pauseEvery: Int(pauseEvery))], id: \.self) {
                    Text($0.name)
                }
            }
            .pickerStyle(.segmented)
            .padding(.vertical)
            
            if effectRepeat.isRepeating {
                if case .count = effectRepeat {
                    HStack {
                        Text("Repeat count")
                        Spacer()
                        Slider(value: $repeatCount, in: (1...10.0), step: 1)
                        Text("\(Int(repeatCount))")
                            .frame(width: 25)
                    }
                }

                HStack {
                    Text("Pause duration")
                    Spacer()
                    Slider(value: $pauseDuration, in: (0...10.0), step: 1)
                    Text("\(Int(pauseDuration))")
                        .frame(width: 25)
                }
                
                HStack {
                    Text("Pause every")
                    Spacer()
                    Slider(value: $pauseEvery, in: (1...10.0), step: 1)
                    Text("\(Int(pauseEvery))")
                        .frame(width: 25)
                }
            }
                        
            Spacer()
        }
        .padding()
        .navigationTitle("FancyEffect")
    }
}

#Preview {
    FancyEffectDemo()
}

extension EffectRepeat: @retroactive Identifiable, @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: EffectRepeat, rhs: EffectRepeat) -> Bool {
        lhs.id == rhs.id
    }
    
    public var id: String {
        switch self {
        case .none: "0"
        case .count(let count, let pause, let pauseEvery):
            "1-\(count)-\(pause)-\(pauseEvery)"
        case .forever(let pause, let pauseEvery):
            "2-\(pause)-\(pauseEvery)"
        }
    }
    
    var name: String {
        switch self {
        case .none: "None"
        case .count: "Count"
        case .forever: "Forever"
        }
    }
    
    var isRepeating: Bool {
        switch self {
        case .none: false
        default: true
        }
    }
}
