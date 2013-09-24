//
//  AppDelegate.h
//  CurrencyCharting
//
//  Created by Simon Withington on 06/09/2013.
//  Copyright (c) 2013 Simon Withington. All rights reserved.
//

#import <UIKit/UIKit.h>

static int (*_old)(void *, const char *, int);

static int lawg(void *cookie, const char *d, int l) {
    return (!strncmp(d, "AssertMacros", 12))?
    0: (*_old)(cookie, d, l);
}

static void __attribute__((constructor)) _(void) {
    _old = stderr->_write;
    stderr->_write = lawg;
}

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
