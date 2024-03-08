//
//  ContentView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/6/24.
//

import SwiftUI
import MapKit

struct ContentView: View {

    @ObservedObject var viewModel = MainViewModel()
    
    @State var showMap = false
    var listHeight: CGFloat = 0
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 127.10280, longitude: 37.51005), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    }
    var body: some View {
        
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                RoundTextField(round: 10, text: self.$viewModel.searchText, placeHolder: "insert text", edge: EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)).frame(height: 40)
            }.padding(.horizontal, 10)
            
            HStack(spacing: 0) {
                Text("\(self.viewModel.list.count)").foregroundStyle(.blue)
                Text("개의 다락 지점이 있습니다.").font(.spoqaRegular(fontSize: 15))
                Spacer()
            }.padding(10).onTapGesture {
                withAnimation {
                    
                    self.showMap = !self.showMap
                }
            }
            
            ZStack {
                CustomMapView(self.viewModel.list, self.viewModel.selectStoreModel).opacity(self.showMap ? 1 : 0)
                
                GeometryReader(content: { geometry in
                    
                    VStack(spacing: 0) {
                        
                        HStack(spacing: 0) {
                            Text("가까운 거리순").onTapGesture {
                                self.selectSorting(.distance)
                            }.foregroundColor(self.setSortingTextColor(self.viewModel.selectOption == .distance))
                            Text("낮은 가격순").padding(.leading, 10).onTapGesture {
                                self.selectSorting(.price)
                            }.foregroundColor(self.setSortingTextColor(self.viewModel.selectOption == .price))
                            Spacer()
                        }.padding(10).opacity(self.showMap ? 0 : 1)
                        
                        StoreList(listModels: self.$viewModel.list, refreshList: self.$viewModel.refreshList, selectModel: self.viewModel.selectStoreModel).padding(.top, self.showMap ? geometry.size.height : 10.0).opacity(self.showMap ? 0 : 1)
                    }
                })
            }
            
            NavigationLink(destination: StoreDetailView(self.viewModel.selectModel!), isActive: self.$viewModel.moveDetailView, label: {}).hidden()
            
            Spacer()
        }.onAppear {
            
//            UIScrollView.appearance().isPagingEnabled = false
        }
    }
    
    private func selectSorting(_ type: SortingType) {
        
        self.viewModel.selectOption = type
    }
    
    private func setSortingTextColor(_ selected: Bool) -> Color {
        
        selected ? .black : .gray
    }
}

#Preview {
    ContentView()
}
