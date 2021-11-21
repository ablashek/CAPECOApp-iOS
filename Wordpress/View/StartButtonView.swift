//
//  StartButtonView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI

struct StartButtonView: View {
    
    @AppStorage("isOnboarding") var isOnboarding : Bool?
    
    var body: some View {
        Button(action: {
            isOnboarding = false
        }){
            HStack(spacing: 8) {
                Text("Iniciar")
                Image(systemName: "arrow.right.circle")
                    .imageScale(.large)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10 )
            .background(Capsule().strokeBorder(Color("ColorAccent"), lineWidth: 1.25))
        } //: Button
        .accentColor(Color("ColorAccent"))
    }
}

struct StartButtonView_Previews: PreviewProvider {
    static var previews: some View {
        StartButtonView().preferredColorScheme(.dark).previewLayout(.sizeThatFits )
    }
}

