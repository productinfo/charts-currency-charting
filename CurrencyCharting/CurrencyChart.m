//
//  CurrencyChart.m
//  ShinobiCharts
//
//  Created by Simon Withington on 06/09/2013.
//
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
