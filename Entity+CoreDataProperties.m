//
//  Entity+CoreDataProperties.m
//  
//
//  Created by topsec on 17/1/10.
//
//

#import "Entity+CoreDataProperties.h"

@implementation Entity (CoreDataProperties)

+ (NSFetchRequest<Entity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Entity"];
}

@dynamic uuid;
@dynamic tasktage;
@dynamic imag;

@end
