//
//  SyncingCrosshair.m
//  CurrencyCharting
//
//  Created by Simon Withington on 09/09/2013.
//  Copyright (c) 2013 Simon Withington. All rights reserved.
//

#import <ShinobiCharts/ShinobiChart.h>
#import <ShinobiCharts/SChartCanvas.h>
#import <ShinobiCharts/SChartCanvasOverlay.h>
#import "SyncingCrosshair.h"
#import "SyncingCrosshairDelegate.h"

#define notificationCrosshairMoved   @"CrosshairMoved"
#define notificationCrosshairRemoved @"CrosshairRemoved"
#define kSender @"Sender"
#define kDataPoint @"DataPoint"

@implementation SyncingCrosshair

-(instancetype)initWithChart:(ShinobiChart *)parentChart {
    
    if (self = [super initWithChart: parentChart]) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(didReceiveNotification:)
                                                     name: notificationCrosshairMoved
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(didReceiveNotification:)
                                                     name: notificationCrosshairRemoved
                                                   object: nil];
    }
    
    return self;
}

-(void)moveToPosition:(SChartPoint)coordinates
  andDisplayDataPoint:(SChartPoint)position
           fromSeries:(SChartCartesianSeries *)series
   andSeriesDataPoint:(id<SChartData>)dp {
    
    [super moveToPosition: coordinates
      andDisplayDataPoint: position
               fromSeries: series
       andSeriesDataPoint: dp];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: notificationCrosshairMoved
                                                        object: nil
                                                      userInfo: @{kDataPoint: dp, kSender: self}];
    
}

-(BOOL)removeCrosshair {
    
    [super removeCrosshair];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: notificationCrosshairRemoved
                                                        object: nil
                                                      userInfo: @{kSender: self}];
    return NO;
}

-(void)didReceiveNotification:(NSNotification *)notification  {
    
    if (notification.userInfo[kSender] != self) {
        
        if ([notification.name isEqualToString: notificationCrosshairMoved]) {
            
            [self moveToPositionForDataPoint: notification.userInfo[kDataPoint]];
            
        } else if ([notification.name isEqualToString: notificationCrosshairRemoved]) {
            
            [self remove];
            
        }
    }
}

-(void)moveToPositionForDataPoint:(id<SChartData>)dataPoint {
    
    SChartCartesianSeries *series = nil;
    
    SChartDataPoint *dp = [self.delegate equivalentDataPointForDataPoint: dataPoint
                                                      inEquivalentSeries: &series];
    
    SChartPoint coordinates = [self.delegate coordinatesForDataPoint: dp];
    
    SChartPoint position;
    position.x = [dp.xValue timeIntervalSince1970];
    position.y = [dp.yValue doubleValue];
    
    [self showCrosshair];
    self.trackingSeries = series;
    
    [self crosshairMovedInsideRange];
    
    [super moveToPosition: coordinates
      andDisplayDataPoint: position
               fromSeries: series
       andSeriesDataPoint: dp];
}

-(void)remove {
    [super removeCrosshair];
}

@end
