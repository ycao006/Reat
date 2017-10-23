//
//  YelpTableViewCell.h
//  Reat
//
//  Created by yujie cao on 10/15/17.
//  Copyright © 2017 yujie cao. All rights reserved.
//


#import <UIKit/UIKit.h>

@class YelpDataModel;

@interface YelpTableViewCell : UITableViewCell

- (void)updateBasedOnDataModel:(YelpDataModel *)dataModel;

@end
