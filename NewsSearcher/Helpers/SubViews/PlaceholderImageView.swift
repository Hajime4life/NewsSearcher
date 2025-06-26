import SwiftUI

struct PlaceholderImageView {
    @ViewBuilder func Empty() -> some View {
        Rectangle()
            .frame(height: 150)
            .foregroundColor(.secondary)
            .opacity(0.5)
            .overlay {
                VStack {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .overlay{
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 50, height: 2)
                                .rotationEffect(Angle(degrees: -50))
                                .opacity(0.8)
                        }
                    Text("Без изображения") // TODO: Локализировать
                        .font(.callout)
                        
                }
                .opacity(0.6)
            }
    }
    
    @ViewBuilder func Loading() -> some View {
        Rectangle()
            .frame(height: 150)
            .foregroundColor(.secondary)
            .opacity(0.5)
            .overlay {
                ProgressView()
            }
    }
}
