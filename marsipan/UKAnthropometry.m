//
//  UKAnthropometry.m
//  UKAnthropometry
//
//  Created by Simon Chapman on 02/11/2013.
//  Copyright (c) 2013 eatyourpeas. All rights reserved.
//

#import "UKAnthropometry.h"

@implementation UKAnthropometry

#pragma mark public methods

-(NSNumber*)calculateDecimalAgeFromDOB:(NSDate *)dateOfBirth usingClinicDate:(NSDate *)clinicDate{
    
    //set both dates to current timezone and to midnight
    
    
    NSDate *thisDateOfBirth = [self setDateToMidnight:dateOfBirth];
    NSDate *thisClinicDate = [self setDateToMidnight:clinicDate];
    
    //calculate time elapsed
    NSTimeInterval timeElapsed = [thisClinicDate timeIntervalSinceDate:thisDateOfBirth];
    
    double finalDecimalAge = (timeElapsed/(3600*24))/365.25;
    
    
    //return decimal age as an NSNumber
    
    
    
    NSNumber *finalDecimalAgeToReturn = [NSNumber numberWithDouble:finalDecimalAge];
    
    return finalDecimalAgeToReturn;
    
}

-(NSString*) calendarAgeFromDOB:(NSDate*)dateOfBirth usingClinicDate: (NSDate*) clinicDate{
    NSString *calendarAge;
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:dateOfBirth
                                                  toDate:clinicDate options:0];
    
    NSInteger years = [components year];
    NSInteger months = [components month];
    
    calendarAge = [NSString stringWithFormat:@"%li years, %li months", (long)years, (long)months];
    
    return calendarAge;
}

-(NSArray *)returnGradeOfThinnessOrObesityCuttOffFromReferenceDataUsingSex:(NSString*)sex andAge:(NSNumber*)decimalAge andBMI:(NSNumber*)bMI{
    
    //returns an array: 0 is the category, 1 is the threshold
    
    
    NSDictionary *referenceIOTFDataDictionary = [[NSDictionary alloc]init];
    NSArray *referenceIOTFDataArray = [[NSArray alloc]init];
    
    referenceIOTFDataDictionary = [self loadUpIOTFPListsIntoDictionaryUsingSex:sex];
    referenceIOTFDataArray = [self loadUpIOTFPListsIntoArrayUsingSex:sex];
    
    NSArray *IOTFCuttOffs = [[NSArray alloc]init];
    
    //get the appropriate cutoffs for age - interpolate if necessary: the IOTF data runs out at 18 so set age to 18 if above
    
    if ([decimalAge doubleValue] > 18) {
        decimalAge = [NSNumber numberWithDouble:18.0];
    }
    
    
    IOTFCuttOffs = [self returnIOTFCutOffsForParameterDictionary:referenceIOTFDataDictionary andParameterArray:referenceIOTFDataArray usingDecimalAge:decimalAge];
    
    
    NSNumber *IOTFCutOff;
    NSString *IOTFCategory;
    
    NSArray *IOTFDefinitions = [[NSArray alloc]initWithObjects:@"Grade 3 Thinness", @"Grade 2 Thinness", @"Grade 1 Thinness", @"Overweight (unofficial Asian cut-off)", @"Overweight", @"Obesity (unofficial Asian cut-off)", @"Obesity", @"Morbid Obesity",  nil];
    
    
    // if bmi is in the low weight range, report the higher threshold, if in the higher range, report the lower.
    double doubleBMI = 0.0;
    doubleBMI = [bMI doubleValue];
    
    if (doubleBMI < [[IOTFCuttOffs objectAtIndex:0]doubleValue]) {
        
        // bmi is below the lowest threshold
        IOTFCutOff = [IOTFCuttOffs objectAtIndex:0];
        IOTFCategory = [IOTFDefinitions objectAtIndex:0];
        
    }
    
    if (doubleBMI >= [[IOTFCuttOffs objectAtIndex:0] doubleValue]) {
        IOTFCutOff = [IOTFCuttOffs objectAtIndex:1];
        IOTFCategory = [IOTFDefinitions objectAtIndex:1];
    }
    
    if (doubleBMI >= [[IOTFCuttOffs objectAtIndex:1]doubleValue]) {
        IOTFCutOff = [IOTFCuttOffs objectAtIndex:2];
        IOTFCategory = [IOTFDefinitions objectAtIndex:2];
    }
    
    if (doubleBMI >= [[IOTFCuttOffs objectAtIndex:2]doubleValue]) {
        IOTFCutOff = [NSNumber numberWithDouble:0.0];
        IOTFCategory = @"in normal range";
    }
    
    for (int j=3; j<8; j++) { //these are bmi in the overweight range
        
        if (doubleBMI >= [[IOTFCuttOffs objectAtIndex:j]doubleValue]) {
            IOTFCutOff = [IOTFCuttOffs objectAtIndex:j];
            IOTFCategory = [IOTFDefinitions objectAtIndex:j];
        }
    }
    
    NSString *IOTFCutOffString;
    double IOTFCutOffDoubleValue = [IOTFCutOff doubleValue];
    
    
    if (IOTFCutOffDoubleValue == 0.0) { //these are normal weight
        
        IOTFCutOffString = [NSString stringWithFormat:@"%.f - %.f", [[IOTFCuttOffs objectAtIndex:2]doubleValue], [[IOTFCuttOffs objectAtIndex:3]doubleValue]];
        
    }
    
    else if (IOTFCutOffDoubleValue != 0.0){
        
        
        IOTFCutOffString = [NSString stringWithFormat:@"%.f", IOTFCutOffDoubleValue];
    }
    
    
    
    NSArray *IOTFResults = [[NSArray alloc]initWithObjects:IOTFCategory, IOTFCutOffString, nil];
    
    return IOTFResults;
}

-(NSNumber*)calculateBMIFromHeight:(NSNumber *)height andWeight:(NSNumber *)weight
{
    NSNumber *bMIResult;
    double bmi;
    
    
    bmi =[weight doubleValue]/(([height doubleValue] * [height doubleValue])/10000);
    
    bMIResult = [[NSNumber alloc]initWithDouble:bmi];
    
    return bMIResult;
}

-(NSMutableArray*)calculateSDSandCentileAndPctmBMIandExpectedWeightsFromDecimalAge:(NSNumber*)decimalAge andSex:(NSString*)sex andHeight:(NSNumber*)height andWeight:(NSNumber*)weight andBMI:(NSNumber*)bMI
{
    double L = 0.0;
    double M = 0.0;
    double S = 0.0;
    
    NSArray *chosenBMIArray = [[NSArray alloc]init];
    NSArray *chosenHeightArray = [[NSArray alloc]init];
    NSArray *chosenWeightArray = [[NSArray alloc]init];
    
    NSDictionary *chosenBMIDictionary = [[NSDictionary alloc]init];
    NSDictionary *chosenHeightDictionary = [[NSDictionary alloc]init];
    NSDictionary *chosenWeightDictionary = [[NSDictionary alloc]init];
    
    chosenBMIArray = [self loadUpPListsIntoArrayUsingSex:sex andParameter:@"BMI"];
    chosenHeightArray = [self loadUpPListsIntoArrayUsingSex:sex andParameter:@"Height"];
    chosenWeightArray = [self loadUpPListsIntoArrayUsingSex:sex andParameter:@"Weight"];
    
    chosenBMIDictionary = [self loadUpPListsIntoDictionaryUsingSex:sex andParameter:@"BMI"];
    chosenHeightDictionary = [self loadUpPListsIntoDictionaryUsingSex:sex andParameter:@"Height"];
    chosenWeightDictionary = [self loadUpPListsIntoDictionaryUsingSex:sex andParameter:@"Weight"];
    
    //round the decimal age
    
    NSNumberFormatter *nF = [[NSNumberFormatter alloc]init];
    [nF setNumberStyle:NSNumberFormatterDecimalStyle];
    [nF setMaximumFractionDigits:3];
    
    NSString *thisDecimalAge = [nF stringFromNumber:decimalAge];
    NSNumber *decimalAgeNSNumber = [NSNumber numberWithDouble:[thisDecimalAge doubleValue]];
    
    
    // look up decimal age against reference for LMS for each parameter
    NSArray *heightLMSArray = [[NSArray alloc]init];
    NSArray *weightLMSArray = [[NSArray alloc]init];
    NSArray *BMILMSArray = [[NSArray alloc]init];
    
    heightLMSArray = [self returnLMSForParameterDictionary:chosenHeightDictionary andParameterArray:chosenHeightArray usingDecimalAge:decimalAgeNSNumber];
    weightLMSArray = [self returnLMSForParameterDictionary:chosenWeightDictionary andParameterArray:chosenWeightArray usingDecimalAge:decimalAgeNSNumber];
    BMILMSArray = [self returnLMSForParameterDictionary:chosenBMIDictionary andParameterArray:chosenBMIArray usingDecimalAge:decimalAgeNSNumber];
    
    //use the returned LMS arrays to calculate BMI SDS, centiles, %mBMI and weights for given centiles
    
    L = [[BMILMSArray objectAtIndex:0]doubleValue];
    M = [[BMILMSArray objectAtIndex:1]doubleValue];
    S = [[BMILMSArray objectAtIndex:2]doubleValue];
    
    double medianBMI = M;
    
    NSNumber *SDS = [self calculateSDSFromL:L andM:M andS:S andActualMeasurement:bMI];
    NSNumber *centile = [NSNumber numberWithDouble:[self convertZScoreToCentile:[SDS doubleValue]]];
    
    NSNumber *pctBMI = [self calculatemBMIfromM:M andActualBMI:bMI];
    NSNumber *ninthCentile = [self calculateBMIForAgeForCentile:-1.341 andL:L andM:M andS:S andActualBMI:bMI];
    NSNumber *fiftiethCentile = [self calculateBMIForAgeForCentile:0 andL:L andM:M andS:S andActualBMI:bMI];
    NSNumber *ninetyFirstCentile = [self calculateBMIForAgeForCentile:1.341 andL:L andM:M andS:S andActualBMI:bMI];
    
    // use the returned LMS arrays to calculate centiles and SDS for height
    
    L = [[heightLMSArray objectAtIndex:0]doubleValue];
    M = [[heightLMSArray objectAtIndex:1]doubleValue];
    S = [[heightLMSArray objectAtIndex:2]doubleValue];
    
   
    NSNumber *heightSDS = [self calculateSDSFromL:L andM:M andS:S andActualMeasurement:height];
    NSNumber *heightCentile = [NSNumber numberWithDouble:[self convertZScoreToCentile:[heightSDS doubleValue]]];
    
    // use the returned LMS arrays to calculate centiles and SDS for weight
    
    L = [[weightLMSArray objectAtIndex:0]doubleValue];
    M = [[weightLMSArray objectAtIndex:1]doubleValue];
    S = [[weightLMSArray objectAtIndex:2]doubleValue];
    
    NSNumber *weightSDS = [self calculateSDSFromL:L andM:M andS:S andActualMeasurement:weight];
    NSNumber *weightCentile = [NSNumber numberWithDouble:[self convertZScoreToCentile:[weightSDS doubleValue]]];
    
    
    NSNumber *weightAt85 = [self weightForPercentage:85.0 fromHeight:height andMedianBMI:[NSNumber numberWithDouble:medianBMI]];
    NSNumber *weightAt90 = [self weightForPercentage:90.0 fromHeight:height andMedianBMI:[NSNumber numberWithDouble:medianBMI]];
    NSNumber *weightAt95 = [self weightForPercentage:95.0 fromHeight:height andMedianBMI:[NSNumber numberWithDouble:medianBMI]];
    
    
    NSNumber *weightAtBMI9thCentile = [self calculateExpectedWeightFromHeight:height andBMI:ninthCentile];
    NSNumber *weightAtBMI50thCentile = [self calculateExpectedWeightFromHeight:height andBMI:fiftiethCentile];
    NSNumber *weightAtBMI91stCentile = [self calculateExpectedWeightFromHeight:height andBMI:ninetyFirstCentile];
    
    NSMutableArray *arrayOfResults = [[NSMutableArray alloc] initWithObjects:SDS, centile, pctBMI, weightAtBMI9thCentile, weightAtBMI50thCentile,  weightAtBMI91stCentile, weightAt85, weightAt90, weightAt95, heightSDS, heightCentile, weightCentile, weightSDS,nil];
    
    return arrayOfResults;
}

-(NSNumber*)weightForPercentage:(double)percentage fromHeight: (NSNumber*)height andMedianBMI:(NSNumber*)mBMI
{
    
    NSNumber *weightToCalculate;
    
    NSNumber *targetBMI;
    targetBMI = [NSNumber numberWithDouble:([mBMI doubleValue] * (percentage/100))];
    
    weightToCalculate = [self calculateExpectedWeightFromHeight:height andBMI:targetBMI];
    
    
    return weightToCalculate;
}

- (NSNumber*) calculateExpectedWeightFromHeight:(NSNumber*)height andBMI:(NSNumber*)bmi{
    
    double expectedWeight;
    double heightDouble = [height doubleValue]/100;
    double bmiDouble = [bmi doubleValue];
    
    expectedWeight = (heightDouble*heightDouble*bmiDouble);
    
    
    return [NSNumber numberWithDouble:expectedWeight];
    
}

#pragma mark - private methods

-(NSDate*)setDateToMidnight:(NSDate*)dateToReset {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [cal setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDateComponents * comp = [cal components:( NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:dateToReset];
    
    [comp setMinute:0];
    [comp setHour:0];
    
    NSDate *selectedDateAtMidnight = [cal dateFromComponents:comp];
    return selectedDateAtMidnight;
}

-(NSArray*)loadUpPListsIntoArrayUsingSex: (NSString*)sex andParameter:(NSString*)heightWeightBMI{
    
    NSString *boysBMIPath = [[NSBundle mainBundle]
                             pathForResource:@"UK90BoysBMILMS" ofType:@"plist"];
    NSString *girlsBMIPath = [[NSBundle mainBundle]
                              pathForResource:@"UK90GirlsBMILMS" ofType:@"plist"];
    NSString *boysHeightPath = [[NSBundle mainBundle]
                                pathForResource:@"UK90WHOBoysLengthLMS" ofType:@"plist"];
    NSString *girlsHeightPath = [[NSBundle mainBundle]
                                 pathForResource:@"UK90WHOGirlsLengthLMS" ofType:@"plist"];
    NSString *boysWeightPath = [[NSBundle mainBundle]
                                pathForResource:@"UK90WHOBoysWeightLMS" ofType:@"plist"];
    NSString *girlsWeightPath = [[NSBundle mainBundle]
                                 pathForResource:@"UK90WHOGirlsWeightLMS" ofType:@"plist"];
    
    
    /*
     NSFileManager *fileManager = [NSFileManager defaultManager];
     if ([fileManager fileExistsAtPath:boysPath]) {
     NSLog(@"The boys file exists");
     } else {
     NSLog(@"The file does not exist");
     }
     */
    
    _boysBMILMSDataArray = [[NSArray alloc]initWithContentsOfFile:boysBMIPath];
    _girlsBMILMSDataArray = [[NSArray alloc]initWithContentsOfFile:girlsBMIPath];
    _boysHeightLMSDataArray = [[NSArray alloc]initWithContentsOfFile:boysHeightPath];
    _girlsHeightLMSDataArray = [[NSArray alloc]initWithContentsOfFile:girlsHeightPath];
    _boysWeightLMSDataArray = [[NSArray alloc]initWithContentsOfFile:boysWeightPath];
    _girlsWeightLMSDataArray = [[NSArray alloc]initWithContentsOfFile:girlsWeightPath];
    
    
    
    _boysBMILMSDataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:boysBMIPath];
    _girlsBMILMSDataDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:girlsBMIPath];
    _boysHeightLMSDataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:boysHeightPath];
    _girlsHeightLMSDataDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:girlsHeightPath];
    _boysWeightLMSDataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:boysWeightPath];
    _girlsWeightLMSDataDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:girlsWeightPath];
    
    
    
    
    
    NSDictionary *chosenDictionary = [[NSDictionary alloc]init];
    
    NSArray *arrayOfDataFromChosenDictionary = [[NSArray alloc]init];
    
    
    if ([sex isEqualToString:@"Male"]) {
        
        if ([heightWeightBMI isEqualToString:@"Height"]) {
            chosenDictionary = _boysHeightLMSDataDictionary;
            arrayOfDataFromChosenDictionary = _boysHeightLMSDataArray;
        }
        
        else if ([heightWeightBMI isEqualToString:@"Weight"]){
            
            chosenDictionary = _boysWeightLMSDataDictionary;
            arrayOfDataFromChosenDictionary = _boysWeightLMSDataArray;
        }
        
        else if ([heightWeightBMI isEqualToString:@"BMI"]){
            
            chosenDictionary = _boysBMILMSDataDictionary;
            arrayOfDataFromChosenDictionary = _boysBMILMSDataArray;
            
        }
        
    }
    
    else if([sex isEqualToString:@"Female"]){
        
        if ([heightWeightBMI isEqualToString:@"Height"]) {
            chosenDictionary = _girlsHeightLMSDataDictionary;
            arrayOfDataFromChosenDictionary = _girlsHeightLMSDataArray;
        }
        
        else if ([heightWeightBMI isEqualToString:@"Weight"]){
            
            chosenDictionary = _girlsWeightLMSDataDictionary;
            arrayOfDataFromChosenDictionary = _girlsWeightLMSDataArray;
        }
        
        else if ([heightWeightBMI isEqualToString:@"BMI"]){
            
            chosenDictionary = _girlsBMILMSDataDictionary;
            arrayOfDataFromChosenDictionary = _girlsBMILMSDataArray;
            
        }
    }
    
    
    return arrayOfDataFromChosenDictionary;
}

-(NSDictionary*)loadUpPListsIntoDictionaryUsingSex: (NSString*)sex andParameter:(NSString*)heightWeightBMI{
    
    NSString *boysBMIPath = [[NSBundle mainBundle]
                             pathForResource:@"UK90BoysBMILMS" ofType:@"plist"];
    NSString *girlsBMIPath = [[NSBundle mainBundle]
                              pathForResource:@"UK90GirlsBMILMS" ofType:@"plist"];
    NSString *boysHeightPath = [[NSBundle mainBundle]
                                pathForResource:@"UK90WHOBoysLengthLMS" ofType:@"plist"];
    NSString *girlsHeightPath = [[NSBundle mainBundle]
                                 pathForResource:@"UK90WHOGirlsLengthLMS" ofType:@"plist"];
    NSString *boysWeightPath = [[NSBundle mainBundle]
                                pathForResource:@"UK90WHOBoysWeightLMS" ofType:@"plist"];
    NSString *girlsWeightPath = [[NSBundle mainBundle]
                                 pathForResource:@"UK90WHOGirlsWeightLMS" ofType:@"plist"];
    
    /*
     NSFileManager *fileManager = [NSFileManager defaultManager];
     if ([fileManager fileExistsAtPath:boysPath]) {
     NSLog(@"The boys file exists");
     } else {
     NSLog(@"The file does not exist");
     }
     */
    
    _boysBMILMSDataArray = [[NSArray alloc]initWithContentsOfFile:boysBMIPath];
    _girlsBMILMSDataArray = [[NSArray alloc]initWithContentsOfFile:girlsBMIPath];
    _boysHeightLMSDataArray = [[NSArray alloc]initWithContentsOfFile:boysHeightPath];
    _girlsHeightLMSDataArray = [[NSArray alloc]initWithContentsOfFile:girlsHeightPath];
    _boysWeightLMSDataArray = [[NSArray alloc]initWithContentsOfFile:boysWeightPath];
    _girlsWeightLMSDataArray = [[NSArray alloc]initWithContentsOfFile:girlsWeightPath];
    
    _boysBMILMSDataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:boysBMIPath];
    _girlsBMILMSDataDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:girlsBMIPath];
    _boysHeightLMSDataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:boysHeightPath];
    _girlsHeightLMSDataDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:girlsHeightPath];
    _boysWeightLMSDataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:boysWeightPath];
    _girlsWeightLMSDataDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:girlsWeightPath];
    
    NSDictionary *chosenDictionary = [[NSDictionary alloc]init];
    
    NSArray *arrayOfDataFromChosenDictionary = [[NSArray alloc]init];
    
    
    if ([sex isEqualToString:@"Male"]) {
        
        if ([heightWeightBMI isEqualToString:@"Height"]) {
            chosenDictionary = _boysHeightLMSDataDictionary;
            arrayOfDataFromChosenDictionary = _boysHeightLMSDataArray;
        }
        
        else if ([heightWeightBMI isEqualToString:@"Weight"]){
            
            chosenDictionary = _boysWeightLMSDataDictionary;
            arrayOfDataFromChosenDictionary = _boysWeightLMSDataArray;
        }
        
        else if ([heightWeightBMI isEqualToString:@"BMI"]){
            
            chosenDictionary = _boysBMILMSDataDictionary;
            arrayOfDataFromChosenDictionary = _boysBMILMSDataArray;
            
        }
        
    }
    
    else if([sex isEqualToString:@"Female"]){
        
        if ([heightWeightBMI isEqualToString:@"Height"]) {
            chosenDictionary = _girlsHeightLMSDataDictionary;
            arrayOfDataFromChosenDictionary = _girlsHeightLMSDataArray;
        }
        
        else if ([heightWeightBMI isEqualToString:@"Weight"]){
            
            chosenDictionary = _girlsWeightLMSDataDictionary;
            arrayOfDataFromChosenDictionary = _girlsWeightLMSDataArray;
        }
        
        else if ([heightWeightBMI isEqualToString:@"BMI"]){
            
            chosenDictionary = _girlsBMILMSDataDictionary;
            arrayOfDataFromChosenDictionary = _girlsBMILMSDataArray;
            
        }
    }
    
    
    
    return chosenDictionary;
}

-(NSDictionary*)loadUpIOTFPListsIntoDictionaryUsingSex: (NSString*)sex{
    
    NSString *boysIOTFPath = [[NSBundle mainBundle]
                              pathForResource:@"boysIOTF" ofType:@"plist"];
    NSString *girlsIOTFPath = [[NSBundle mainBundle]
                               pathForResource:@"girlsIOTF" ofType:@"plist"];
    
    _boysIOTFDataArray = [[NSArray alloc]initWithContentsOfFile:boysIOTFPath];
    _girlsIOTFDataArray = [[NSArray alloc]initWithContentsOfFile:girlsIOTFPath];
    
    _boysIOTFDataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:boysIOTFPath];
    _girlsIOTFDataDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:girlsIOTFPath];
    
    NSDictionary *chosenIOTFDictionary = [[NSDictionary alloc]init];
    
    if ([sex isEqualToString:@"Male"]) {
        chosenIOTFDictionary = _boysIOTFDataDictionary;
    }
    else if ([sex isEqualToString:@"Female"]){
        chosenIOTFDictionary = _girlsIOTFDataDictionary;
    }
    
    return chosenIOTFDictionary;
    
}

-(NSArray*)loadUpIOTFPListsIntoArrayUsingSex: (NSString*)sex{
    
    NSString *boysIOTFPath = [[NSBundle mainBundle]
                              pathForResource:@"boysIOTF" ofType:@"plist"];
    NSString *girlsIOTFPath = [[NSBundle mainBundle]
                               pathForResource:@"girlsIOTF" ofType:@"plist"];
    
    _boysIOTFDataArray = [[NSArray alloc]initWithContentsOfFile:boysIOTFPath];
    _girlsIOTFDataArray = [[NSArray alloc]initWithContentsOfFile:girlsIOTFPath];
    
    _boysIOTFDataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:boysIOTFPath];
    _girlsIOTFDataDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:girlsIOTFPath];
    
    NSArray *chosenIOTFArray = [[NSArray alloc]init];
    
    if ([sex isEqualToString:@"Male"]) {
        chosenIOTFArray = _boysIOTFDataArray;
    }
    else if ([sex isEqualToString:@"Female"]){
        chosenIOTFArray = _girlsIOTFDataArray;
    }
    
    return chosenIOTFArray;
}

-(NSMutableArray*) returnArrayOfIOTFValuesForGivenIOTFCutOff: (NSString*)iOTFCutOff fromIOTFDictionary:(NSDictionary*)iOTFDictionary andIOTFArray:(NSArray*)iOTFArray{
    
    
    NSMutableArray *arrayOfIOTFValuesToReturn = [[NSMutableArray alloc]init];
    
    for (iOTFDictionary in iOTFArray) {
        [arrayOfIOTFValuesToReturn addObject: [iOTFDictionary valueForKey:iOTFCutOff]];
    }
    return arrayOfIOTFValuesToReturn;
}

-(NSArray*)returnLMSForParameterDictionary:(NSDictionary*)parameterDictionary andParameterArray: (NSArray*)parameterArray usingDecimalAge:(NSNumber*)theDecimalAge{
    
    double lowerAge;
    int lowerAgeIndex = 0, upperAgeIndex = 0;
    
    int counter = 0;
    
    double L, M, S;
    
    BOOL match = false;
    
    
    for(parameterDictionary in parameterArray)
    {
        double ageToMatch = [[parameterDictionary valueForKey:@"age"]doubleValue];
        
        
        
        if (ageToMatch == [theDecimalAge doubleValue]) {
            
            //there is an age match so allocate LMS values directly
            
            L = [[parameterDictionary valueForKey:@"L"]doubleValue];
            M = [[parameterDictionary valueForKey:@"M"]doubleValue];
            S = [[parameterDictionary valueForKey:@"S"]doubleValue];
            match = true;
          
        }
        
        else {
         
            //there is no age match: look up LMS above and below
            
            
            if (ageToMatch < [theDecimalAge doubleValue]) {
                
                
                lowerAge = ageToMatch;
                lowerAgeIndex = counter;
                counter++;
                
               
                
            }
        }
    }
    
    if (!match) {
        
        // there has been no match - use lower and upper and actual age to find interpolated LMS
        
        
        
        if (lowerAgeIndex == 0 || lowerAgeIndex + 1 == [parameterArray count] || ([theDecimalAge doubleValue] >= 3.916 && [theDecimalAge doubleValue] <= 4.083) || ([theDecimalAge doubleValue] >= 1.916 && [theDecimalAge doubleValue] <= 2.083)) {
            /// if we are at the extremes of the chart, or close to 2y where measuring goes from lying to standin, or close to 4 y where charts change from WHO to UK90: we will use linear interpolation, otherwise we use cubic
            
            upperAgeIndex = lowerAgeIndex + 1;
            
            
            NSDictionary *lowerDictionary = [[NSDictionary alloc]initWithDictionary:[parameterArray objectAtIndex:lowerAgeIndex] copyItems:true];
            NSDictionary *upperDictionary = [[NSDictionary alloc]initWithDictionary:[parameterArray objectAtIndex:upperAgeIndex] copyItems:true];
            L = [[self returnLinearInterpolatedParameter:@"L" FromLowerDictionary:lowerDictionary andUpperDictionary:upperDictionary andDecimalAge:theDecimalAge]doubleValue];
            M = [[self returnLinearInterpolatedParameter:@"M" FromLowerDictionary:lowerDictionary andUpperDictionary:upperDictionary andDecimalAge:theDecimalAge]doubleValue];
            S = [[self returnLinearInterpolatedParameter:@"S" FromLowerDictionary:lowerDictionary andUpperDictionary:upperDictionary andDecimalAge:theDecimalAge]doubleValue];
            
        
            
        }
        else{
           
            NSNumber *bottomAge, *oneAgeBelow, *oneAgeAbove, *topAge;
            
            NSDictionary *twoParametersBelowDictionary = [[NSDictionary alloc]initWithDictionary:[parameterArray objectAtIndex:lowerAgeIndex-1] copyItems:TRUE];
            bottomAge = [twoParametersBelowDictionary objectForKey:@"age"];
            
            NSDictionary *oneParameterBelowDictionary = [[NSDictionary alloc] initWithDictionary:[parameterArray objectAtIndex:lowerAgeIndex] copyItems:TRUE];
            oneAgeBelow = [oneParameterBelowDictionary objectForKey:@"age"];
            
            NSDictionary *oneParameterAbove = [[NSDictionary alloc]initWithDictionary:[parameterArray objectAtIndex:lowerAgeIndex+1] copyItems:TRUE];
            oneAgeAbove = [oneParameterAbove objectForKey:@"age"];
            
            NSDictionary *twoParametersAbove = [[NSDictionary alloc]initWithDictionary:[parameterArray objectAtIndex:lowerAgeIndex+2] copyItems:TRUE];
            topAge = [twoParametersAbove objectForKey:@"age"];
            
            L = [self cubicInterpolationOfParameter:@"L" FromAge:[theDecimalAge doubleValue] andAgeBelow:[bottomAge doubleValue] andSecondAgeBelow:[oneAgeBelow doubleValue] andAgeOneAbove:[oneAgeAbove doubleValue] andAgeTwoAbove:[topAge doubleValue] andParameterTwoBelowDictionary:twoParametersBelowDictionary andParameterOneBelowDictionary:oneParameterBelowDictionary andParameterOneAboveDictionary:oneParameterAbove andParameterTwoAboveDictionary:twoParametersAbove];
            M = [self cubicInterpolationOfParameter:@"M" FromAge:[theDecimalAge doubleValue] andAgeBelow:[bottomAge doubleValue] andSecondAgeBelow:[oneAgeBelow doubleValue] andAgeOneAbove:[oneAgeAbove doubleValue] andAgeTwoAbove:[topAge doubleValue] andParameterTwoBelowDictionary:twoParametersBelowDictionary andParameterOneBelowDictionary:oneParameterBelowDictionary andParameterOneAboveDictionary:oneParameterAbove andParameterTwoAboveDictionary:twoParametersAbove];
            S = [self cubicInterpolationOfParameter:@"S" FromAge:[theDecimalAge doubleValue] andAgeBelow:[bottomAge doubleValue] andSecondAgeBelow:[oneAgeBelow doubleValue] andAgeOneAbove:[oneAgeAbove doubleValue] andAgeTwoAbove:[topAge doubleValue] andParameterTwoBelowDictionary:twoParametersBelowDictionary andParameterOneBelowDictionary:oneParameterBelowDictionary andParameterOneAboveDictionary:oneParameterAbove andParameterTwoAboveDictionary:twoParametersAbove];
            
         
            
        }
       
        
        
    }
    
    NSArray *LMSToReturn = [[NSArray alloc]initWithObjects:[NSNumber numberWithDouble:L],[NSNumber numberWithDouble: M],[NSNumber numberWithDouble: S], nil];
    
   
    
    return  LMSToReturn;
    
    
}

-(NSArray*)returnIOTFCutOffsForParameterDictionary:(NSDictionary*)parameterDictionary andParameterArray: (NSArray*)parameterArray usingDecimalAge:(NSNumber*)theDecimalAge{
    
    BOOL match = false;
    
    double lowerAge;
    int lowerAgeIndex = 0, upperAgeIndex = 0;
    
    int counter = 0;
    
    double grade3, grade2, grade1, overweightAsian, overweight, obeseAsian, obese, morbidObese;
    
    
    for (parameterDictionary in parameterArray){
        double ageToMatch = [[parameterDictionary valueForKey:@"age"]doubleValue];
        
        
        
        if (ageToMatch == [theDecimalAge doubleValue]) {
            
            // there is an age match - load the IOTF cutoffs into an array
            grade3 = [[parameterDictionary valueForKey:@"16"]doubleValue];
            grade2 = [[parameterDictionary valueForKey:@"17"]doubleValue];
            grade1 = [[parameterDictionary valueForKey:@"18.5"]doubleValue];
            overweightAsian = [[parameterDictionary valueForKey:@"23"]doubleValue];
            overweight = [[parameterDictionary valueForKey:@"25"]doubleValue];
            obeseAsian = [[parameterDictionary valueForKey:@"27"]doubleValue];
            obese = [[parameterDictionary valueForKey:@"30"]doubleValue];
            morbidObese = [[parameterDictionary valueForKey:@"35"]doubleValue];
            
            match = true;
            
            
            
        }
        
        else {
            match = false;
            //there is no age match: look up LMS above and below
            
            
            if (ageToMatch < [theDecimalAge doubleValue]) {
                
                
                lowerAge = ageToMatch;
                lowerAgeIndex = counter;
                counter++;
                
            }
        }
        
    }
    
    if (match == false) {
        
        // there has been no match - use lower and upper and actual age to find interpolated LMS
        
        
        
        upperAgeIndex = lowerAgeIndex + 1;
        
        NSDictionary *lowerDictionary = [[NSDictionary alloc]initWithDictionary:[parameterArray objectAtIndex:lowerAgeIndex] copyItems:true];
        NSDictionary *upperDictionary = [[NSDictionary alloc]initWithDictionary:[parameterArray objectAtIndex:upperAgeIndex] copyItems:true];
        
            
            grade3 = [[self returnLinearInterpolatedParameter:@"16" FromLowerDictionary:lowerDictionary andUpperDictionary:upperDictionary andDecimalAge:theDecimalAge]doubleValue];
            grade2 = [[self returnLinearInterpolatedParameter:@"17" FromLowerDictionary:lowerDictionary andUpperDictionary:upperDictionary andDecimalAge:theDecimalAge]doubleValue];
            grade1 = [[self returnLinearInterpolatedParameter:@"18.5" FromLowerDictionary:lowerDictionary andUpperDictionary:upperDictionary andDecimalAge:theDecimalAge]doubleValue];
            overweightAsian = [[self returnLinearInterpolatedParameter:@"23" FromLowerDictionary:lowerDictionary andUpperDictionary:upperDictionary andDecimalAge:theDecimalAge]doubleValue];
            overweight = [[self returnLinearInterpolatedParameter:@"25" FromLowerDictionary:lowerDictionary andUpperDictionary:upperDictionary andDecimalAge:theDecimalAge]doubleValue];
            obeseAsian = [[self returnLinearInterpolatedParameter:@"27" FromLowerDictionary:lowerDictionary andUpperDictionary:upperDictionary andDecimalAge:theDecimalAge]doubleValue];
            obese = [[self returnLinearInterpolatedParameter:@"30" FromLowerDictionary:lowerDictionary andUpperDictionary:upperDictionary andDecimalAge:theDecimalAge]doubleValue];
            morbidObese = [[self returnLinearInterpolatedParameter:@"35" FromLowerDictionary:lowerDictionary andUpperDictionary:upperDictionary andDecimalAge:theDecimalAge]doubleValue];
    
        
        
        

    }
    
    
    
    NSArray *IOTFValuesToReturn = [[NSArray alloc]initWithObjects:[NSNumber numberWithDouble:grade3],[NSNumber numberWithDouble:grade2],[NSNumber numberWithDouble:grade1],[NSNumber numberWithDouble:overweightAsian],[NSNumber numberWithDouble:overweight],[NSNumber numberWithDouble:obeseAsian],[NSNumber numberWithDouble:obese],[NSNumber numberWithDouble:morbidObese], nil];
    
    
    
    return IOTFValuesToReturn;
    
}


-(double)convertZScoreToCentile:(double)zScore{
    double centile;
  //  centile = (0.5 * erfc(-zScore * M_SQRT1_2)*100);
    
    centile = (0.5 * (1 + erf(zScore * M_SQRT1_2))*100);
    
    if (centile<0.4) {
        centile = 0;
    }
    if (centile>99.6) {
        centile = 100;
    }
    return centile;
    
}

-(double)cubicInterpolationOfParameter:(NSString*)parameter FromAge:(double)decimalAge andAgeBelow:(double)ageOneBelow andSecondAgeBelow: (double)ageTwoBelow andAgeOneAbove : (double)ageOneAbove andAgeTwoAbove: (double) ageTwoAbove andParameterTwoBelowDictionary: (NSDictionary*) parameterTwoBelowDictionary andParameterOneBelowDictionary: (NSDictionary*) parameterOneBelowDictionary andParameterOneAboveDictionary:(NSDictionary*)parameterOneAboveDictionary andParameterTwoAboveDictionary:(NSDictionary*)parameterTwoAboveDictionary {
    
    //t01 and t02 are the ages below, t03, t04 ages above, y01, y02 are matched parameters, as are y03, y04
    
    // these statements perform a cubic interpolation
    
    
    NSNumber *parameterTwoBelow = [parameterTwoBelowDictionary objectForKey:parameter];
    NSNumber *parameterOneBelow = [parameterOneBelowDictionary objectForKey:parameter];
    NSNumber *parameterOneAbove = [parameterOneAboveDictionary objectForKey:parameter];
    NSNumber *parameterTwoAbove = [parameterTwoAboveDictionary objectForKey:parameter];
    
    
    
    double cubicInterpolatedValue = 0.0;
    
    double t = 0.0; //actual age
	double tt0 = 0.0;
    double tt1 = 0.0;
    double tt2 = 0.0;
    double tt3 = 0.0;
  
    double t01 = 0.0;
    double t02 = 0.0;
    double t03 = 0.0;
    double t12 = 0.0;
    double t13 = 0.0;
    double t23 = 0.0;
    
    t = decimalAge;
    
    /*
     SELECT @InterpolatedValue =
     CASE
     WHEN (@t0 IS NULL OR @t3 IS NULL ) THEN NULL
     WHEN (@t1 =@t) THEN @y1
     WHEN @y0 = @y1 And @y1 = @y2 And @y2 = @y3 Then @y1
     
     
     SELECT @tt0 = @t - @t0
     SELECT @tt1 = @t - @t1
     SELECT @tt2 = @t - @t2
     SELECT @tt3 = @t - @t3
     SELECT @t01 = @t0 - @t1
     SELECT @t02 = @t0 - @t2
     SELECT @t03 = @t0 - @t3
     SELECT @t12 = @t1 - @t2
     SELECT @t13 = @t1 - @t3
     SELECT @t23 = @t2 - @t3
     
     
     SELECT @InterpolatedValue =
     CASE
     WHEN (@t0 IS NULL OR @t3 IS NULL ) THEN NULL
     WHEN (@t1 =@t) THEN @y1
     WHEN @y0 = @y1 And @y1 = @y2 And @y2 = @y3 Then @y1
     ELSE @y0 * @tt1 * @tt2 * @tt3 /@t01 / @t02 / @t03
     -@y1 *@tt0*@tt2 *@tt3 /@t01 /@t12 /@t13
     +@y2 *@tt0 *@tt1 *@tt3 /@t02/@t12 /@t23
     -@y3 *@tt0 *@tt1*@tt2 /@t03 /@t13 /@t23
     END
     

    tt0 = t - t0;
	tt1 = t - t1
	tt2 = t - t2
	tt3 = t - t3
	t01 = t0 - t1
	t02 = t0 - t2
	t03 = t0 - t3
	t12 = t1 - t2
	t13 = t1 - t3
	t23 = t2 - t3
     
     */
    
    
    tt0 = decimalAge - ageTwoBelow;
    tt1 = decimalAge - ageOneBelow;
    tt2 = decimalAge - ageOneAbove;
    tt3 = decimalAge - ageTwoAbove;
    
    t01 = ageTwoBelow - ageOneBelow;
    t02 = ageTwoBelow - ageOneAbove;
    t03 = ageTwoBelow - ageTwoAbove;
    
    t12 = ageOneBelow - ageOneAbove;
    t13 = ageOneBelow - ageTwoAbove;
    t23 = ageOneAbove - ageTwoAbove;

    cubicInterpolatedValue = [parameterTwoBelow doubleValue] * tt1 * tt2 * tt3 /t01 / t02 / t03 - [parameterOneBelow doubleValue] * tt0 * tt2 * tt3 / t01 / t12 /t13 + [parameterOneAbove doubleValue] * tt0 * tt1 * tt3 / t02/ t12 / t23 - [parameterTwoAbove doubleValue] * tt0 * tt1 * tt2 / t03 / t13 / t23;
        
    
    
    
    return cubicInterpolatedValue;
    
}


-(NSNumber*) returnLinearInterpolatedParameter:(NSString*)LMS FromLowerDictionary: (NSDictionary*)lowerLMSDictionary andUpperDictionary:(NSDictionary*)upperLMSDictionary andDecimalAge: (NSNumber*)decimalAge{
    
    NSNumber *linearInterpolatedValue;
    
    double lowerValue, upperValue;
    double lowerAge, upperAge;
    double linearInterpolation;
    double actualAge = [decimalAge doubleValue];
    
    
    lowerValue = [[lowerLMSDictionary objectForKey:LMS]doubleValue];
    upperValue = [[upperLMSDictionary objectForKey:LMS]doubleValue];
    lowerAge = [[lowerLMSDictionary objectForKey:@"age"]doubleValue];
    upperAge = [[upperLMSDictionary objectForKey:@"age"]doubleValue];
    
    linearInterpolation = lowerValue + (((actualAge - lowerAge)*(upperValue-lowerValue))/(upperAge-lowerAge));
    
    linearInterpolatedValue = [NSNumber numberWithDouble:linearInterpolation];
    
    
    return linearInterpolatedValue;
    
}

-(NSNumber*) calculateSDSFromL:(double)myL andM:(double)myM andS:(double)myS andActualMeasurement:(NSNumber*)measurement {
    
    double ZScore = 0.0;
    NSNumber *SDS;
    
    double myMeasurement = [measurement doubleValue];
    
    if (myL != 0){
        ZScore = (((pow((myMeasurement/myM), myL))-1)/(myL*myS));
        
    }
    
    else {
        ZScore = (log10f(myMeasurement/myM)/myS);
        
    }
    
    SDS = [NSNumber numberWithDouble:ZScore];
    
    
    
    return SDS;
    
}

-(NSNumber*) calculatemBMIfromM:(double)myM andActualBMI:(NSNumber*)measurement{
    
    double percentMedianBMI;
    NSNumber *percentMedianBMINSNumber;
    
    percentMedianBMI = ([measurement doubleValue]/myM)*100;
    percentMedianBMINSNumber = [NSNumber numberWithDouble:percentMedianBMI];
    
    return percentMedianBMINSNumber;
}

-(NSNumber*) calculateBMIForAgeForCentile:(double)centileValueAsP andL:(double)myL andM:(double)myM andS:(double)myS andActualBMI:(NSNumber*)measurement{
    
    NSNumber *returnValue;
    double calculatedReturnValue;
    
    calculatedReturnValue = (pow((1+(myL*myS*centileValueAsP)), 1/myL)*myM);
    
    returnValue = [NSNumber numberWithDouble:calculatedReturnValue];
    return  returnValue;
}


#pragma mark - body surface area methods

-(NSNumber*) calculateMostellerBodySurfaceAreaFromHeight: (NSNumber*)height andWeight:(NSNumber*)weight {
    
    double BSA =0.0;
    
    BSA = sqrt((([height doubleValue]*[weight doubleValue])/3600));
    
    return [NSNumber numberWithDouble:BSA];
}

#pragma mark - BMR methods

-(NSNumber*) calculateHarrisBenedictBMRFromHeight:(NSNumber*)height andWeight:(NSNumber*)weight andSex:(NSString*)sex andAge:(NSNumber*)decimalAge{
    
    
    //this method returns BMR in kCal
    
    double harrisBenedict = 0.0;
    
    if ([sex isEqualToString:@"Male"]) {
        
        harrisBenedict = 66.47 + (13.7 * [weight doubleValue]) + (5* [height doubleValue]) - ([decimalAge doubleValue] * 6.8);
        
    }
    
    else if ([sex isEqualToString:@"Female"]){
        
        harrisBenedict = 655.1 + (9.6 * [weight doubleValue]) + (1.81 * [height doubleValue]) - (4.7 * [decimalAge doubleValue]);
        
    }
    
    return [NSNumber numberWithDouble:harrisBenedict];
    
}

-(NSNumber*) calculateBMRForLevelOfActivityUsingHarrisBenedict: (NSNumber*)harrisBenedict andActivityLevel:(NSNumber*)scale1to5{
    
    // Little/no exercise: BMR * 1.2 = Total Calorie Need
    // Light exercise: BMR * 1.375 = Total Calorie Need
    // Moderate exercise (3-5 days/wk): BMR * 1.55 = Total Calorie Need
    // Very active (6-7 days/wk): BMR * 1.725 = Total Calorie Need
    // Extra active (very active & physical job): BMR * 1.9 = Total Calorie Need
    
    double basalMetabolicRate = 0.0;
    
    switch ([scale1to5 intValue]) {
        case 1:
            basalMetabolicRate = [harrisBenedict doubleValue] * 1.2;
            break;
        case 2:
            basalMetabolicRate = [harrisBenedict doubleValue] * 1.375;
            break;
        case 3:
            basalMetabolicRate = [harrisBenedict doubleValue] * 1.55;
            break;
        case 4:
            basalMetabolicRate = [harrisBenedict doubleValue] * 1.725;
            break;
        case 5:
            basalMetabolicRate = [harrisBenedict doubleValue] * 1.9;
            break;
            
        default:
            basalMetabolicRate = [harrisBenedict doubleValue] * 1.2; //the default assumes no exercise
            break;
    }
    
    return [NSNumber numberWithDouble:basalMetabolicRate];
}

-(NSNumber*)returnSchofieldBMRFromWeight:(NSNumber*)weight andAge:(NSNumber*)age andSex:(NSString*)sex{
    
    //this method returns Schofield in kCal
    
    double schofield = 0.0;
    double schofieldConstantMultiplier = 0.0;
    double schofieldCorrectionConstant = 0.0;
    double standardError = 0.0;
    BOOL sexIsMale = TRUE;
    
    
    
    if ([sex isEqualToString:@"Male"]) {
        
        sexIsMale = TRUE;
        
    }
    
    else if ([sex isEqualToString:@"Female"]){
        
        sexIsMale = FALSE;
        
    }
    
    if ([age doubleValue] < 3.0) {
        if (sexIsMale) {
                schofieldConstantMultiplier = 59.512;
                schofieldCorrectionConstant = -30.4;
                standardError = 70.0;
        }
        else{
                schofieldConstantMultiplier = 58.317;
                schofieldCorrectionConstant = -31.1;
                standardError = 59.0;
        }
    }
    
    if ([age doubleValue] >= 3.0 && [age doubleValue]<10.0) {
        if (sexIsMale) {
                schofieldConstantMultiplier = 22.706;
                schofieldCorrectionConstant = 504.3;
                standardError = 67.0;
        }
        else{
                schofieldConstantMultiplier = 20.315;
                schofieldCorrectionConstant = 485.9;
                standardError = 70.0;
        }
        
    }
    if ([age doubleValue] >= 10.0 && [age doubleValue]<18.0) {
        if (sexIsMale) {
                schofieldConstantMultiplier = 17.686;
                schofieldCorrectionConstant = 658.2;
                standardError = 105.0;
        }
        else{
                schofieldConstantMultiplier = 13.384;
                schofieldCorrectionConstant = 692.6;
                standardError = 111.0;
        }
    }
    
    if ([age doubleValue] >= 18.0 && [age doubleValue]<30.0) {
        if (sexIsMale) {
                schofieldConstantMultiplier = 15.057;
                schofieldCorrectionConstant = 692.2;
                standardError = 153.0;
        }
        else{
                schofieldConstantMultiplier = 14.818;
                schofieldCorrectionConstant = 486.6;
                standardError = 119.0;
        }
    }
    
    if ([age doubleValue] >= 30.0 && [age doubleValue]<60.0) {
        if (sexIsMale) {
                schofieldConstantMultiplier = 11.472;
                schofieldCorrectionConstant = 873.1;
                standardError = 167.0;
        }
        else{
                schofieldConstantMultiplier = 8.126;
                schofieldCorrectionConstant = 845.6;
                standardError = 111.0;
        }
    }
    
    if ([age doubleValue] >= 60.0) {
        if (sexIsMale) {
                schofieldConstantMultiplier = 11.711;
                schofieldCorrectionConstant = 587.7;
                standardError = 164.0;
        }
        else{
                schofieldConstantMultiplier = 9.082;
                schofieldCorrectionConstant = 658.5;
                standardError = 108.0;
       
        }
    }
    
    schofield = [weight doubleValue] * schofieldConstantMultiplier + schofieldCorrectionConstant;
    
    return [NSNumber numberWithDouble:schofield];
}

-(NSNumber*)returnAdjustedBMRForPredictedActivityLevel:(NSNumber*)activityLevel1to5 andSex:(NSString*)sex andRawSchofield:(NSNumber*)rawSchofield andBMRScore:(NSString*)schofieldHenry{
    
    //note this method is deprecated
    
    double schofieldWithPAL=0.0;
    BOOL sexIsMale = TRUE;
    
    if ([sex isEqualToString:@"Male"]) {
        
        sexIsMale = TRUE;
        
    }
    
    else if ([sex isEqualToString:@"Female"]){
        
        sexIsMale = FALSE;
        
    }
    
    switch ([activityLevel1to5 intValue]) {
        case 1:
            schofieldWithPAL = 1.3;
            break;
        case 2:
            if (sexIsMale) {
                schofieldWithPAL = 1.6;
            }
            else if(!sexIsMale){
                schofieldWithPAL = 1.5;
            }
            break;
        case 3:
            if (sexIsMale) {
                schofieldWithPAL = 1.7;
            }
            else if(!sexIsMale){
                schofieldWithPAL = 1.6;
            }
            break;
        case 4:
            if (sexIsMale) {
                schofieldWithPAL = 2.1;
            }
            else if(!sexIsMale){
                schofieldWithPAL = 1.9;
            }
            break;
        case 5:
            if (sexIsMale) {
                schofieldWithPAL = 2.4;
            }
            else if(!sexIsMale){
                schofieldWithPAL = 2.2;
            }
        default:
            break;
    }
    
    schofieldWithPAL *= [rawSchofield doubleValue];
    
    return [NSNumber numberWithDouble:schofieldWithPAL];
}

-(NSNumber*) returnPALAdjustedHenry:(NSNumber*)henry ForLevelOfActivity:(NSNumber*)levelOfActivity1to3 andAge:(NSNumber*)decimalAge{
    
    
    
    _PALfor0to3y = [[NSArray alloc]initWithObjects:[NSDecimalNumber decimalNumberWithString:@"1.36"], [NSDecimalNumber decimalNumberWithString:@"1.4"], [NSDecimalNumber decimalNumberWithString:@"1.45"], nil];
    _PALfor3to10y = [[NSArray alloc]initWithObjects:[NSDecimalNumber decimalNumberWithString:@"1.43"], [NSDecimalNumber decimalNumberWithString:@"1.58"], [NSDecimalNumber decimalNumberWithString:@"1.7"], nil];
    _PALfor10to18y = [[NSArray alloc]initWithObjects:[NSDecimalNumber decimalNumberWithString:@"1.68"], [NSDecimalNumber decimalNumberWithString:@"1.75"], [NSDecimalNumber decimalNumberWithString:@"1.86"], nil];
    
    
    
    
    NSNumber *PALAdjustedHenry;
    int activityLevel = [levelOfActivity1to3 intValue] - 1;
    NSDecimalNumber *PAL;
    
    
    
    
    
    if ([decimalAge doubleValue]<3) {
        
        PAL = [_PALfor0to3y objectAtIndex:activityLevel];
        
    }
    else if([decimalAge doubleValue]<10){
        
        PAL = [_PALfor3to10y objectAtIndex:activityLevel];
        
    }
    else if([decimalAge doubleValue]<=18){
        
        PAL = [_PALfor10to18y objectAtIndex:activityLevel];
    }
    else{
        //adult values apply
    }
    
    PALAdjustedHenry = [NSNumber numberWithDouble:[PAL doubleValue]*[henry doubleValue]];
    
    return PALAdjustedHenry;
}

-(NSNumber*)returnHenryBMRFromWeight:(NSNumber*)weight andAge:(NSNumber*)age andSex:(NSString*)sex{
    
    //this method returns Schofield in kCal
    
    double henry = 0.0;
    double henryConstantMultiplier = 0.0;
    double henryCorrectionConstant = 0.0;
    double standardError = 0.0;
    BOOL sexIsMale = TRUE;
    
    
    
    if ([sex isEqualToString:@"Male"]) {
        
        sexIsMale = TRUE;
        
    }
    
    else if ([sex isEqualToString:@"Female"]){
        
        sexIsMale = FALSE;
        
    }
    
    if ([age doubleValue] < 3.0) {
        if (sexIsMale) {
                henryConstantMultiplier = 61.0;
                henryCorrectionConstant = -337;
                standardError = 0.0;
        }
        else{
                henryConstantMultiplier = 58.9;
                henryCorrectionConstant = -23.1;
                standardError = 0.0;
        }
    }
    
    if ([age doubleValue] >= 3.0 && [age doubleValue]<10.0) {
        if (sexIsMale) {
                henryConstantMultiplier = 23.3;
                henryCorrectionConstant = 514;
                standardError = 0.0;
        }
        else{
                henryConstantMultiplier = 20.1;
                henryCorrectionConstant = 507.0;
                standardError = 0.0;
        }
    }
    if ([age doubleValue] >= 10.0 && [age doubleValue]<18.0) {
        if (sexIsMale) {
                henryConstantMultiplier = 18.4;
                henryCorrectionConstant = 581.0;
                standardError = 0.0;
        }
        else{
                henryConstantMultiplier = 11.1;
                henryCorrectionConstant = 761.0;
                standardError = 0.0;
        }
    }
    
    if ([age doubleValue] >= 18.0 && [age doubleValue]<30.0) {
        if (sexIsMale) {
                henryConstantMultiplier = 16.0;
                henryCorrectionConstant = 545.0;
                standardError = 0.0;
        }
        else{
                henryConstantMultiplier = 13.1;
                henryCorrectionConstant = 558.0;
                standardError = 0.0;
        }
    }
    
    if ([age doubleValue] >= 30.0 && [age doubleValue]<60.0) {
        if (sexIsMale) {
                henryConstantMultiplier = 14.2;
                henryCorrectionConstant = 593.0;
                standardError = 0.0;
        }
        else{
                henryConstantMultiplier = 9.7;
                henryCorrectionConstant = 694.0;
                standardError = 0.0;
            }
    }
    
    if ([age doubleValue] >= 60.0) {
        if (sexIsMale) {
                henryConstantMultiplier = 13.5;
                henryCorrectionConstant = 514.0;
                standardError = 0.0;
        }
        else{
                henryConstantMultiplier = 10.1;
                henryCorrectionConstant = 569.0;
                standardError = 0.0;
        }
    }
    
    henry = [weight doubleValue] * henryConstantMultiplier + henryCorrectionConstant;
    
    return [NSNumber numberWithDouble:henry];
}



#pragma mark - methods to load data into arrays for charts

-(NSDictionary*)returnCentilesForGivenParameter:(NSString*)parameter andSex: (NSString*)sex{
    
    NSString *boysBMIPath = [[NSBundle mainBundle]
                             pathForResource:@"malebmicentiles" ofType:@"plist"];
    NSString *girlsBMIPath = [[NSBundle mainBundle]
                              pathForResource:@"femalebmicentiles" ofType:@"plist"];
    NSString *boysHeightPath = [[NSBundle mainBundle]
                                pathForResource:@"maleheightcentiles" ofType:@"plist"];
    NSString *girlsHeightPath = [[NSBundle mainBundle]
                                 pathForResource:@"femaleheightcentiles" ofType:@"plist"];
    NSString *boysWeightPath = [[NSBundle mainBundle]
                                pathForResource:@"maleweightcentiles" ofType:@"plist"];
    NSString *girlsWeightPath = [[NSBundle mainBundle]
                                 pathForResource:@"femaleweightcentiles" ofType:@"plist"];
    
    _boysBMICentilesDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:boysBMIPath];
    _girlsBMICentilesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:girlsBMIPath];
    _boysHeightCentilesDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:boysHeightPath];
    _girlsHeightCentilesDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:girlsHeightPath];
    _boysWeightCentilesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:boysWeightPath];
    _girlsWeightCentilesDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:girlsWeightPath];
    
    
    
    NSDictionary *dictionaryOfCentilesToReturn = [NSDictionary alloc];
    
    if ([sex isEqualToString:@"Male"]) {
        
        
        
        if ([parameter isEqualToString:@"BMI"]) {
            dictionaryOfCentilesToReturn =_boysBMICentilesDictionary ;
            
        }
        else if ([parameter isEqualToString:@"Height"]){
            dictionaryOfCentilesToReturn = _boysHeightCentilesDictionary;
        }
        else if ([parameter isEqualToString:@"Weight"]){
            dictionaryOfCentilesToReturn =  _boysWeightCentilesDictionary ;
        }
        
    }
    
    else if ([sex isEqualToString:@"Female"]){
        
        if ([parameter isEqualToString:@"BMI"]) {
            [dictionaryOfCentilesToReturn setValuesForKeysWithDictionary: _girlsBMICentilesDictionary];
            
        }
        else if ([parameter isEqualToString:@"Height"]){
            [dictionaryOfCentilesToReturn setValuesForKeysWithDictionary: _girlsHeightCentilesDictionary];
        }
        else if ([parameter isEqualToString:@"Weight"]){
            [dictionaryOfCentilesToReturn setValuesForKeysWithDictionary: _girlsWeightCentilesDictionary];
        }
    }
    
    
    return dictionaryOfCentilesToReturn;
}

-(NSArray*)returnArrayOfCentilesForGivenParameter:(NSString*)parameter andSex: (NSString*)sex{
    
    NSString *boysBMIPath = [[NSBundle mainBundle]
                             pathForResource:@"malebmicentiles" ofType:@"plist"];
    NSString *girlsBMIPath = [[NSBundle mainBundle]
                              pathForResource:@"femalebmicentiles" ofType:@"plist"];
    NSString *boysHeightPath = [[NSBundle mainBundle]
                                pathForResource:@"maleheightcentiles" ofType:@"plist"];
    NSString *girlsHeightPath = [[NSBundle mainBundle]
                                 pathForResource:@"femaleheightcentiles" ofType:@"plist"];
    NSString *boysWeightPath = [[NSBundle mainBundle]
                                pathForResource:@"maleweightcentiles" ofType:@"plist"];
    NSString *girlsWeightPath = [[NSBundle mainBundle]
                                 pathForResource:@"femaleweightcentiles" ofType:@"plist"];
    
    _boysBMICentilesArray = [[NSArray alloc]initWithContentsOfFile:boysBMIPath];
    _girlsBMICentilesArray = [[NSArray alloc] initWithContentsOfFile:girlsBMIPath];
    _boysHeightCentilesArray = [[NSArray alloc]initWithContentsOfFile:boysHeightPath];
    _girlsHeightCentilesArray = [[NSArray alloc]initWithContentsOfFile:girlsHeightPath];
    _boysWeightCentilesArray = [[NSArray alloc] initWithContentsOfFile:boysWeightPath];
    _girlsWeightCentilesArray = [[NSArray alloc]initWithContentsOfFile:girlsWeightPath];
    
    
    NSArray *arrayOfCentilesToReturn = [[NSArray alloc]init];
    
    if ([sex isEqualToString:@"Male"]) {
        
        
        
        if ([parameter isEqualToString:@"BMI"]) {
            arrayOfCentilesToReturn = _boysBMICentilesArray;
            
        }
        else if ([parameter isEqualToString:@"Height"]){
            arrayOfCentilesToReturn = _boysHeightCentilesArray;
        }
        else if ([parameter isEqualToString:@"Weight"]){
            arrayOfCentilesToReturn = _boysWeightCentilesArray;
        }
        
    }
    
    else if ([sex isEqualToString:@"Female"]){
        
        if ([parameter isEqualToString:@"BMI"]) {
            arrayOfCentilesToReturn = _girlsBMICentilesArray;
            
        }
        else if ([parameter isEqualToString:@"Height"]){
            arrayOfCentilesToReturn = _girlsHeightCentilesArray;
        }
        else if ([parameter isEqualToString:@"Weight"]){
            arrayOfCentilesToReturn = _girlsWeightCentilesArray;
        }
    }
    
    
    
    return arrayOfCentilesToReturn;
}

-(NSMutableDictionary*) returnCentileDataForIndividualCentiles:(NSArray*) arrayOfCentile UsingParameter:(NSString*)parameter andSex:(NSString*)sex {
    
    //select correct dictionary and array to search
    
    
    
    
    NSArray *parameterArray = [[NSArray alloc]init];
    
    
    
    parameterArray = [self returnArrayOfCentilesForGivenParameter:parameter andSex:sex];
    
    
    
    // iterate through dictionary for values and load into array
    
    NSMutableDictionary *dictionaryOfAllCentileValuesToReturn = [[NSMutableDictionary alloc]init];
    NSMutableArray *arrayOfAgeValuesForThisParameter = [[NSMutableArray alloc]init];
    NSMutableArray *arrayOf04thValuesForThisParameter = [[NSMutableArray alloc]init];
    NSMutableArray *arrayOf2ndValuesForThisParameter = [[NSMutableArray alloc]init];
    NSMutableArray *arrayOf9thValuesForThisParameter = [[NSMutableArray alloc]init];
    NSMutableArray *arrayOf25thValuesForThisParameter = [[NSMutableArray alloc]init];
    NSMutableArray *arrayOf50thValuesForThisParameter = [[NSMutableArray alloc]init];
    NSMutableArray *arrayOf75thValuesForThisParameter = [[NSMutableArray alloc]init];
    NSMutableArray *arrayOf91stValuesForThisParameter = [[NSMutableArray alloc]init];
    NSMutableArray *arrayOf98thValuesForThisParameter = [[NSMutableArray alloc]init];
    NSMutableArray *arrayOf996thValuesForThisParameter = [[NSMutableArray alloc]init];
    
    
    for (int j=0; j<arrayOfCentile.count; j++) { //loop through the centiles
        
        NSString *theParameter = [arrayOfCentile objectAtIndex:j];
        
        
        for (NSDictionary *tempDictionary in parameterArray) {
            
            
            NSNumber *theNumberToAdd = [NSNumber numberWithDouble:[[tempDictionary objectForKey:theParameter] doubleValue]];
            
            if ([theParameter isEqualToString:@"04th"]) {
                [arrayOf04thValuesForThisParameter addObject: theNumberToAdd];
            }
            else if([theParameter isEqualToString:@"2nd"]) {
                [arrayOf2ndValuesForThisParameter addObject: theNumberToAdd];
            }
            else if([theParameter isEqualToString:@"9th"]) {
                [arrayOf9thValuesForThisParameter addObject: theNumberToAdd];
            }
            else if([theParameter isEqualToString:@"25th"]) {
                [arrayOf25thValuesForThisParameter addObject: theNumberToAdd];
            }
            else if([theParameter isEqualToString:@"50th"]) {
                [arrayOf50thValuesForThisParameter addObject: theNumberToAdd];
            }
            else if([theParameter isEqualToString:@"75th"]) {
                [arrayOf75thValuesForThisParameter addObject: theNumberToAdd];
            }
            else if([theParameter isEqualToString:@"91st"]) {
                [arrayOf91stValuesForThisParameter addObject: theNumberToAdd];
            }
            else if([theParameter isEqualToString:@"98th"]) {
                [arrayOf98thValuesForThisParameter addObject: theNumberToAdd];
            }
            else if([theParameter isEqualToString:@"996th"]) {
                [arrayOf996thValuesForThisParameter addObject: theNumberToAdd];
            }
            else if([theParameter isEqualToString:@"age"]) {
                [arrayOfAgeValuesForThisParameter addObject: theNumberToAdd];
            }
            
        }
        
    }
    
    [dictionaryOfAllCentileValuesToReturn setObject:arrayOfAgeValuesForThisParameter forKey:@"age"];
    [dictionaryOfAllCentileValuesToReturn setObject:arrayOf04thValuesForThisParameter forKey:@"04th"];
    [dictionaryOfAllCentileValuesToReturn setObject:arrayOf2ndValuesForThisParameter forKey:@"2nd"];
    [dictionaryOfAllCentileValuesToReturn setObject:arrayOf9thValuesForThisParameter forKey:@"9th"];
    [dictionaryOfAllCentileValuesToReturn setObject:arrayOf25thValuesForThisParameter forKey:@"25th"];
    [dictionaryOfAllCentileValuesToReturn setObject:arrayOf50thValuesForThisParameter forKey:@"50th"];
    [dictionaryOfAllCentileValuesToReturn setObject:arrayOf75thValuesForThisParameter forKey:@"75th"];
    [dictionaryOfAllCentileValuesToReturn setObject:arrayOf91stValuesForThisParameter forKey:@"91st"];
    [dictionaryOfAllCentileValuesToReturn setObject:arrayOf98thValuesForThisParameter forKey:@"98th"];
    [dictionaryOfAllCentileValuesToReturn setObject:arrayOf996thValuesForThisParameter forKey:@"996th"];
    
    
    return dictionaryOfAllCentileValuesToReturn;
    
}



@end
