//
//  NSDate+Extensions.m
//  CoreLibrary
//
//  Created by Shaps Mohsenin on 17/11/12.
//  Copyright (c) 2012 CodeBendaz. All rights reserved.
//

#import "NSDate+SLAdditions.h"

@implementation NSDate (SLAdditions)

+(NSDate *)dateFromRFC3339DateString:(NSString *)dateString
{
    NSDateFormatter *rfc3339TimestampFormatterWithTimeZone = [[NSDateFormatter alloc] init];
    [rfc3339TimestampFormatterWithTimeZone setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [rfc3339TimestampFormatterWithTimeZone setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];

    NSDate *theDate = nil;
    NSError *error = nil;
	
    if (![rfc3339TimestampFormatterWithTimeZone getObjectValue:&theDate forString:dateString range:nil error:&error])
	{
		// if that failed, try parsing with 'Z'
		[rfc3339TimestampFormatterWithTimeZone setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];

		if (![rfc3339TimestampFormatterWithTimeZone getObjectValue:&theDate forString:dateString range:nil error:&error])
		{
			NSLog(@"Date '%@' could not be parsed: %@", dateString, error);
		}
    }

    return theDate;
}

-(NSString *)naturalLanguageDate
{
	NSDate *endDate = self;
    NSDate *startDate = [NSDate date];

    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];

    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startDate
                                                  toDate:endDate options:0];

    int years = (int)[components year];
    int months = (int)[components month];
    int days = (int)[components day];
    int hours = (int)[components hour];
    int minutes = (int)[components minute];
    int seconds = (int)[components second];

    if (years != 0) {
        if (years == -1)
            return @"a year ago";
        if (years < -1)
            return [NSString stringWithFormat:@"%i years ago", abs(years)];
    }

    if (months != 0) {
        if (months == -1)
            return @"a month ago";
        if (months < -1)
		{
			[NSString stringWithFormat:@"%i months ago", abs(months)];
		}
    }

    if (days != 0) {
        if (days == -1)
            return @"yesterday";
		else if (days % 7 == 0)
            return [NSString stringWithFormat:@"%i weeks ago", abs(days/7)];
        if (days < -1)
            return [NSString stringWithFormat:@"%i days ago", abs(days)];
    }

    if (hours != 0) {
        if (hours == -1)
            return @"an hour ago";
        if (hours < -1)
            return [NSString stringWithFormat:@"%i hours ago", abs(hours)];
    }

    if (minutes != 0) {
        if (minutes == -1)
            return @"a minute ago";
        if (minutes < -1)
            return [NSString stringWithFormat:@"%i minutes ago", abs(minutes)];
    }

    if (seconds != 0) {
        if (seconds < -1)
            return [NSString stringWithFormat:@"%i seconds ago", abs(seconds)];
    }

    return @"just now";
}

@end