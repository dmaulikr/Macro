//
//  Player.m
//  Macro
//
//  Created by Ryan Hart on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "Unit.h"
#import "Structure.h"
#import "Worker.h"

@implementation Player

@synthesize minerals;
@synthesize gas;
@synthesize structures;
@synthesize units;
@synthesize species;
@synthesize inProgressStructures;

-(id)initWithSpecies:(SpeciesType)type{
    if (self = [super init]){
    
        species = type;
        self.structures = [NSMutableArray arrayWithObjects: nil];
        self.units = [NSMutableArray arrayWithObjects: nil];
        self.inProgressStructures = [NSMutableArray arrayWithObjects:nil];
        
    }
    return self;
}

-(void)addStructure:(Structure*)structure{
    [structure setOwner:self];
    [self.structures addObject:structure];
}

-(void)addUnit:(Unit*)unit{
    BOOL isFinishedUnit = NO;
    for (Structure *structure in self.structures){
        if ([structure.inProgressUnits containsObject:unit]){
            isFinishedUnit = YES;
        }
    }
    
    if (([self currentSupply] + [unit supplyCost]) <= [self maximumSupply] || isFinishedUnit){
        [unit setOwner:self];
        [self.units addObject:unit];
    }else{
        //You can't build that unit.  Insufficient supply
    }
}

-(void)initializeForBasicGame{
    
    [self addStructure:[Species baseForSpecies:self.species]];
    
    for (int i = 0; i < BasicGame_InitialWorkers; i++){
        Worker *worker = [Species workerForSpecies:self.species];
        [worker setIsBuilding:NO];
        [worker setType:MineralWorker];
        [self addUnit:worker];
    }
    
    self.minerals = 50;
    self.gas = 0;
    
}

-(void)update:(CFTimeInterval)interval{
    NSLog(@"Game Update");
    for (Unit *unit in self.units){
        [unit update:interval];
    }
    for (Structure *structure in self.structures){
        [structure update:interval];
    }
}

-(NSInteger)currentSupply{
    NSInteger currentSupply = 0;
    for (Unit* unit in self.units){
        currentSupply += unit.supplyCost;
    }
    
    for (Structure *structure in self.structures){
        for (Unit *inProgressUnit in structure.inProgressUnits){
            currentSupply += inProgressUnit.supplyCost;
        }
    }
    return currentSupply;
}

-(NSInteger)maximumSupply{
    NSInteger maxSupply = 0;
    for (Structure *structure in self.structures){
        maxSupply += structure.maximumSupplyContribution;
    }
    
    for (Unit *unit in self.units){
        maxSupply += unit.maximumSupplyContribution;
    }
    return maxSupply;
}
@end
