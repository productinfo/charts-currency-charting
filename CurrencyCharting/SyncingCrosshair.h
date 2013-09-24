//
//  SyncingCrosshair.h
//  CurrencyCharting
//
//  Created by Simon Withington on 09/09/2013.
//  Copyright (c) 2013 Simon Withington. All rights reserved.
//

@protocol SyncingCrosshairDelegate;

@interface SyncingCrosshair : SChartCrosshair

@property (assign, nonatomic) id<SyncingCrosshairDelegate> delegate;

@end
