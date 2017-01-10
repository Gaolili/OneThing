//
//  ThingModel.h
//  OneThing
//
//  Created by juphoon on 17/1/10.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThingModel : RLMObject
@property (nonatomic,strong)NSString * thingName;
@property (nonatomic,strong)NSDate * createDate;
@property (nonatomic,strong)NSString * eventStoreIdentifier;

- (void)saveToDataBase;
+ (RLMResults *)getAllThing;
+ (ThingModel *)getCurrentThing;

+(BOOL)shouldShowInputThing;
+(BOOL)isExitThisWeekThing;

@end
