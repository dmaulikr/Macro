//
//  Species.m
//  Macro
//
//  Created by Ryan Hart on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Species.h"

#import "Physical.h"
#import "Player.h"

//Bugs
#import "BugWorker.h"
#import "BugBase.h"

//Robots
#import "RobotWorker.h"
#import "RobotBase.h"

//Humans
#import "HumanBase.h"
#import "HumanWorker.h"
#import "HumanSupplyDepot.h"
#import "HumanBarracks.h"
#import "HumanMarine.h"
#import "HumanFactory.h"
#import "HumanHellion.h"
#import "HumanMarauder.h"

@interface Species ()
+(NSArray*)bugUnitsFromStructure:(Structure*)structure;
+(NSArray*)humanUnitsFromStructure:(Structure*)structure;
+(NSMutableArray*)removePhysicalsUnavailableToPlayer:(Player*)player fromArray:(NSMutableArray*)array;
@end

@implementation Species

+(Worker*)workerForSpecies:(SpeciesType)type{
    Worker *workerToReturn = nil;
    switch (type) {
        case Bugs:
            workerToReturn = (Worker*)[[BugWorker alloc] init];
            break;
        case Humans:
            workerToReturn = (Worker*)[[HumanWorker alloc] init];
            break;
        case Robots:
            workerToReturn = (Worker*)[[RobotWorker alloc] init];
            break;
        default:
            break;
    }
    return [workerToReturn autorelease];
}

+(Structure*)baseForSpecies:(SpeciesType)type{
    Structure *structureToReturn = nil;
    switch (type) {
        case Bugs:
            structureToReturn = [[BugBase alloc] init];
            break;
        case Humans:
            structureToReturn = [[HumanBase alloc] init];
            break;
        case Robots:
            structureToReturn = [[RobotBase alloc] init];
            break;
        default:
            break;
    }
    return [structureToReturn autorelease];
}

+(NSArray*)availableStructuresForPlayer:(Player*)player{
    NSMutableArray *availableStructures = [NSMutableArray arrayWithCapacity:20];
    switch (player.species) {
        case Bugs:
            break;
        case Humans:
            if ([player hasStructureWithTitle:@"HumanBase"]){
                [availableStructures addObject:[[HumanSupplyDepot new] autorelease]];
                if ([player hasStructureWithTitle:@"HumanSupplyDepot"]){
                    [availableStructures addObject:[[HumanBarracks new] autorelease]];
                }
            }
            if ([player hasStructureWithTitle:@"HumanBarracks"]){
                [availableStructures addObject:[[HumanFactory new] autorelease]];
            }
            break;
        case Robots:
            break;
        default:
            break;
    }
    return availableStructures;
}

+(NSArray*)availableUnitsForPlayer:(Player*)player fromStructure:(Structure*)structure{
    NSMutableArray *availableUnits = nil;
    switch (player.species) {
        case Bugs:
            availableUnits = (NSMutableArray*)[Species bugUnitsFromStructure:structure];
            availableUnits =  [Species removePhysicalsUnavailableToPlayer:player fromArray:availableUnits];
            break;
        case Humans:
            availableUnits = (NSMutableArray*)[Species humanUnitsFromStructure:structure];
            availableUnits =  [Species removePhysicalsUnavailableToPlayer:player fromArray:availableUnits];
            break;
        case Robots:
            break;
        default:
            break;
    }
    return (NSArray*)availableUnits;
}

+(NSMutableArray*)removePhysicalsUnavailableToPlayer:(Player*)player fromArray:(NSMutableArray*)array{
    return array; //Temporarily not enforcing any tech tree dependencies
    for (Physical *physical in array){
        BOOL hasAllDependencies = NO;
        for (NSString* dependency in physical.techDependencies){
            for (Structure *structure in player.structures){
                if ([structure.title isEqualToString:dependency]){
                    hasAllDependencies = YES;
                }
            }
                    
        }
    }
}


#pragma mark Bug Specific
+(NSArray*)bugUnitsFromStructure:(Structure*)structure{
    //Load from a dictionary later
    if ([structure.structureName isEqualToString:@"BugBase"]){
        Worker *gasWorker = [Worker new];
        [gasWorker setTitle:@"Gas Drone"];
        [gasWorker setType:GasWorker];
        Worker *mineralWorker = [Worker new];
        [mineralWorker setTitle:@"Mineral Drone"];
        [mineralWorker setType:MineralWorker];
        return [NSArray arrayWithObjects:[gasWorker autorelease], [mineralWorker autorelease], nil];
    }
    
    return nil;
}

#pragma mark Human Specific

+(NSArray*)humanUnitsFromStructure:(Structure*)structure{
    //Load from a dictionary later
    if ([structure.structureName isEqualToString:@"HumanBase"]){
        Worker *gasWorker = [Worker new];
        [gasWorker setTitle:@"Gas SCV"];
        [gasWorker setType:GasWorker];
        Worker *mineralWorker = [Worker new];
        [mineralWorker setTitle:@"Mineral SCV"];
        [mineralWorker setType:MineralWorker];
        return [NSArray arrayWithObjects:[gasWorker autorelease], [mineralWorker autorelease], nil];
    }
    
    if ([structure.structureName isEqualToString:@"HumanBarracks"]){
        HumanMarine *marine = [HumanMarine new];
        HumanMarauder *marauder = [HumanMarauder new];
        return [NSArray arrayWithObjects:[marine autorelease],[marauder autorelease],nil];
    }
    
    if ([structure.structureName isEqualToString:@"HumanFactory"]){
        HumanHellion *hellion = [HumanHellion new];
        return [NSArray arrayWithObjects:[hellion autorelease], nil];
    }
    
    return nil;
}

#pragma mark Robot Specific
@end
