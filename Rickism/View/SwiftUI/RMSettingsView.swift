//
//  RMSettingsView.swift
//  Rickism
//
//  Created by FAO on 12/09/23.
//

import SwiftUI

struct RMSettingsView: View {
    let viewModel: RMSettingsViewViewModel
    init(viewModel: RMSettingsViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.cellViewModels){  vm in
            HStack {
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Color(vm.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(vm.title)
                    .padding(.leading, 10)
                    .foregroundColor(Color(UIColor.label))
                Spacer()
            }.padding(.bottom, 3)
                .onTapGesture {
                    vm.onTapHandler(vm.type)
            }
        }
    }
}

struct RMSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0){otpion in
                
            }
        })))
    }
}
