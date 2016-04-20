//
//  WFAForecastCollectionViewCell.h
//  weather
//
//  Created by Yuriy Berdnikov on 4/20/16.
//  Copyright © 2016 yberdnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmileWeatherForecastDayData.h"

@interface WFAForecastCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) SmileWeatherForecastDayData *weatherData;

+ (NSString *)cellReuseIdentifier;
+ (UINib *)cellNib;

@end
