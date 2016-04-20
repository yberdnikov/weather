//
//  WFAForecastCollectionViewCell.m
//  weather
//
//  Created by Yuriy Berdnikov on 4/20/16.
//  Copyright © 2016 yberdnikov. All rights reserved.
//

#import "WFAForecastCollectionViewCell.h"

@interface WFAForecastCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *dayNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *weatherIconLabel;

@end

@implementation WFAForecastCollectionViewCell

+ (NSString *)cellReuseIdentifier
{
    return @"forecastCollectionViewCell";
}

+ (UINib *)cellNib
{
    return [UINib nibWithNibName:@"WFAForecastCollectionViewCell" bundle:nil];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.dayNameLabel.text = nil;
    self.temperatureLabel.text = nil;
    self.weatherIconLabel.text = nil;
}

- (void)setWeatherData:(SmileWeatherForecastDayData *)weatherData
{
    _weatherData = weatherData;
    if (!_weatherData)
        return;
    
    self.dayNameLabel.text = weatherData.dayOfWeek;
    self.weatherIconLabel.text = weatherData.icon;
    self.temperatureLabel.text = [NSString stringWithFormat:@"%ld°", (NSInteger)(weatherData.highTemperature.celsius + weatherData.lowTemperature.celsius) / 2];
}

@end
