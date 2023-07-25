//
//  UpshotCarouselPushCell.h
//  Upshot
//
//  Created by Vinod K on 11/20/20.
//  Copyright © 2020 [x]cube LABS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpshotCarouselPushCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (void)updateCell:(NSString *)imageUrl withIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
