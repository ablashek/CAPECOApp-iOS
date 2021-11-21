//
//  NavigationMenuView.swift
//  News
//
//  Created by Asil Arslan on 24.12.2020.
//

import SwiftUI

struct NavigationMenuView: View {
    
    @Binding var show : Bool
    @Binding var showPage : Bool
    @Binding var page : Page?
    @State var pages = [Page]()
    
    var body: some View{
        
        HStack{
            
            VStack(alignment: .leading, spacing: 12) {
                Spacer().frame(maxWidth: .infinity)
                Text("CAPECO")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                Divider()
                    .frame(width: 150, height: 1)
                    .background(Color.white)
                    .padding(.top, 10)
                
                ForEach(pages) { item in
                    Button(action: {
                        
                        self.page = item
                        withAnimation{
                            self.show.toggle()
                            self.showPage.toggle()
                        }
                    }) {
                        Text(item.title.rendered.decodingHTMLEntities())
                        .foregroundColor(Color.white)
                        .padding(.vertical, 10)
                        .background(Color.clear)
                        .cornerRadius(10)
                    }
                }
                
                Spacer(minLength: 0)
            }
            .padding(.top, 25)
            .padding(.horizontal, 20)
            .frame(maxHeight: .infinity)
            
            Spacer(minLength: 0)
        }
        .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
        .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .onAppear(){
            loadData()
        }
    }
    
    func loadData() {
        guard let url = URL(string: URL_PAGES) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Page].self, from: data) {
                    DispatchQueue.main.async {
                        self.pages = decodedResponse
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
        }.resume()
    }
}

struct NavigationMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationMenuView(show: .constant(false), showPage: .constant(false), page: .constant(nil))
    }
}
