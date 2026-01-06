//
//  Options.swift
//  PiggyBankUnited
//
//  Created by Magdaleno A Perez on 1/6/26.
//

import SwiftUI

struct OptionsView: View {
    let itemName: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
            
            Text(itemName)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        
    }
}

