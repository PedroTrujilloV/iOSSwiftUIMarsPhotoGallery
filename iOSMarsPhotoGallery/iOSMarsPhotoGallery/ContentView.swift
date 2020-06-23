//
//  ContentView.swift
//  iOSMarsPhotoGallery
//
//  Created by Pedro Trujillo on 6/22/20.
//  Copyright © 2020 Pedro Trujillo V. All rights reserved.
//
import Foundation
import SwiftUI
import Combine



extension EnvironmentValues {
    var imageCache:ImageCache {
        get {
            self[ImageCacheKey.self]
        }
        set {
            self[ImageCacheKey.self] = newValue
        }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

protocol ImageCache {
    subscript(_ url:URL) -> UIImage? {get set}
}

struct TemporaryImageCache:ImageCache {
    private let cache = NSCache<NSURL, UIImage>()

    subscript(url: URL) -> UIImage? {
        get {
            cache.object(forKey: url as NSURL)
        }
        set {
            newValue == nil ? cache.removeObject(forKey: url as NSURL) : cache.setObject(newValue!, forKey: url as NSURL)
        }
    }
}

struct AsyncImage<Placeholder:View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    
    init(url:URL, placeholder: Placeholder? = nil, cache: ImageCache? = nil) {
        self.loader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
    }
    private var image: some View {
        Group{
            if loader.image != nil {
                Image(uiImage: loader.image!)
                .resizable()
            }
            else {
                placeholder
            }
        }
    }
    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
}

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    private let url:URL
    private var cancelable:AnyCancellable?
    private var cache: ImageCache?
    
    init(url:URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancelable?.cancel()
    }
    
    func load() {
        
        if let image = cache?[url] {
            self.image = image
            return
        }
        
        cancelable = URLSession.shared.dataTaskPublisher(for: url)
            .map({
                UIImage(data:$0.data)
            })
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { (subscription) in
            }, receiveOutput: { [weak self] (image) in
                self?.cache(image)
            }, receiveCompletion: { (completion) in
            }, receiveCancel: {
            }, receiveRequest: { (demand) in
            })
            .receive(on:DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel(){
        cancelable?.cancel()
    }
    
    private func cache(_ image: UIImage?){
        image.map{cache?[url] = $0}
    }
    
}


struct ContentView: View {
    let url = URL(string: "http://mars.jpl.nasa.gov/msl-raw-images/msss/00001/mcam/0001ML0000001000I1_DXXX.jpg")!
    @Environment(\.imageCache) var cache: ImageCache
    @State var numberOfRows = 20
    @State var numberOfColumns = 3
    private var spacing:CGFloat = 5.0
    
    var body: some View {
        NavigationView {
            pinterestCollectionView.navigationBarItems(trailing: addButton)
        }
    }
    
    private var list: some View {
        List(0..<numberOfRows, id: \.self) {_ in
            AsyncImage(url: self.url,
                       placeholder: Text("Loading from MAVEN satelite..."),
                       cache: self.cache)
                .frame( minHeight: 100, idealHeight: 200, maxHeight: 300, alignment: .center)
                .aspectRatio(2/3, contentMode: .fit)
        }
    }
    
    private var pinterestCollectionView: some View {
        ScrollView(Axis.Set.vertical, showsIndicators: true) {
            HStack(alignment: VerticalAlignment.center, spacing: self.spacing) {
                ForEach(0..<self.numberOfColumns){_ in
                    VStack(alignment: HorizontalAlignment.center, spacing: self.spacing) {
                        ForEach(0..<self.numberOfRows){_ in
                            AsyncImage(url: self.url,
                                   placeholder: Text("Loading from MAVEN satelite..."),
                                   cache: self.cache)
                            .frame( minHeight: 100, idealHeight: 200, maxHeight: 300, alignment: .center)
                            .aspectRatio(2/3, contentMode: .fit)
                        }
                    }
                }
            }

        }
    }
    
    private var addButton: some View {
        Button(action: {
            self.numberOfRows += 1
        }) {
            return Image(systemName: "plus")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
