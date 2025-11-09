//
//  HomeView.swift
//  ScreenBreak
//
//  Created by Christian Pichardo on 3/7/23.
//

import SwiftUI
import SwiftUICharts
import RiveRuntime
import DeviceActivity

struct HomeView: View {
    
    @State private var homeContext: DeviceActivityReport.Context = .init(rawValue: "Home Report")
    @State private var filter = DeviceActivityFilter(
        segment: .daily(
            during: Calendar.current.dateInterval(
               of: .day, for: .now
            )!
        ),
        users: .all,
        devices: .init([.iPhone, .iPad])
    )
    @State private var message = ""
    
    @EnvironmentObject var model: MyModel
    let button = RiveViewModel(fileName: "button")
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Poppins-Bold", size: 40)!]

        }
    

    var body: some View {
        NavigationView {
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 16){
                    
                    // INPUT BAR
                    HStack(spacing: 12) {
                        TextField("Type something…", text: $message)
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )

                        Button {
                            // mic action here
                            print("mic tapped")
                        } label: {
                            Image(systemName: "mic.fill")
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                    }
                    
                    DeviceActivityReport(homeContext, filter: filter)
                    
                    Spacer()
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .navigationBarTitle("Home")
                .navigationBarItems(trailing: Image("appLogo")
                    .resizable()
                    .frame(width: 70.0, height: 70.0)
                    .padding(.top)
                    .padding(.top)
                    .padding(.top))
                
            }
        }
        .navigationViewStyle(.stack)
        
    }

}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
