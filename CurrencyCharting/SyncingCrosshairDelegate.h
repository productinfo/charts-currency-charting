//
//  SyncingCrosshairDelegate.h
//  CurrencyCharting
//
//  Created by Simon Withington on 06/09/2013.
//  Copyright (c) 2013 Simon Withington. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SyncingCrosshairDelegate <NSObject>

@required

-(SChartDataPoint *)equivalentDataPointForDataPoint:(id<SChartData>)dataPoint inEquivalentSeries:(SChartCartesianSeries **)series;
-(SChartPoint)coordinatesForDataPoint:(SChartDataPoint *)dataPoint;

-(ShinobiChart *)chart;

@end
