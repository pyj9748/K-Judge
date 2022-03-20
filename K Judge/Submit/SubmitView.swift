//
//  SubmitView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import SwiftUI

// View
struct SubmitView: View {
    
    
    @State var selected_option : Int = 0
    
    @StateObject var submitViewModel = SubmitViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                
                pickerView

                Text("Language : \(languages[self.selected_option])")
               
                CodeEditorView(source_code: self.$submitViewModel.submit.source_code, selected_option: self.$selected_option)
              
               // ProblemDescriptionView()
                
                
                Spacer()
            }.navigationBarTitle("Submit Problem",displayMode:.inline)
                .toolbar(content: {
                    submitBtn
                })
        }
        
    }
}

// 프로그래밍 언어 선택 picker view
extension SubmitView {
    var pickerView : some View {
        Picker(selection: $selected_option, label: Text("")) {
            ForEach(0..<languages.count, id: \.self) { index in
                Text(languages[index])
                
            }
            
        }.onChange(of: selected_option, perform: { _ in
            self.$submitViewModel.submit.source_code.wrappedValue = init_codes[selected_option]
        })
    }
}

// submit button
extension SubmitView {
    var submitBtn : some View {
       
        Button(action: {
            print("submitBtn")
            print(self.$selected_option.wrappedValue)
               
            // submit api 콜
            
        }, label: {
            HStack {
                    Image(systemName: "envelope")
                    .font(.body)
                    Text("Submit")
                        .fontWeight(.semibold)
                        .font(.body
                        )
                }
                .padding(6)
                .foregroundColor(.white)
                .background(Color("KWColor1"))
                .cornerRadius(40)
        })
    }
}

struct SubmitView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitView()
    }
}

