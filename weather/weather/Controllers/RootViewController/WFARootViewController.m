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
#import <SVProgressHUD.h>
#import <UIAlertView+Blocks.h>

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
    
    [SVProgressHUD show];
    
    __weak __typeof(self) weakSelf = self;
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                       timeout:10.0
                          delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess)
                                             {
                                                 [weakSelf loadWeatherForLocation:currentLocation];
                                             }
                                             else
                                             {
                                                 [SVProgressHUD dismiss];
                                                 
                                                 __typeof(weakSelf) strongSelf = weakSelf;
                                                 [UIAlertView showWithTitle:NSLocalizedString(@"Error", nil)
                                                                    message:NSLocalizedString(@"Unable to determine your current location.\nDisplaying weather forecast for Lviv, Ukraine instead.", nil)
                                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                          otherButtonTitles:nil
                                                                   tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                                                                       [strongSelf loadWeatherForLocation:[[CLLocation alloc] initWithLatitude:49.8339835 longitude:24.0566832]];
                                                                   }];
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
    return CGSizeMake(CGRectGetWidth(collectionView.bounds) / self.forecastData.count,
                      CGRectGetHeight(collectionView.bounds));
}

#pragma mark - Location related

- (void)loadWeatherForLocation:(CLLocation *)currentLocation
{
    if (![SVProgressHUD isVisible])
        [SVProgressHUD show];
        
    __weak __typeof(self) weakSelf = self;
    [[SmileWeatherDownLoader sharedDownloader] getWeatherDataFromLocation:currentLocation completion:^(SmileWeatherData * _Nullable data, NSError * _Nullable error) {
        __typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.currentWeatherIconLabel.text = data.currentData.icon;
        strongSelf.currentTemperatureLabel.text = [NSString stringWithFormat:@"%ld°", (NSInteger)data.currentData.currentTemperature.celsius];
        strongSelf.forecastData = data.forecastData;
        [strongSelf.forecastCollectionView reloadData];
        
        [SVProgressHUD dismiss];
    }];
}

@end
