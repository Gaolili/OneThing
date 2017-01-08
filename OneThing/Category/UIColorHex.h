 

#import <Foundation/Foundation.h>

@interface UIColor (ColorFromHex)

+ (instancetype)getColor:(NSString *)hexColor;
+ (instancetype)getColor:(NSString *)hexColor andAlpha:(CGFloat)alpha;
 @end
