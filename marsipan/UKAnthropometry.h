//
//  UKAnthropometry.h
//  UKAnthropometry
//
//  Created by Simon Chapman on 02/11/2013.
//  Copyright (c) 2013 eatyourpeas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UKAnthropometry : NSObject


//@property(nonatomic,strong) NSDate *dateOfBirth;
//@property(nonatomic,strong) NSDate *clinicDate;
//@property(nonatomic,strong) NSNumber *decimalAge;
@property(nonatomic,strong) NSString *sex;
@property(nonatomic,strong) NSDictionary *boysBMILMSDataDictionary;
@property(nonatomic,strong) NSDictionary *girlsBMILMSDataDictionary;
@property(nonatomic,strong) NSDictionary *boysWeightLMSDataDictionary;
@property(nonatomic,strong) NSDictionary *girlsWeightLMSDataDictionary;
@property(nonatomic,strong) NSDictionary *boysHeightLMSDataDictionary;
@property(nonatomic,strong) NSDictionary *girlsHeightLMSDataDictionary;
@property(nonatomic,strong) NSDictionary *boysIOTFDataDictionary;
@property(nonatomic,strong) NSDictionary *girlsIOTFDataDictionary;
@property(nonatomic,strong) NSDictionary *boysHeightCentilesDictionary;
@property(nonatomic,strong) NSDictionary *girlsHeightCentilesDictionary;
@property(nonatomic,strong) NSDictionary *boysWeightCentilesDictionary;
@property(nonatomic,strong) NSDictionary *girlsWeightCentilesDictionary;
@property(nonatomic,strong) NSDictionary *boysBMICentilesDictionary;
@property(nonatomic,strong) NSDictionary *girlsBMICentilesDictionary;

// @property(nonatomic, strong) NSDictionary *chosenDictionary;

@property(nonatomic,strong) NSArray *boysHeightLMSDataArray;
@property(nonatomic,strong) NSArray *boysWeightLMSDataArray;
@property(nonatomic,strong) NSArray *girlsHeightLMSDataArray;
@property(nonatomic,strong) NSArray *girlsWeightLMSDataArray;
@property(nonatomic,strong) NSArray *boysBMILMSDataArray;
@property(nonatomic,strong) NSArray *girlsBMILMSDataArray;
@property(nonatomic,strong) NSArray *decimalAgesUK90Data;
@property(nonatomic,strong) NSArray *boysIOTFDataArray;
@property(nonatomic,strong) NSArray *girlsIOTFDataArray;
@property(nonatomic,strong) NSArray *boysHeightCentilesArray;
@property(nonatomic,strong) NSArray *girlsHeightCentilesArray;
@property(nonatomic,strong) NSArray *boysWeightCentilesArray;
@property(nonatomic,strong) NSArray *girlsWeightCentilesArray;
@property(nonatomic,strong) NSArray *boysBMICentilesArray;
@property(nonatomic,strong) NSArray *girlsBMICentilesArray;

@property(nonatomic,strong) NSArray *PALfor0to3y;
@property(nonatomic,strong) NSArray *PALfor3to10y;
@property(nonatomic,strong) NSArray *PALfor10to18y;





// --------------- these are the BMI/Height/Weight methods ---------------------

-(NSNumber*) calculateDecimalAgeFromDOB: (NSDate*)dateOfBirth usingClinicDate: (NSDate*)clinicDate;

-(NSString*) calendarAgeFromDOB:(NSDate*)dateOfBirth usingClinicDate: (NSDate*) clinicDate;

-(NSNumber*) calculateBMIFromHeight: (NSNumber*)height andWeight:(NSNumber*)weight;

-(NSMutableArray*)calculateSDSandCentileAndPctmBMIandExpectedWeightsFromDecimalAge:(NSNumber*)decimalAge andSex:(NSString*)sex andHeight:(NSNumber*)height andWeight:(NSNumber*)weight andBMI:(NSNumber*)bMI;

-(double)convertZScoreToCentile:(double)zScore;

- (NSNumber*) calculateExpectedWeightFromHeight:(NSNumber*)height andBMI:(NSNumber*)bmi;




// ******** these are the private methods ***********

-(NSDate*)setDateToMidnight:(NSDate*)dateToReset;

-(NSArray*)loadUpPListsIntoArrayUsingSex: (NSString*)sex andParameter:(NSString*)heightWeightBMI;

-(NSDictionary*)loadUpPListsIntoDictionaryUsingSex: (NSString*)sex andParameter:(NSString*)heightWeightBMI;

-(NSNumber*) returnLinearInterpolatedParameter:(NSString*)LMS FromLowerDictionary: (NSDictionary*)lowerLMSDictionary andUpperDictionary:(NSDictionary*)upperLMSDictionary andDecimalAge: (NSNumber*)decimalAge;

-(double)cubicInterpolationOfParameter:(NSString*)parameter FromAge:(double)decimalAge andAgeBelow:(double)ageOneBelow andSecondAgeBelow: (double)ageTwoBelow andAgeOneAbove : (double)ageOneAbove andAgeTwoAbove: (double) ageTwoAbove andParameterTwoBelowDictionary: (NSDictionary*) parameterTwoBelowDictionary andParameterOneBelowDictionary: (NSDictionary*) parameterOneBelowDictionary andParameterOneAboveDictionary:(NSDictionary*)parameterOneAboveDictionary andParameterTwoAboveDictionary:(NSDictionary*)parameterTwoAboveDictionary;

-(NSNumber*) calculateSDSFromL:(double)myL andM:(double)myM andS:(double)myS andActualMeasurement:(NSNumber*)measurement;

-(NSNumber*) calculatemBMIfromM:(double)myM andActualBMI:(NSNumber*)measurement;

-(NSNumber*) calculateBMIForAgeForCentile:(double)centileValueAsP andL:(double)myL andM:(double)myM andS:(double)myS andActualBMI:(NSNumber*)measurement;

-(NSNumber*)weightForPercentage:(double)percentage fromHeight: (NSNumber*)height andMedianBMI:(NSNumber*)mBMI;

// ------------------------- IOTF Methods ----------------------

//********** public methods
-(NSArray *)returnGradeOfThinnessOrObesityCuttOffFromReferenceDataUsingSex:(NSString*)sex andAge:(NSNumber*)decimalAge andBMI:(NSNumber*)bMI;

// ********** private methods

-(NSDictionary*)loadUpIOTFPListsIntoDictionaryUsingSex: (NSString*)sex;

-(NSArray*)loadUpIOTFPListsIntoArrayUsingSex: (NSString*)sex;

-(NSArray*)returnIOTFCutOffsForParameterDictionary:(NSDictionary*)parameterDictionary andParameterArray: (NSArray*)parameterArray usingDecimalAge:(NSNumber*)theDecimalAge;





// body surface area methods

-(NSNumber*) calculateMostellerBodySurfaceAreaFromHeight: (NSNumber*)height andWeight:(NSNumber*)weight;



// harris-benedict

-(NSNumber*) calculateHarrisBenedictBMRFromHeight:(NSNumber*)height andWeight:(NSNumber*)weight andSex:(NSString*)sex andAge:(NSNumber*)decimalAge;

-(NSNumber*) calculateBMRForLevelOfActivityUsingHarrisBenedict: (NSNumber*)harrisBenedict andActivityLevel:(NSNumber*)scale1to5;


// henry

-(NSNumber*)returnHenryBMRFromWeight:(NSNumber*)weight andAge:(NSNumber*)age andSex:(NSString*)sex;

//schofield

-(NSNumber*)returnSchofieldBMRFromWeight:(NSNumber*)weight andAge:(NSNumber*)age andSex:(NSString*)sex;

//PALs

-(NSNumber*)returnAdjustedBMRForPredictedActivityLevel:(NSNumber*)activityLevel1to5 andSex:(NSString*)sex andRawSchofield:(NSNumber*)rawSchofield andBMRScore:(NSString*)schofieldHenry;

// growth chart plotting methods

-(NSDictionary*)returnCentilesForGivenParameter:(NSString*)parameter andSex: (NSString*)sex;

-(NSArray*)returnArrayOfCentilesForGivenParameter:(NSString*)parameter andSex: (NSString*)sex;

-(NSMutableDictionary*) returnCentileDataForIndividualCentiles:(NSArray*) arrayOfCentile UsingParameter:(NSString*)parameter andSex:(NSString*)sex ;

-(NSMutableArray*) returnArrayOfIOTFValuesForGivenIOTFCutOff: (NSString*)iOTFCutOff fromIOTFDictionary:(NSDictionary*)iOTFDictionary andIOTFArray:(NSArray*)iOTFArray;

@end
