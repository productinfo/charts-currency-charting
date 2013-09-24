//
//  AppDelegate.h
//  CurrencyCharting
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
