//
//  ThingModel.m
//  OneThing
//
//  Created by juphoon on 17/1/10.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "ThingModel.h"

@implementation ThingModel
+ (NSString *)primaryKey {
    return @"thingName";
}
- (void)saveToDataBase{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:self];
    }];
}
+ (RLMResults *)getAllThing{
    RLMResults * things = [ThingModel allObjects];
    return things;
}
+ (ThingModel *)getCurrentThing{
    RLMResults * things = [ThingModel allObjects];
    if (things.count) {
        ThingModel * currentModel = [things firstObject];
        return currentModel;
    }
    return nil;
}

+ (NSString *)getCurrentThingName{
    ThingModel * model = [self getCurrentThing];
    if (model) {
        return model.thingName;
    }
    return nil;
}

+(BOOL)shouldShowInputThing{
    ThingModel * first = [[self class] getCurrentThing];
    if (first) {
        NSDate * lastDate = first.createDate;
        return ![lastDate isThisWeek];
     }
    return  NO;
}
+(BOOL)isExitThisWeekThing{
    RLMResults * things = [ThingModel allObjects];
    for (ThingModel * subModel in things) {
        if ([subModel.createDate isThisWeek]) {
            return YES;
        }
    }
    return NO;
}


@end
