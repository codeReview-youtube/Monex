//
//  RNSharedWidget.h
//  Monex
//
//  Created by Mustafa Alroomi on 01/03/2023.
//

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

@interface RNSharedWidget : NSObject<RCTBridgeModule>

@end
