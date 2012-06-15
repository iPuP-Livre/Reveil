//
//  ViewController.h
//  Reveil
//
//  Created by Marian PAUL on 10/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRepeatAlarm @"repeatAlarm"
#define kDate @"date"

@interface ViewController : UIViewController
{
    BOOL _repeatAlarm;
    NSDate *_scheduleDate;
}
- (void)scheduleAlarmForDate:(NSDate*)theDate;
@end
