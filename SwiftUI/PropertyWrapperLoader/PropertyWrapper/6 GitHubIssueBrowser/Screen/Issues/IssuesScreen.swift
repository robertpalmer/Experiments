//
//  Issues.swift
//  TimerWrapper
//
//  Created by Robert Palmer on 18.02.21.
//

import SwiftUI

struct IssuesScreen: View {
    
    @State var selection: String = "open"
    var body: some View {
        
        Picker("", selection: $selection) {
            Text("Open").tag("open")
            Text("Closed").tag("close")
        }
        .pickerStyle(SegmentedPickerStyle())
            
        Text("empty")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
 
    }
}

//struct Issues_Previews: PreviewProvider {
//    static var previews: some View {
//        Issues()
//    }
//}
