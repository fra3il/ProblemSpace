//
//  AssetGridViewController.h
//  ProblemSpace
//
//  Created by MinhaSeong on 2015. 2. 17..
//  Copyright (c) 2015년 nomad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AssetGridViewControllerDelegate;

@interface AssetGridViewController : UICollectionViewController

@property (weak, nonatomic) id <AssetGridViewControllerDelegate> eventDelegate;

@end

@protocol AssetGridViewControllerDelegate <NSObject>

- (void)didSaveAssets:(NSSet *)assets;

@end
