//
//  Utils.h
//  pearl
//
//  Created by svp on 04.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Utils : NSObject {
    
}

+ (BOOL) isNotNilAndNotNull:(id)obj;

+ (NSString *) getMD5:(NSString *)str;
+ (NSString *) trimString:(NSString *)str;
+ (BOOL) isNotNilAndNotEmptyString:(NSString *)str;

+ (BOOL) isValidEmail:(NSString *)emailStr;

+ (void) showErrors:(NSArray *)errors;
+ (void)showMessageWithTitle:(NSString *)title withMessage:(NSString *)message;
+ (void)showErrorWithMessage:(NSString *)message;

+ (void) saveHeaderValue:(id)value forKey:(NSString *)key;
+ (void) setHeadersData:(ASIHTTPRequest *)request;
+ (void) clearHeadersData;
+ (void) saveHeadersData:(NSMutableDictionary *)headerValues;

+ (void) showPreloaderOnView:(UIView *)view;
+ (void) removePreloaderFromView:(UIView *)view;

+ (id) getObjectFromUserDefaultsForKey:(NSString *)key;

+ (NSManagedObjectContext *)getContext;

+ (NSMutableArray *)getBasketItems;
+ (NSMutableDictionary *)getBasketItemsDicWithResponseCode:(NSString *)responseCode;
+ (NSMutableDictionary *)getBasketItemsWithCostValue;

+ (NSDate *) getDateFromString:(NSString *)dateStr withFormat:(NSString *)format;
+ (NSString *) getFormattedString:(NSDate *)date withFormat:(NSString *)dateFormat;
+ (NSString *) getMonthFromDateString:(NSString *)dateStr withDateFormat:(NSString *)dateFormat;
+ (NSString *)getMonthString;

+ (UIViewController *)getViewControllerFromPopOverController:(UIPopoverController *)popoverController;

+ (BOOL) validateEmail: (NSString *) candidate;

+ (BOOL) addTempValue:(NSString *)value withName:(NSString *)name;
+ (NSString *) getTempValueForName:(NSString *)name;

//+ (BOOL) addTempValue:(id)value withName:(NSString *)name;
//+ (id) getTempValueForName:(NSString *)name;


@end
