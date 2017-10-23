//
//  DetailViewHeaderTableViewCell.h
//  Reat
//
//  Created by yujie cao on 10/21/17.
//  Copyright © 2017 yujie cao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YelpDataModel;
@interface DetailViewHeaderTableViewCell : UITableViewCell

- (void)updateBasedOnDataModel:(YelpDataModel *)dataModel;

@end
