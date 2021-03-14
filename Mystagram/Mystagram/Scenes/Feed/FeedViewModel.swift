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
    let didTapProfileButton = PublishRelay<Void>()
}
