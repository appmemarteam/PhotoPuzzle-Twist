import SwiftUI
import Photos

struct PhotoPickerView: View {
    @Binding var selectedAsset: PHAsset?
    @Environment(\.dismiss) var dismiss
    @State private var assets: [PHAsset] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(assets, id: \.localIdentifier) { asset in
                        AssetThumbnail(asset: asset)
                            .onTapGesture {
                                selectedAsset = asset
                                dismiss()
                            }
                    }
                }
            }
            .navigationTitle("Select Photo")
            .task {
                await fetchPhotos()
            }
        }
    }
    
    private func fetchPhotos() async {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        guard status == .authorized || status == .limited else { return }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var fetchedAssets: [PHAsset] = []
        result.enumerateObjects { asset, _, _ in
            fetchedAssets.append(asset)
        }
        self.assets = fetchedAssets
    }
}

struct AssetThumbnail: View {
    let asset: PHAsset
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
            } else {
                Color.gray.opacity(0.2)
                    .frame(width: 100, height: 100)
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options) { result, _ in
            self.image = result
        }
    }
}
