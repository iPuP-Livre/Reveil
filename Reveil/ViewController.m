//
//  ViewController.m
//  Reveil
//
//  Created by Marian PAUL on 10/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];

    // Construction des éléments d'interface
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 245, 0, 0)]; // [2]
    datePicker.datePickerMode = UIDatePickerModeTime;
    [datePicker addTarget:self action:@selector(hasChangeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UILabel *labelRepeat = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 170, 30)];
    labelRepeat.backgroundColor = [UIColor clearColor];
    labelRepeat.text = @"Tous les jours ?";
    [self.view addSubview:labelRepeat];
    
    UISwitch *switchRepeat = [[UISwitch alloc] initWithFrame:CGRectMake(200, 30, 50, 30)];
    [switchRepeat addTarget:self action:@selector(switchHandle:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchRepeat];
    
    UIButton *buttonScheduleAlarm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonScheduleAlarm setTitle:@"Ajouter l'alarme" forState:UIControlStateNormal];
    [buttonScheduleAlarm setFrame:CGRectMake(10, 60, 300, 30)];
    [buttonScheduleAlarm addTarget:self action:@selector(scheduleAlarm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonScheduleAlarm];
    
    // gestion de la sauvegarde [3]
    _repeatAlarm = [[NSUserDefaults standardUserDefaults] boolForKey:kRepeatAlarm];
    
    NSString *dateSavedString = [[NSUserDefaults standardUserDefaults] stringForKey:kDate];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MM yyyy HH:mm";
    NSDate* date = [dateFormatter dateFromString:dateSavedString];
    
    if (date)
        [datePicker setDate:date animated:YES];
    else
        [datePicker setDate:[NSDate date] animated:YES];
    
}

- (void) hasChangeDate:(id)sender 
{
    UIDatePicker *aDatePicker = (UIDatePicker*)sender;    
    _scheduleDate = [aDatePicker date];
    NSLog(@"%@", _scheduleDate);
}

- (void) scheduleAlarm:(id)sender 
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *aComponent = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:_scheduleDate];
    [aComponent setSecond:0]; // [4]
    NSDate *theDate = [gregorian dateFromComponents:aComponent];
    
    [self scheduleAlarmForDate:theDate];
    // sauvegarde de la date du réveil    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MM yyyy HH:mm";
    NSString* dateString = [dateFormatter stringFromDate:theDate];
    [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:kDate];
}

- (void) switchHandle:(id)sender 
{
    UISwitch *aSwitch = (UISwitch*)sender;
    _repeatAlarm = aSwitch.on;
}

- (void)scheduleAlarmForDate:(NSDate*)theDate
{
    UIApplication* app = [UIApplication sharedApplication];
    NSArray* oldNotifications = [app scheduledLocalNotifications];
    
    // On enlève toutes les anciennes notifications avant d'en recréer une
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications]; // [5]
    
    // On crée une nouvelle notification
    UILocalNotification* alarm = [[UILocalNotification alloc] init];
    if (alarm)
    {
        NSLog(@"schedule for date %@", theDate);
        alarm.fireDate = theDate;
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = _repeatAlarm ? kCFCalendarUnitDay : 0; // [6]
        alarm.soundName = UILocalNotificationDefaultSoundName;
        alarm.alertBody = @"C'est l'heure !";
        alarm.alertAction = @"Se réveiller !";
        
        [app scheduleLocalNotification:alarm]; // [7]
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
