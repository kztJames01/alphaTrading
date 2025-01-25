//
//  TickerListRowView.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/20/25.
//

import SwiftUI

struct TickerListRowView: View {
    
    let data: TickerListRowData
    
    var body: some View {
        HStack(alignment: .center, content:{
            if case let .search(isSaved, onButtonTapped) = data.type{
                Button{
                    onButtonTapped()
                } label: {
                    image(isSaved: isSaved)
                }
            }
            
            VStack(alignment: .leading, spacing:8) {
                Text(data.symbol ?? "AAPL").font(.headline.bold())
                if let name = data.name {
                    Text(name)
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                }
            }
            
            Spacer()
            if let (price, change) = data.price {
                VStack(alignment: .trailing, spacing: 8) {
                    Text(price)
                    priceChangeView(text: change)
                }.font(.headline.bold())
            }
        })
    }
    
    @ViewBuilder
    func image(isSaved: Bool)-> some View{
        if isSaved{
            Image(systemName: "checkmark.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.white, Color.accentColor)
                .imageScale(.large)
        } else{
            Image(systemName: "plus.circle.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.accentColor, Color.secondary.opacity(0.3))
                .imageScale(.large)
        }
    }
    
    @ViewBuilder
    func priceChangeView(text:String) -> some View{
        if case .main = data.type{
            ZStack(alignment: .trailing){
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(text.hasPrefix("-") ? .red : .green)
                    .frame(height: 24)
                
                Text(text)
                    .foregroundColor(.white)
                    .font(.caption.bold())
                    .padding(.horizontal,8)
            }.fixedSize()
        }else{
            Text(text)
                .foregroundColor(text.hasPrefix("-") ? .red : .green)
        }
    }
}

struct TickerListRowView_Previews: PreviewProvider{
    
    static var previews: some View{
        VStack(alignment: .leading){
            Text("Main List").font(.largeTitle.bold()).padding()
            VStack{
                TickerListRowView(data: appleTickerListRowData(rowType: .main))
                Divider()
                TickerListRowView(data: teslaTickerListRowData(rowType: .main))
            }.padding()
            Text("Search List").font(.largeTitle.bold()).padding()
            VStack{
                TickerListRowView(data: appleTickerListRowData(rowType: .search(isSaved: true, onButtonTapped: {})))
                Divider()
                TickerListRowView(data: teslaTickerListRowData(rowType: .search(isSaved: false, onButtonTapped: {})))
            }.padding()
        }.previewLayout(.sizeThatFits)
    }
    
    static func appleTickerListRowData(rowType: TickerListRowData.RowType) -> TickerListRowData{
        .init(symbol: "AAPL", name: "Apple Inc.", price: ("100", "+0.7"), type: rowType)
    }
    
    static func teslaTickerListRowData(rowType: TickerListRowData.RowType) -> TickerListRowData{
        .init(symbol: "TSLA", name: "Tesla", price: ("250", "+0.9"), type: rowType)
    }
}


