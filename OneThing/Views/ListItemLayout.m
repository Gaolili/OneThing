 

#import "ListItemLayout.h"
#define  ACTIVE_DISTANCE 120

@implementation ListItemLayout

 
- (void)prepareLayout{
    [super prepareLayout];
    self.itemSize = CGSizeMake(ScreenWidth, ACTIVE_DISTANCE);
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionViewContentSize{
  return CGSizeMake(ScreenWidth, 50*ACTIVE_DISTANCE);
}

//-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    //1.计算scrollview最后停留的范围
//    CGRect lastRect ;
//    lastRect.origin = proposedContentOffset;
//    lastRect.size = self.collectionView.frame.size;
//    
//    
//    //2.取出这个范围内的所有属性
//    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
//    
//    //计算屏幕最中间的x
//    CGRect centerRect = CGRectMake(0, CGRectGetMidY(lastRect), ScreenWidth, ACTIVE_DISTANCE);
//    
//    //3.遍历所有的属性
//    CGFloat adjustOffsetY = MAXFLOAT;
//    for (UICollectionViewLayoutAttributes *attrs in array) {
//        if(CGRectIntersectsRect(centerRect, attrs.frame)){//取出最小值
//            adjustOffsetY = attrs.frame.origin.y - centerRect.origin.y;
//            NSLog(@"adjustOffsetY ===%f",adjustOffsetY);
//        }
//    }
//    
//    return CGPointMake(proposedContentOffset.x , proposedContentOffset.y + adjustOffsetY);
//}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height +2* ACTIVE_DISTANCE);//self.collectionView.bounds.size;
    
    //计算屏幕最中间的x
    CGFloat centerX = self.collectionView.contentOffset.y + self.collectionView.frame.size.height / 2 ;
    
    //2.遍历所有的布局属性
    for (UICollectionViewLayoutAttributes *attrs in array) {
        //不是可见范围的 就返回，不再屏幕就直接跳过
        if (!CGRectIntersectsRect(visibleRect, attrs.frame)) continue;
        
        //每一个item的中心x值
        CGFloat itemCenterx = attrs.center.y;
        //差距越小，缩放比例越大
        //根据与屏幕最中间的距离计算缩放比例
        
        CGFloat scale = (1 - ABS(itemCenterx - centerX) / ACTIVE_DISTANCE* 0.2);//比例值很随意，适合就好
        
//        NSLog(@"--scale:%f",scale);
        if (ABS(itemCenterx - centerX)<100) {
            //用这个，缩放不会改变frame大小，所以判断可见范围就无效，item即将离开可见范围的时候，突然消失不见
            attrs.transform3D = CATransform3DMakeScale(scale, scale, 1.0);
        }else{
            //用这个，缩放不会改变frame大小，所以判断可见范围就无效，item即将离开可见范围的时候，突然消失不见
            attrs.transform3D = CATransform3DMakeScale(0.52, 0.52, 1.0);

        }
        
    }
 
return array;
}


    

//
//    for (UICollectionViewLayoutAttributes* attributes in array) {
//        if (CGRectIntersectsRect(attributes.frame, rect)) {
//            CGFloat distance = CGRectGetMidY(visibleRect) - attributes.center.y;
//            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
//            
//            CGFloat zoom = 2 - ABS(normalizedDistance);
//
//            if (ABS(normalizedDistance)<=1) {
//                attributes.transform3D = CATransform3DMakeScale(ABS(zoom), ABS(zoom), 0.5);
//                attributes.zIndex = 1;
//            }else{
//                 CGFloat zoomWW =1 - zoom;
//                NSLog(@"zoomWW ==== %f",zoomWW);
//                if (zoomWW>3.6) {
//                    attributes.transform3D = CATransform3DMakeScale(ABS(zoomWW), ABS(zoomWW), 1);
//                    attributes.zIndex = 1;
//                }
//               
//            }
//
//        }
//    }


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
