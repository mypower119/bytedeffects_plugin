//  Copyright © 2019 ailab. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BEFaceClusteringViewStatus){
    //  {zh} 展示选取的图片  {en} Show selected pictures
    BEFaceClusteringViewShowingImage,
    //  {zh} 展示聚类之后的结果  {en} Show the results after clustering
    BEFaceClusteringViewClusteringResult,
    //  {zh} 展示单项聚类  {en} Show monomial clustering
    BEFaceClusteringViewShowSingleCluster,
};

@protocol  BEFaceClusteringViewDelegate <NSObject>

-(void)faceClusteringDidSelectedOpenAlbum;
- (void)didStartCluster:(NSArray *)images;

@end

@interface BEFaceClusteringView : UIView
@property(nonatomic, assign) BEFaceClusteringViewStatus viewStatus;
@property (nonatomic, weak) id<BEFaceClusteringViewDelegate> delegate;

/** {zh} 
 设置选择的图片

 @param images 图片列表
 */
/** {en} 
 Set the selected picture

 @param images  picture list
 */
- (void) configuraClusteringWithImages:(NSArray <UIImage*>*)images;

/** {zh} 
 设置聚类结果

 @param result 一个可变字典
 */
/** {en} 
 Set the clustering result

 @param result  a variable dictionary
 */
- (void) configuraClusteringResult:(NSMutableDictionary<NSNumber*, NSMutableArray*>*) result;
@end

NS_ASSUME_NONNULL_END
