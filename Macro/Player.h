//
//  Player.h
//  Macro
//
//  Created by Ryan Hart on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Species.h"

@class Structure;
@class Unit;

#define BasicGame_InitialWorkers 6
#define BasicGame_InitialMinerals 50
#define BasicGame_MaximumSupply 200

@interface Player : NSObject

@property (readonly) SpeciesType species;
@property (nonatomic) NSInteger minerals;
@property (nonatomic) NSInteger gas;
@property (nonatomic, retain) NSMutableArray *inProgressStructures;
@property (nonatomic, retain) NSMutableArray *structures;
@property (nonatomic, retain) NSMutableArray *units;

//Structure sorting
@property (nonatomic, readonly) NSArray *productionFacilities;
@property (nonatomic, readonly) NSArray *infrastructure;

-(id)initWithSpecies:(SpeciesType)type;

-(void)buildStructure:(Structure*)structure;

-(void)addStructure:(Structure*)structure;
-(void)addUnit:(Unit*)unit;

-(void)initializeForBasicGame;

-(NSInteger)currentSupply;
-(NSInteger)maximumSupply;
-(NSInteger)numberOfWorkers;
-(NSArray*)army;

-(BOOL)hasStructureWithTitle:(NSString*)title;
-(NSUInteger)structuresWithTitle:(NSString*)title;

-(void)update:(CFTimeInterval)interval;
@end
