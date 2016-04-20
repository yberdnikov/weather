//
//  WFARootViewController.m
//  weather
//
//  Created by Yuriy Berdnikov on 4/20/16.
//  Copyright © 2016 yberdnikov. All rights reserved.
//

#import "WFARootViewController.h"
#import <INTULocationManager.h>
#import <SmileWeatherDownLoader.h>
#import "WFAForecastCollectionViewCell.h"

@interface WFARootViewController ()

@property (strong, nonatomic) IBOutlet UICollectionView *forecastCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *currentWeatherIconLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentTemperatureLabel;

@property (nonatomic, strong) NSArray *forecastData;

@end

@implementation WFARootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.forecastCollectionView registerNib:[WFAForecastCollectionViewCell cellNib]
                  forCellWithReuseIdentifier:[WFAForecastCollectionViewCell cellReuseIdentifier]];
    
    __weak __typeof(self) weakSelf = self;
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                       timeout:10.0
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess)
                                             {
                                                 __typeof(weakSelf) strongSelf = weakSelf;
                                                 [[SmileWeatherDownLoader sharedDownloader] getWeatherDataFromLocation:currentLocation completion:^(SmileWeatherData * _Nullable data, NSError * _Nullable error) {
                                                     strongSelf.currentWeatherIconLabel.text = data.currentData.icon;
                                                     strongSelf.currentTemperatureLabel.text = [NSString stringWithFormat:@"%ld°", (NSInteger)data.currentData.currentTemperature.celsius];
                                                     strongSelf.forecastData = data.forecastData;
                                                     [strongSelf.forecastCollectionView reloadData];
                                                 }];
                                             }
                                             else if (status == INTULocationStatusTimedOut)
                                             {
                                                 // Wasn't able to locate the user with the requested accuracy within the timeout interval.
                                                 // However, currentLocation contains the best location available (if any) as of right now,
                                                 // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
                                             }
                                             else
                                             {
                                                 // An error occurred, more info is available by looking at the specific status returned.
                                             }
                                         }];
}

#pragma mark - UICollectionView m3thods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.forecastData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WFAForecastCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WFAForecastCollectionViewCell cellReuseIdentifier]
                                                                                    forIndexPath:indexPath];
    cell.weatherData = self.forecastData[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.bounds) / self.forecastData.count, 100);
}

#pragma mark - Location related

@end
