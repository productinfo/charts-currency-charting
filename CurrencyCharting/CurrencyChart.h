//
//  CurrencyChart.h
//  ShinobiCharts
//
//  Created by Simon Withington on 06/09/2013.
//
//

#import <ShinobiCharts/ShinobiChart.h>
#import "SyncingCrosshairDelegate.h"

@interface CurrencyChart : ShinobiChart <SChartDatasource, SyncingCrosshairDelegate>

@property (strong, nonatomic) NSArray *data;

@end
