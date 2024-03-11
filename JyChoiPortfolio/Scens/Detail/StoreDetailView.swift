//
//  StoreDetailView.swift
//  JyChoiPortfolio
//
//  Created by JuYoung choi on 3/7/24.
//

import SwiftUI
import Kingfisher
#if DEBUG
import CoreLocation
#endif

struct StoreInfoModel: Identifiable {
    
    let id: IconType
}

struct StoreDetailView: View {
    
    @Namespace var faqFirstItem
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var imgListHeight: CGFloat = 100
    @State var model: StoreModel
    @State var tapBtn = false
    @State var message = ""
    @State var selectType = IconType.useGuide
    @State var storeInfoDescription = ""
    
    @State var showFaq = false
    @State var viewWidth: CGFloat = 0
    
    @State var showShareView = false
    
    @State private var contentOffset = CGPoint.zero
    
    @State private var currentPageNo: Int = 1 {
        willSet(newValue) {
            
            print("offset : \(newValue)")
        }
    }
    
    var storeInfo: [StoreInfoModel] = [StoreInfoModel(id: .useGuide), StoreInfoModel(id: .parking), StoreInfoModel(id: .secureAndEnter), StoreInfoModel(id: .wifiInfo)]
    
    @ObservedObject var viewModel = DetailViewModel()
    
    init(_ model: StoreModel) {
        
        self.model = model
        self.viewModel.setData(model)
    }
    
    func getLocationTitle(_ text: String, geo: GeometryProxy) -> some View {
        Text(text).font(.spoqaRegular(fontSize: 16)).foregroundColor(.black).frame(width: geo.size.width / 5, alignment: .leading)
    }
    
    func getLocationText(_ title: String, description: String, geo: GeometryProxy) -> some View {
        HStack(alignment: .top) {
            self.getLocationTitle(title, geo: geo)
            Text(description).font(.spoqaRegular(fontSize: 16)).foregroundColor(.black)
            Spacer()
        }.padding(.horizontal, 10).padding(.top, 3)
    }
    
    func getSectionTitle(title: String) -> some View {
        VStack {
            Rectangle().fill(Color.lightGray).frame(height: 6).padding(.top, 5)
            HStack {
                
                Text(title).font(.title3).foregroundColor(.black)
                Spacer()
            }.padding(.horizontal, 10).padding(.top, 15)
        }
        
    }
    
    var body: some View {
        
        GeometryReader {geo in
            
            VStack(spacing: 0) {
                
                ScrollViewReader{ proxy in
                    ScrollView(.vertical) {
                        PagingScrollView(offset: self.$contentOffset, currentPageNo: self.$currentPageNo) {
                            
                            HStack(spacing: 0) {
                                ForEach(self.model.storeImgList) { thumbnailUrl in
                                    StoreImgView(thumbnailUrl.id, geo: geo, imgH: $imgListHeight)
                                }
                            }
                            
                        }.frame(height: self.imgListHeight).overlay(content: {
                            
                            VStack(alignment: .trailing) {
                                Spacer()
                                HStack(alignment: .bottom) {
                                    Spacer()
                                    Text("\(self.currentPageNo)/\(self.model.storeImgList.count)").font(.spoqaMedium(fontSize: 16)).foregroundColor(.white).background(Color.gray)
                                }.padding(.bottom, 10)
                            }.padding(.trailing, 10)
                        })
                        
                        HStack {
                            Text(self.model.metaData.title).font(.title2).padding(.leading, 10).padding(.top, 10)
                            Spacer()
                        }
                        
                        HStack {
                            
                            Text(self.model.address).font(.spoqaRegular(fontSize: 15)).foregroundColor(.gray).padding(.leading, 10).padding(.top, 10).onTapGesture {
                                
                                self.viewModel.setClipboard(self.model.address)
                            }
                            
                            Spacer()
                        }
                        
                        HStack(alignment: .center) {
                            
                            Spacer()
                            
                            Image(systemName: "square.and.arrow.up.circle")
                            Text("공유하기").font(.spoqaRegular(fontSize: 15)).foregroundColor(.gray).padding(.trailing, 10).onTapGesture {
                                
                                self.showShareView.toggle()
                            }
                        }.padding(.horizontal, 10).padding(.top, 2).sheet(isPresented: $showShareView, content: {
                            
                            ActivityView(text: self.viewModel.shareAddress)
                        })
                        
                        Rectangle().fill(Color.lightGray).frame(height: 6).padding(.top, 5)
                        
                        HStack {
                            
                            Text("지점 정보").font(.title3).foregroundColor(.black).padding(.trailing, 10).padding(.top, 10)
                            Spacer()
                        }.padding(.horizontal, 10).padding(.top, 5)
                        
                        Spacer()
                        
                        HStack {
                            ForEach(self.storeInfo) { type in
                                TopImgBottomTextView(buttonType: type.id, selectType: self.$selectType).frame(width: geo.size.width / 5).onTapGesture {
                                    
                                    self.selectType = type.id
                                    self.storeInfoDescription = self.viewModel.storeInfo(type.id)
                                }
                            }
                            
                            Spacer()
                        }.padding(.horizontal, 10)
                        
                        HStack {
                            Text(self.storeInfoDescription).font(.spoqaRegular(fontSize: 15)).foregroundColor(.gray)
                            
                            Spacer()
                        }.padding(.horizontal, 10)
                        
                        self.getSectionTitle(title: "유닛정보")
                        
                        KFImage(self.viewModel.model.storageInfo.imgUrl).frame(width: geo.size.width)
                        HStack {
                            Text(self.viewModel.model.storageInfo.description).font(.spoqaRegular(fontSize: 16)).foregroundColor(.black)
                            Spacer()
                        }.padding(.horizontal, 10).padding(.top, 10)
                        
                        self.getSectionTitle(title: "위치")
                        
                        CustomMapView(self.viewModel.model).frame(height: geo.size.width * 1).padding(.horizontal, 10)
                        
                        self.getLocationText("주소", description: self.viewModel.model.address, geo: geo)
                        
                        if self.viewModel.model.feature != "" {
                            self.getLocationText("특징", description: self.viewModel.model.feature, geo: geo)
                        }
                        
                        self.getLocationText("네비게이션", description: self.viewModel.model.navigationInfo, geo: geo)
                        self.getLocationText("지하철", description: self.viewModel.model.metroInfo, geo: geo)
                        self.getLocationText("버스", description: self.viewModel.model.busInfo, geo: geo)
                        
                        Rectangle().fill(Color.lightGray).frame(height: 6).padding(.top, 5)
                        HStack {
                            
                            Text("FAQ").font(.title3).foregroundColor(.black)
                            Spacer()
                            Image(systemName: "arrow.down").rotationEffect(showFaq ? .degrees(180) : .degrees(0))
                        }.padding(.horizontal, 10).padding(.vertical, 15).onTapGesture {
                            withAnimation {
                                
                                self.showFaq.toggle()
                                proxy.scrollTo(self.faqFirstItem, anchor: .bottom)
                            }
                            
                        }
                        
                        if self.showFaq {
                            
                            ForEach(self.viewModel.model.faqList) { model in
                                HStack(alignment: .top) {
                                    Text(model.id).font(.spoqaMedium(fontSize: 14)).foregroundColor(.gray)
                                    Spacer()
                                }.padding(.horizontal, 10).id(self.faqFirstItem)
                            }
                        }
                        
                    }
                }
                
                HStack(spacing: 0) {
                    
                    VStack {
                        Spacer()
                        Text("즉시방문").foregroundColor(.white)
                        Spacer()
                    }.frame(width: geo.size.width * 0.3).background(Color.blue).onTapGesture {
                        
                        self.message = "즉시방문"
                        self.tapBtn.toggle()
                    }
                    VStack {
                        Spacer()
                        Text("다락이용하기").foregroundColor(.white)
                        Spacer()
                    }.frame(width: geo.size.width * 0.7).background(Color.gray).onTapGesture {
                        
                        self.message = "다락이용하기"
                        self.tapBtn.toggle()
                    }
                }.frame(height: 40).alert(isPresented: $tapBtn, content: {
                    Alert(title: Text(""), message: Text(self.message), primaryButton: .default(Text("확인"), action: {
                        
                        print("\(self.message) 확인")
                    }), secondaryButton: .cancel(Text("취소"), action: {
                        
                        print("\(self.message) 취소")
                    }))
                })
                
            }.onAppear{
                
                self.storeInfoDescription = self.viewModel.storeInfo(self.selectType)
            }
        }.navigationBarBackButtonHidden(true).navigationTitle(self.model.metaData.title).toolbar(content: {
            
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label:  {
                    Image(systemName: "arrowshape.backward")
                    Text("뒤로가기").foregroundColor(.black)
                }
                
            })
        })
    }
}

#Preview {
    
    StoreDetailView(StoreModel(id: "0", storeImgList: [ImgElement(id: URL(string: "https://cdn.newsroad.co.kr/news/photo/202403/27876_39619_131.jpg")!), ImgElement(id:URL(string: "https://cdn.newsroad.co.kr/news/photo/202403/27855_39598_1410.jpg")!), ImgElement(id:URL(string: "https://cdn.newsroad.co.kr/news/photo/202402/27738_39450_5613.jpg")!) ], metaData: StorePointModel(id: "1", title: "올림픽 공원점", location: CLLocationCoordinate2D(latitude: 37.51545, longitude: 127.11487), thumbnailUrl: URL(string: "https://gongu.copyright.or.kr/gongu/wrt/cmmn/wrtFileImageView.do?wrtSn=13223550&filePath=L2Rpc2sxL25ld2RhdGEvMjAxOS8yMS9DTFMxMDAwNC8xMzIyMzU1MF9XUlRfMjAxOTExMjFfMQ==&thumbAt=Y&thumbSe=b_tbumb&wrtTy=10004")!), address: "서울 송파구 백제고분로 505 B1층", tagList: [TagModel<Bool>(title: "다락 직영", id: "d1", metaData: false), TagModel<Bool>(title: "24시간", id: "d2", metaData: true), TagModel<Bool>(title: "무료주차", id: "d3", metaData: true)], minimumPrice: 70560, distance: 1480))
}
