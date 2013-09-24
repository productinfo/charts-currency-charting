//
//  CurrencyChart.m
//  ShinobiCharts
//
//  Created by Simon Withington on 06/09/2013.
//  Copyright 2013 Scott Logic Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "CurrencyChart.h"
#import "SyncingCrosshair.h"
#import <ShinobiCharts/SChartCanvas.h>

@implementation CurrencyChart

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self=[super initWithCoder: aDecoder]) {
        
        self.xAxis = [SChartDateTimeAxis new];
        self.yAxis = [SChartNumberAxis new];
        
        self.xAxis.enableGestureZooming =
        self.xAxis.enableGesturePanning = YES;
        
        self.datasource = self;

        SyncingCrosshair *syncingCrosshair = [[SyncingCrosshair alloc] initWithChart: self];
        syncingCrosshair.delegate = self;
        
        self.crosshair = syncingCrosshair;
        self.crosshair.interpolatePoints = NO;
    }
    
    return self;
}

-(SChartDataPoint *)equivalentDataPointForDataPoint:(id<SChartData>)dataPoint inEquivalentSeries:(SChartCartesianSeries **)series {
    
    *series = [self series][0];
    
    return [self sChart: self
       dataPointAtIndex: [dataPoint sChartDataPointIndex]
       forSeriesAtIndex: 0];
}

-(SChartPoint)coordinatesForDataPoint:(SChartDataPoint *)dataPoint {
    
    double xVal = [dataPoint.xValue timeIntervalSince1970] + [[self.xAxis offsetForSeries: self.series[0]] doubleValue];
    double yVal = [dataPoint.yValue doubleValue]           + [[self.yAxis offsetForSeries: self.series[0]] doubleValue];
    
    double mappedX = self.canvas.glView.frame.origin.x + [self.xAxis pixelValueForDataValue: @(xVal)];
    double mappedY = self.canvas.glView.frame.origin.y + [self.yAxis pixelValueForDataValue: @(yVal)];
    
    return (SChartPoint){mappedX, mappedY};
}

-(ShinobiChart *)chart {
    return self;
}

-(int)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(int)index {
    
    SChartLineSeries *lineSeries = [SChartLineSeries new];
    lineSeries.crosshairEnabled = YES;
    return lineSeries;
}

-(int)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(int)seriesIndex {
    return [self.data count];
}

-(id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(int)dataIndex forSeriesAtIndex:(int)seriesIndex {
    
    SChartDataPoint *dp = [SChartDataPoint new];
    
    dp.xValue = [NSDate dateWithTimeInterval: 86400*dataIndex sinceDate:[NSDate dateWithTimeIntervalSince1970: 1362571200]];
    dp.yValue = self.data[dataIndex];
    
    return dp;
}

@end
