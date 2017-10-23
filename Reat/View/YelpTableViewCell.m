//
//  YelpTableViewCell.m
//  Reat
//
//  Created by yujie cao on 10/15/17.
//  Copyright © 2017 yujie cao. All rights reserved.
//

#import "YelpTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "YelpDataModel.h"


@interface YelpTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@end

@implementation YelpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.restaurantImage.layer.cornerRadius = 5.0f;
    self.restaurantImage.layer.masksToBounds = YES;
}

- (void)updateBasedOnDataModel:(YelpDataModel *)dataModel
{
    self.restaurantName.text = dataModel.name;
    [self.restaurantImage setImageWithURL:[NSURL URLWithString:dataModel.imageUrl]];
    self.ratingImage.image = dataModel.ratingImage;
    self.reviewLabel.text = [NSString stringWithFormat:@"reviews %ld", dataModel.reviewCount];
    self.costLabel.text = dataModel.price;
    self.addressLabel.text = dataModel.displayAddress;
    self.category.text = dataModel.categories;
}



@end
