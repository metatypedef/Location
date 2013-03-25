//
//  Utils.m
//  pearl
//
//  Created by svp on 04.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>
#import "Basket.h"

@implementation Utils


+ (BOOL)isNotNilAndNotNull:(id)obj {
    return obj && ![obj isEqual:[NSNull null]];
}

+ (BOOL)isNotNilAndNotEmptyString:(NSString *)str {
    NSCharacterSet * set= [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return str && ![str isEqual:[NSNull null]] && ![[str stringByTrimmingCharactersInSet:set] isEqualToString:@""];
}

+ (NSString *)trimString:(NSString *)str {
    NSCharacterSet * set= [NSCharacterSet whitespaceCharacterSet];
    return [str stringByTrimmingCharactersInSet:set];
}

+ (NSString *)getMD5:(NSString *)str {
    // Create pointer to the string as UTF8
    const char *ptr = [str UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",md5Buffer[i]];
    }
    
    return output;  
}

+ (BOOL)isValidEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:emailStr];
}

+ (void) showErrors:(NSArray *)errors {
    if (errors && errors.count > 0) {
        NSMutableString * errorsStr = [[NSMutableString alloc] init];
        BOOL isFirst = YES;
        for (int i = 0; i < errors.count; i++) {
            NSDictionary * dic = [errors objectAtIndex:i];
            NSString * message = [dic objectForKey:@"message"];
            if ([Utils isNotNilAndNotEmptyString:message]) {
                if (isFirst) {
                    [errorsStr appendString:message];
                    isFirst = NO;
                } else {
                    [errorsStr appendFormat:@"\n%@", message];
                }
            }
        }
        [self showMessageWithTitle:erERROR withMessage:errorsStr];
        [errorsStr release];
    }
}

+ (void)showMessageWithTitle:(NSString *)title withMessage:(NSString *)message {	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	UIAlertView *baseAlert = [[UIAlertView alloc] 
							  initWithTitle:title message:message
							  delegate:self cancelButtonTitle:nil
							  otherButtonTitles:@"OK", nil];
	
	[baseAlert show];
	[baseAlert release];
}

+ (void)showErrorWithMessage:(NSString *)message {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	UIAlertView *baseAlert = [[UIAlertView alloc] 
							  initWithTitle:@"Error" message:message
							  delegate:self cancelButtonTitle:nil
							  otherButtonTitles:@"OK", nil];
	
	[baseAlert show];
	[baseAlert release];
}

+ (void)clearHeadersData {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:CUSTOMER_ID];
    [userDefaults removeObjectForKey:CUSTOMER_PASSWORD];
    [userDefaults removeObjectForKey:CUSTOMER_PASSWORD];
    [userDefaults removeObjectForKey:LOZ];
    //[userDefaults removeObjectForKey:SESSION_ID];
    
}

+ (void) saveHeaderValue:(id)value forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

+ (void)setHeadersData:(ASIHTTPRequest *)request {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * headerValue = [userDefaults objectForKey:CUSTOMER_ID];
    if ([Utils isNotNilAndNotNull:headerValue]) {
        [request addRequestHeader:CUSTOMER_ID value:headerValue];
    }

    headerValue = [userDefaults objectForKey:CUSTOMER_EMAIL];
    if ([Utils isNotNilAndNotNull:headerValue]) {
        [request addRequestHeader:CUSTOMER_EMAIL value:headerValue];
    }
    
    headerValue = [userDefaults objectForKey:CUSTOMER_PASSWORD];
    if ([Utils isNotNilAndNotNull:headerValue]) {
        [request addRequestHeader:CUSTOMER_PASSWORD value:headerValue];
    }
    
    headerValue = [userDefaults objectForKey:LOZ];//TODO to testing LOZ = 0;
    if ([Utils isNotNilAndNotNull:headerValue]) {
        [request addRequestHeader:LOZ value:headerValue];
    } else {
        [request addRequestHeader:LOZ value:@"0"];
    }
    [request addRequestHeader:@"Production" value:PRODUCTION_MODE];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    headerValue = [userDefaults objectForKey:SESSION_ID];
    if ([Utils isNotNilAndNotNull:headerValue]) {
        [request addRequestHeader:SESSION_ID value:headerValue];
    }
    
}

+ (void)saveHeadersData:(NSMutableDictionary *)headerValues {
    [self clearHeadersData];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[headerValues objectForKey:CUSTOMER_ID] forKey:CUSTOMER_ID];
    [userDefaults setObject:[headerValues objectForKey:CUSTOMER_EMAIL] forKey:CUSTOMER_EMAIL];
    [userDefaults setObject:[headerValues objectForKey:CUSTOMER_PASSWORD] forKey:CUSTOMER_PASSWORD];
    [userDefaults setObject:[headerValues objectForKey:LOZ] forKey:LOZ];
    //[userDefaults setObject:[headerValues objectForKey:SESSION_ID] forKey:SESSION_ID];
    [userDefaults synchronize];       
}

+ (void)showPreloaderOnView:(UIView *)view {
    UIView * transparentView = [[UIView alloc] initWithFrame:view.bounds];
    //transparentView.backgroundColor = [UIColor grayColor];
    //transparentView.alpha = 0.4;
    transparentView.tag = kPRELOADER_TAG;
    
    UIView * preloaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 200, 60)];
	preloaderView.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.8];
	preloaderView.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
	//preloaderView.alpha = 0.0;
    //preloaderView.tag = kPRELOADER_TAG;
    preloaderView.clipsToBounds = YES;
	if ([preloaderView.layer respondsToSelector:@selector(setCornerRadius:)]) 
        [preloaderView.layer setCornerRadius: 10];
	
	UILabel	*label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, preloaderView.bounds.size.width, 18)];
	label.text = TRANSLATE(@"Loading");
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont boldSystemFontOfSize: 15];
	[preloaderView addSubview: label];
    [label release];
	
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	//spinner.tag = kPRELOADER_TAG;
	spinner.center = CGPointMake(preloaderView.bounds.size.width / 2, preloaderView.bounds.size.height / 2+10);
    //spinner.backgroundColor = [UIColor redColor];
    //  spinner.center = CGPointMake(10,10);
	[preloaderView addSubview: spinner];
    [spinner startAnimating];
    [transparentView addSubview:preloaderView];
	[view addSubview: transparentView];
    [spinner release];
    [transparentView release];
    [preloaderView release];
    
}

+ (void)removePreloaderFromView:(UIView *)view {
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration:0.5];
    [[view viewWithTag:kPRELOADER_TAG] setAlpha:0.0];
	[UIView commitAnimations];
    [[view viewWithTag:kPRELOADER_TAG] removeFromSuperview];    
}

+ (id)getObjectFromUserDefaultsForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


+ (NSManagedObjectContext *)getContext {
    NSManagedObjectContext * managedObjectContext = nil;
    NSError *error = nil;
    
    NSString * applicationDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL * storeUrl = [NSURL fileURLWithPath: [applicationDocumentsDirectory stringByAppendingPathComponent: @"PEARL.sqlite"]];

    NSManagedObjectModel * managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
    NSPersistentStoreCoordinator * persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                                                 initWithManagedObjectModel:managedObjectModel];
    
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    if (persistentStoreCoordinator) {
        managedObjectContext = [[[NSManagedObjectContext alloc] init] autorelease];
        [managedObjectContext setPersistentStoreCoordinator: persistentStoreCoordinator];
        [persistentStoreCoordinator release];
    }
    
    return managedObjectContext;
}

+ (NSMutableArray *)getBasketItems {
    NSManagedObjectContext * context = [self getContext];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"Basket" inManagedObjectContext:context];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError * error = nil;
    NSArray * allTovars = [context executeFetchRequest:request error:&error];
    [request release];
    NSMutableArray * items = [NSMutableArray array];
    if (allTovars && allTovars.count > 0) {
        for (int i = 0; i < allTovars.count; i ++) {
            Basket * basket = (Basket *)[allTovars objectAtIndex:i];
            if (basket) {
                NSString * price = ([Utils isNotNilAndNotEmptyString:basket.price]) ? [basket.price stringByReplacingOccurrencesOfString:@"," withString:@"."] : @"0";
                basket.price = price;                
                [items addObject:basket];
               
            }
        }
    }
    return items;
}

+ (NSMutableDictionary *)getBasketItemsDicWithResponseCode:(NSString *)responseCode {
    NSMutableDictionary * resultDic = [NSMutableDictionary dictionary];
    NSManagedObjectContext * context = [self getContext];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"Basket" inManagedObjectContext:context];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];

    NSError * error = nil;
    NSArray * allTovars = [context executeFetchRequest:request error:&error];
    NSMutableArray * items = [[NSMutableArray alloc] init];
    if (allTovars && allTovars.count > 0) {
        for (int i = 0; i < allTovars.count; i ++) {
            Basket * basket = (Basket *)[allTovars objectAtIndex:i];
            if (basket) {
                NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
                [dic setObject:basket.idT forKey:@"pdId"];
                [dic setObject:basket.qaunt forKey:@"quantity"];
                [dic setObject:[self isNotNilAndNotEmptyString:responseCode] ? responseCode : @"" forKey:@"response"];
                [dic setObject:@"" forKey:@"couponCode"];

                [items addObject:dic];
                [dic release];
            }
        }
        //[resultDic setObject:items forKey:@"items"];
    }
    [resultDic setObject:[NSMutableDictionary dictionaryWithObject:items forKey:@"items"] forKey:@"order"];
    [request release];
    [items release];
    return resultDic;
}

+ (NSMutableDictionary *)getBasketItemsWithCostValue {
    NSManagedObjectContext * context = [Utils getContext];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"Basket" inManagedObjectContext:context];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError * error = nil;
    NSArray * allTovars = [context executeFetchRequest:request error:&error];
    CGFloat summary = 0;
    NSMutableArray * _basketItems = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [allTovars count]; i++) {
        Basket * item = (Basket *)[allTovars objectAtIndex:i];
        NSString *_s_price = [item.price stringByReplacingOccurrencesOfString:@"," withString:@"."];
        summary += [item.qaunt intValue] * [_s_price doubleValue];
        [_basketItems addObject:item];
    }
    
    NSString *total_sum = [NSString stringWithFormat:@"€ %.2f",summary];
    total_sum =[total_sum stringByReplacingOccurrencesOfString:@"." withString:@","];
    
    NSMutableDictionary * resultDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       total_sum, @"cost",  
                                       _basketItems, @"items", nil];
    
    [_basketItems release];
    [request release];
    return resultDic;
}

+ (NSDate *)getDateFromString:(NSString *)dateStr withFormat:(NSString *)format {
    if ([self isNotNilAndNotEmptyString:dateStr] && [self isNotNilAndNotEmptyString:format]) {
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        NSDate * date = [formatter dateFromString:dateStr];
        [formatter release];
        return date;
    } 
    return nil;
}

+ (NSString *)getFormattedString:(NSDate *)date withFormat:(NSString *)dateFormat {
    if ([self isNotNilAndNotNull:date] && [self isNotNilAndNotEmptyString:dateFormat]) {
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:dateFormat];
        NSString * dateStr = [formatter stringFromDate:date];
        [formatter release];
        return dateStr;
    }
    return nil;
}

+ (NSString *)getMonthString {
    NSDate * date = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* compoNents = [calendar components:NSMonthCalendarUnit fromDate:date]; // Get necessary date 
    return [compoNents month] > 9 ? [NSString stringWithFormat:@"9%d", compoNents.month] : [NSString stringWithFormat:@"90%d", compoNents.month];
}

+ (NSString *)getMonthFromDateString:(NSString *)dateStr withDateFormat:(NSString *)dateFormat {
    NSDate *date = [Utils getDateFromString:dateStr withFormat:dateFormat];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* compoNents = [calendar components:NSMonthCalendarUnit fromDate:date]; // Get necessary date components    
    return [compoNents month] > 9 ? [NSString stringWithFormat:@"9%d", compoNents.month] : [NSString stringWithFormat:@"90%d", compoNents.month];
}



+ (UIViewController *)getViewControllerFromPopOverController:(UIPopoverController *)popoverController {
    if (popoverController && popoverController.contentViewController) {
        UINavigationController * navController = (UINavigationController *)popoverController.contentViewController;
        if ([navController isKindOfClass:[UINavigationController class]]) {
            return [[navController viewControllers] lastObject];
        } 
        return navController;
    }
    return nil;
}

+ (BOOL)validateEmail:(NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)addTempValue:(NSString *)value withName:(NSString *)name {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:name];
    return [userDefaults synchronize];
}

+ (NSString *)getTempValueForName:(NSString *)name {
    return [[NSUserDefaults standardUserDefaults] valueForKey:name];
    
}

@end
