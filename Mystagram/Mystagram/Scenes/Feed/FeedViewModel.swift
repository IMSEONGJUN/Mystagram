//
//  FeedViewModel.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/07.
//

import Foundation
import RxSwift
import RxCocoa

struct FeedViewModel: FeedViewModelBindable {
    let didTapProfileButton = PublishRelay<IndexPath?>()
//    let feeds: Driver<[Feed]>
    let feeds = [Feed]()
    
    init() {
//
//        didTapProfileButton
//            .map { feeds[$0?.item ?? 0].user }
    }
}
