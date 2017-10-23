//
//  YelpDataStore.h
//  Reat
//
//  Created by yujie cao on 10/21/17.
//  Copyright © 2017 yujie cao. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@class YelpDataModel;

@interface YelpDataStore : NSObject
@property (nonatomic, copy) NSArray <YelpDataModel *> *dataModels;
@property (nonatomic) CLLocation *userLocation;

+ (YelpDataStore *)sharedInstance;

@end

