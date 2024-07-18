//
//  TRMCarouselCell.swift
//  TMDBRxMVVM
//
//  Created by GenZhang on 2024/7/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TRMCarouselCell : BaseTableViewCell {
    
    private var timerDisposable: Disposable?
    private var model: [TRMTrendingItem] = []
    
    deinit {
        timerDisposable?.disposed(by: disposeBag)
    }
    
    override func addSubviews() {
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
    }
    
    override func defineLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).offset(-10)
            make.centerX.equalTo(contentView)
        }
    }
    
    override func bindModel() {
        
        dataRelay.asDriverOnErrorJustComplete()
            .map { value -> [TRMTrendingItem] in
                if let model = value as? [TRMTrendingItem] {
                    return model
                } else {
                    return []
                }
            }
            .drive { [weak self] model in
                guard let self = self, model.count > 0 else { return }
                self.model = model
                self.pageControl.numberOfPages = model.count
                self.pageControl.currentPage = 0
                self.collectionView.reloadData()
                DispatchQueue.main.async {
                    self.collectionView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: false)
                }
                startCarousel()
            }
            .disposed(by: disposeBag)
    }
    
    private func startCarousel() {
        timerDisposable?.dispose()
        timerDisposable = Observable<Int>.interval(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, model.count > 0 else { return }
                self.collectionView .scrollToItem(at: IndexPath(item: Int(self.collectionView.contentOffset.x / screenWidth) + 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
            })
        timerDisposable?.disposed(by: disposeBag)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: screenWidth, height: ceil(screenWidth / 2 * 3))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TRMCarouselItemCell.self, forCellWithReuseIdentifier: TRMCarouselItemCell.reuseID)
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
}

extension TRMCarouselCell : UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
    }
    // MARK: 在这个代理写才能使手动和自动轮播的index都正常！
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x == 0) {
            scrollView.contentOffset = CGPoint(x: CGFloat(model.count) * screenWidth, y: 0)
            pageControl.currentPage = model.count
        } else if (scrollView.contentOffset.x == CGFloat(model.count + 1) * screenWidth) {
            scrollView.contentOffset = CGPoint(x: screenWidth, y: 0)
            pageControl.currentPage = 0
        } else {
            pageControl.currentPage = Int(scrollView.contentOffset.x / screenWidth) - 1
        }
    }
}

extension TRMCarouselCell : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension TRMCarouselCell : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if model.count <= 0 {
            return 0
        }
        return model.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TRMCarouselItemCell.reuseID, for: indexPath) as! TRMCarouselItemCell
        if (indexPath.row == 0) {
            cell.dataRelay.accept(model.last)
        } else if (indexPath.row == model.count+1) {
            cell.dataRelay.accept(model.first)
        } else {
            cell.dataRelay.accept(model[indexPath.row-1])
        }
        return cell
    }
}
