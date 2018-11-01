//
//  MYEmojiPageScrollView.swift
//  MY_Demo
//
//  Created by 马慧莹 on 2018/10/31.
//  Copyright © 2018 magic. All rights reserved.
//

import UIKit

class MYEmojiPageScrollView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    /// 自定义 flowlayout
    private var flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    /// ID
    private let cellID = "CollectionCellIdentifier"
    /// 位移开始位置
    private var startOffsetX : CGFloat = 0
    private(set) var isMoveing : Bool = false
    init(frame : CGRect) {
        flowLayout.itemSize = frame.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        self.data = Array<MYEmojiPageView>()
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        addInit()
        
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        flowLayout.itemSize = frame.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        self.data = Array<MYEmojiPageView>()
        super.init(frame: frame, collectionViewLayout: flowLayout)
        addInit()
    }
    
    // MARK: - 公开方法
    
    public var data : Array<MYEmojiPageView>  {
        didSet{
            moveFirstPage()
            reloadData()
        }
    }
    
    // MARK: - 私有方法
    
    private func addInit() {
        showsHorizontalScrollIndicator = false
        bounces = false
        isPagingEnabled = true
        delegate = self
        dataSource = self
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    private func moveFirstPage() {
        
        self.isMoveing = true
        scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        self.isMoveing = false
        startOffsetX = 0
    }
    
    // MARK: - collection代理
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        let child = data[indexPath.row]
        child.frame = cell.contentView.bounds
        cell.contentView.addSubview(child)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return frame.size
    }
    
    // MARK: - scrollView 代理
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isMoveing = true
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isMoveing {
            let currentOffsetX = scrollView.contentOffset.x
            let scrollView_W = scrollView.bounds.size.width
            let startIndex = Int(startOffsetX / scrollView_W)
            var endIndex : Int = 0
            var progress : CGFloat = 0
            if currentOffsetX > startOffsetX {//左滑left
                progress = (currentOffsetX - startOffsetX)/scrollView_W
                endIndex = startIndex + 1
                if endIndex > self.data.count - 1 {
                    endIndex = self.data.count - 1
                }
            }else if (currentOffsetX == startOffsetX){//没滑过去
                progress = 0
                endIndex = startIndex
            }else{//右滑right
                progress = (startOffsetX - currentOffsetX)/scrollView_W
                endIndex = startIndex - 1
                endIndex = endIndex < 0 ? 0 : endIndex
            }
            
            print("开始 \(startIndex)  结束 \(endIndex)  进度\(progress)")
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollView_W = scrollView.bounds.size.width
        let currentOffsetX = scrollView.contentOffset.x
        let startIndex = Int(startOffsetX/scrollView_W)
        let endIndex = Int((currentOffsetX/scrollView_W))
        
        print("\(startIndex) --->  \(endIndex)")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
