//
//  CodeEditorView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/12.
//

import SwiftUI

import SwiftUI

struct CodeEditorView: View {
    
    @Binding var source_code : String
    
    @Binding var selected_option : Int
    
    @State private var text:     String                = "My awesome code..."
    @State private var position: CodeEditor.Position  = CodeEditor.Position()
    @State private var messages: Set<Located<Message>> = Set()

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    var body: some View {
        
        
            CodeEditor(text: $source_code,
                       position: $position,
                       messages: $messages,
                       language: .swift)
              .environment(\.codeEditorTheme,
                           colorScheme == .dark ? Theme.defaultDark : Theme.defaultLight)
            
        
      
    }

    
  
}

struct CodeEditorView_Previews: PreviewProvider {
    static var previews: some View {
        CodeEditorView(source_code: .constant("""
    public static void main(String[] args) {
    
        System.out.println("Hello World");
    
    }
    """), selected_option: .constant(0))
    }
}
