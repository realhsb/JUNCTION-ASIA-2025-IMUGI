//
//  CustomMapContents.swift
//  FireBug
//
//  Created by 이승진 on 8/24/25.
//

import SwiftUI

struct CustomMapContents: View {
    
    @Bindable var locationManger =  LocationManager.shared
    
    var body: some View {
        CustomMap(locationManager: locationManger)
    }
}

#Preview {
    CustomMapContents()
}
