//
//  ContentView.swift
//  opiniaoplay
//
//  Created by Diego Moreira on 20/08/23.
//

import SwiftUI
import AVFoundation
import AVKit
import SafariServices

struct ContentView: View {
    @ObservedObject var configService = ConfigService.shared
    @ObservedObject var propagandasService = PropagandasService.shared
    @State private var isPlayingVideo = false
    @State private var isMenuOpen = false
    
    
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    
                    
                    VStack {
                        HStack {
                            Button(action: {
                                isMenuOpen.toggle()
                            }) {
                                Image(systemName: "line.horizontal.3")
                                    .font(.system(size: 30))
                                    .foregroundColor(Color.blue)
                            }
                            .padding(.leading, 16)
                            .padding(.top, 30)
                            .padding(.bottom, 20)
                            
                            Spacer()
                            
                            
                        }
                        
                        if let urlStream = configService.getConfig()?.urlStream {
                            VideoPlayer(player: AVPlayer(url: URL(string: urlStream)!))
                                .frame(height: 200)
                                .onAppear {
                                    if isPlayingVideo {
                                        playVideo()
                                    }
                                }
                        }
                        
                        NavigationLink(destination: ChatView()) {
                            Spacer() 
                            HStack {
                                Image(systemName: "message")
                                    .font(.system(size: 30))
                                    .foregroundColor(Color.blue)
                                Text("Interaja Conosco")
                                    .font(.headline)
                                    .foregroundColor(Color.blue)
                            }
                        }
                        .padding(.trailing, 16)
                        .padding(.top, 30)
                        .padding(.bottom, 20)
                        
                        // Seção de propagandas
                        PropagandasSection(propagandas: propagandasService.propagandas)
                    }
                    .offset(x: isMenuOpen ? geometry.size.width * 0.7 : 0)
                    .animation(.default)
                    
                    if isMenuOpen {
                        SideMenu()
                            .frame(width: geometry.size.width * 0.7)
                            .transition(.move(edge: .leading))
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            configService.fetchConfig { result in
                switch result {
                case .success(let config):
                    // Handle successful fetch
                    print("Config fetched: \(config)")
                case .failure(let error):
                    // Handle error
                    print("Error fetching config: \(error)")
                }
            }
            
            propagandasService.fetchPropagandas()
        }
    }
    
    private func playVideo() {
        isPlayingVideo = true
    }
    
    private func pauseVideo() {
        isPlayingVideo = false
    }
}

struct PropagandasSection: View {
    let propagandas: [Propaganda]

    var body: some View {
        VStack {
            ForEach(propagandas, id: \.id) { propaganda in
                Button(action: {
                    if let url = URL(string: propaganda.urlDestino) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    if let imageData = Data(base64Encoded: propaganda.imgBase64),
                       let uiImage = UIImage(data: imageData) {
                        
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100) // Altura da imagem
                            .clipShape(RoundedRectangle(cornerRadius: 10)) // Adiciona cantos arredondados
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1)) // Adiciona uma borda
                    }
                }
            }
        }
    }
}

struct SideMenu: View {
    var body: some View {
        List {
            Section(header: Text("Menu")) {
                NavigationLink(destination: ChatView()) {
                    Text("Home")
                }
                NavigationLink(destination: ChatView()) {
                    Text("Interaja Conosco")
                }
                NavigationLink(destination: ChatView()) {
                    Text("Veja e Reveja")
                }
                NavigationLink(destination: ChatView()) {
                    Text("Whatsapp")
                }
                NavigationLink(destination: ChatView()) {
                    Text("Facebook")
                }
                NavigationLink(destination: ChatView()) {
                    Text("Instagram")
                }
                NavigationLink(destination: ChatView()) {
                    Text("Contato")
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
