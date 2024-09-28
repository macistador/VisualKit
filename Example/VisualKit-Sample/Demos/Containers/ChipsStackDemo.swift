//
//  ChipsStackDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 25/09/2024.
//

import SwiftUI
import VisualKit

struct ChipsStackDemo: View {
    
    struct Tag: Identifiable {
        let id = UUID()
        let name: String
    }
    
    @State var tags = [Tag(name: "Feudal System"), Tag(name: "Medieval Warfare"), Tag(name: "Castles"), Tag(name: "Daily"), Tag(name: "Health"), Tag(name: "Crusades"), Tag(name: "Royalty"), Tag(name: "Religious Influences"), Tag(name: "Literature"), Tag(name: "Regional")]
    @State var editMode = false
    @State var selectedtags = Set<UUID>()
    
    var body: some View {
        ChipsStack {
            ForEach(tags) { tag in
                TagView(name: tag.name,
                        backgroundColor: selectedtags.contains(tag.id) ? .blue : .clear,
                        textColor: selectedtags.contains(tag.id) ? .white : .blue,
                        deletable: $editMode)
                .onTapGesture {
                    if editMode {
                        tags.removeAll(where: { $0.id == tag.id })
                    } else {
                        if selectedtags.contains(tag.id) {
                            selectedtags.remove(tag.id)
                        } else {
                            selectedtags.insert(tag.id)
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle("ChipsStack")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editMode.toggle()
                } label: {
                    Text("Edit")
                }

            }
        }
    }
}

#Preview {
    ChipsStackDemo()
}
