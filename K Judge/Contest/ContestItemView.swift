//
//  ContestView.swift
//  K Judge
//
//  Created by young june Park on 2022/03/11.
//

import SwiftUI

struct ContestItemView: View {
    @Binding var challenge : Challenge
    @StateObject var contestItemViewModel = ContestItemViewModel()

    @State var tabIndex = 0
    
    var body: some View {
       // NavigationView{
            VStack{
                ContestItemCustomTopTabBar(tabIndex: $tabIndex)
                if tabIndex == 0 {
                    ProblemsView(challenge: $challenge)
                }
                else if tabIndex == 1 {
                    MySubmissionView(challenge: $challenge)
                }
                else if tabIndex == 2 {
                    ContestInfoView(challenge: $challenge)
                }
                else {
                   ContestInfoUpdateView(challenge: $challenge)
                }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width - 24, alignment: .center)
            .padding(.horizontal, 12)
            .navigationBarTitle("\(challenge.name)",displayMode:.inline)

        }
    //}
}

// status view
extension ContestItemView {
    var statusView : some View {
        
        Text("stausView")
        
    }
    
}




struct ContestItemCustomTopTabBar: View {
    @Binding var tabIndex: Int
    var body: some View {
        HStack(spacing: 20) {
            TabBarButton(text: "PROBLEMS", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
            TabBarButton(text: "SUBMISSION", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
            TabBarButton(text: "Info", isSelected: .constant(tabIndex == 2))
                .onTapGesture { onButtonTapped(index: 2) }
            TabBarButton(text: "Update", isSelected: .constant(tabIndex == 3))
                .onTapGesture { onButtonTapped(index: 3) }
//            TabBarButton(text: "STATUS", isSelected: .constant(tabIndex == 2))
//                .onTapGesture { onButtonTapped(index: 2) }
            Spacer()
        }
        .border(width: 1, edges: [.bottom], color: .black)
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct TabBarButton: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        Text(text)
            .fontWeight(isSelected ? .heavy : .regular)
            .font(.custom("Avenir", size: 16))
            .padding(.bottom,10)
            .border(width: isSelected ? 2 : 1, edges: [.bottom], color: .black)
    }
}

struct EdgeBorder: Shape {

    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
struct ContestItemView_Previews: PreviewProvider {
    static var previews: some View {
        ContestItemView(challenge:.constant(Challenge(id: 1, name: "challenge name", start_time: "start_time", end_time: "end_time", num_of_participation: 3, num_of_question: 3)))
    }
}


