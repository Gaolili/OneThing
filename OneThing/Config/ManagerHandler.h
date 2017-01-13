//
//  ManagerHandler.h
//  OneThing
//
//  Created by juphoon on 17/1/10.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagerHandler : NSObject

+(BOOL)shouldPresentIntroVC ;
+(void)saveUserName:(NSString *)name;
+(NSString *)getUserName;
 

+(void)sendCheckFinishThingNotice;
+(void)sendAddThingNotice;
@end
