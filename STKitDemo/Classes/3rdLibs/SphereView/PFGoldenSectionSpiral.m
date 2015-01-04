//This file is part of SphereView.
//
//SphereView is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.
//
//SphereView is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License
//along with SphereView.  If not, see <http://www.gnu.org/licenses/>.

#import "PFGoldenSectionSpiral.h"

@implementation PFGoldenSectionSpiral

+ (NSArray *)sphere:(NSInteger)n {
	NSMutableArray* result = [NSMutableArray arrayWithCapacity:n];
	
	CGFloat N = n;
	CGFloat inc = M_PI * (3 - sqrt(5));
    CGFloat off = 2 / N;
	for (NSInteger k=0; k<N; k++) {
        CGFloat y = k * off - 1 + (off / 2);
        CGFloat r = sqrt(1 - y*y);
        CGFloat phi = k * inc;
		
		
		PFPoint point = PFPointMake(cos(phi)*r, y, sin(phi)*r);
		
		NSValue *v = [NSValue value:&point withObjCType:@encode(PFPoint)];
		
        [result addObject:v];
	}
	
	return result;
}

@end


extern PFRadian PFRadianMake(CGFloat grades) {
    return (M_PI * grades / 180.0);
}

extern PFMatrix PFMatrixTransform3DMakeFromPFPoint(PFPoint point) {
    CGFloat pointRef[1][4] = {{point.x, point.y, point.z, 1}};
    
    PFMatrix matrix = PFMatrixMakeFromArray(1, 4, *pointRef);
    
    return matrix;
}

extern PFMatrix PFMatrixTransform3DMakeTranslation(PFPoint point) {
    CGFloat T[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {point.x, point.y, point.z, 1}
    };
    
    PFMatrix matrix = PFMatrixMakeFromArray(4, 4, *T);
    return matrix;
}

extern PFMatrix PFMatrixTransform3DMakeXRotation(PFRadian angle) {
    CGFloat c = cos(PFRadianMake(angle));
    CGFloat s = sin(PFRadianMake(angle));
    
    CGFloat T[4][4] = {
        {1, 0, 0, 0},
        {0, c, s, 0},
        {0, -s, c, 0},
        {0, 0, 0, 1}
    };
    
    PFMatrix matrix = PFMatrixMakeFromArray(4, 4, *T);
    
    return matrix;
}

extern PFMatrix PFMatrixTransform3DMakeXRotationOnPoint(PFPoint point, PFRadian angle) {
    PFMatrix T = PFMatrixTransform3DMakeTranslation(PFPointMake(-point.x, -point.y, -point.z));
    PFMatrix R = PFMatrixTransform3DMakeXRotation(angle);
    PFMatrix T1 = PFMatrixTransform3DMakeTranslation(point);
    
    return PFMatrixMultiply(PFMatrixMultiply(T, R), T1);
}

extern PFMatrix PFMatrixTransform3DMakeYRotation(PFRadian angle) {
    CGFloat c = cos(PFRadianMake(angle));
    CGFloat s = sin(PFRadianMake(angle));
    
    CGFloat T[4][4] = {
        {c, 0, -s, 0},
        {0, 1, 0, 0},
        {s, 0, c, 0},
        {0, 0, 0, 1}
    };
    
    PFMatrix matrix = PFMatrixMakeFromArray(4, 4, *T);
    
    return matrix;
}

extern PFMatrix PFMatrixTransform3DMakeYRotationOnPoint(PFPoint point, PFRadian angle) {
    PFMatrix T = PFMatrixTransform3DMakeTranslation(PFPointMake(-point.x, -point.y, -point.z));
    PFMatrix R = PFMatrixTransform3DMakeYRotation(angle);
    PFMatrix T1 = PFMatrixTransform3DMakeTranslation(point);
    
    return PFMatrixMultiply(PFMatrixMultiply(T, R), T1);
}

extern PFMatrix PFMatrixTransform3DMakeZRotation(PFRadian angle) {
    CGFloat c = cos(PFRadianMake(angle));
    CGFloat s = sin(PFRadianMake(angle));
    
    CGFloat T[4][4] = {
        {c, s, 0, 0},
        {-s, c, 0, 0},
        {0, 0, 1, 0},
        {0, 0, 0, 1}
    };
    
    PFMatrix matrix = PFMatrixMakeFromArray(4, 4, *T);
    
    return matrix;
}

extern PFMatrix PFMatrixTransform3DMakeZRotationOnPoint(PFPoint point, PFRadian angle) {
    PFMatrix T = PFMatrixTransform3DMakeTranslation(PFPointMake(-point.x, -point.y, -point.z));
    PFMatrix R = PFMatrixTransform3DMakeZRotation(angle);
    PFMatrix T1 = PFMatrixTransform3DMakeTranslation(point);
    
    return PFMatrixMultiply(PFMatrixMultiply(T, R), T1);
}



extern PFMatrix PFMatrixMake(NSInteger m, NSInteger n) {
    PFMatrix matrix;
    matrix.m = m;
    matrix.n = n;
    
    for(NSInteger i=0; i<m; i++){
        for(NSInteger j=0; j<n; j++){
            matrix.data[i][j] = 0;
        }
    }
    
    return matrix;
}

extern PFMatrix PFMatrixMakeFromArray(NSInteger m, NSInteger n, CGFloat *data) {
    PFMatrix matrix = PFMatrixMake(m, n);
    
    for (int i=0; i<m; i++) {
        CGFloat *t = data+(i*sizeof(CGFloat));
        for (int j=0; j<n; j++) {
            matrix.data[i][j] = *(t+j);
        }
    }
    
    return matrix;
}

extern PFMatrix PFMatrixMakeIdentity(NSInteger m, NSInteger n) {
    PFMatrix matrix = PFMatrixMake(m, n);
    
    for(NSInteger i=0; i<m; i++){
        matrix.data[i][i] = 1;
    }
    
    return matrix;
}

extern PFMatrix PFMatrixMultiply(PFMatrix A, PFMatrix B) {
    PFMatrix R = PFMatrixMake(A.m, B.n);
    
    for(NSInteger i=0; i<A.m; i++){
        for(NSInteger j=0; j<B.n; j++){
            for(NSInteger k=0; k < A.n; k++){
                R.data[i][j] += A.data[i][k] * B.data[k][j];
            }
        }
    }
    
    return R;
}

extern NSString *NSStringFromPFMatrix(PFMatrix matrix) {
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"{"];
    for(NSInteger i=0; i<matrix.m; i++){
        [str appendString:@"\n{"];
        for(NSInteger j=0; j<matrix.n; j++){
            [str appendFormat:@"%f",matrix.data[i][j]];
            
            if (j+1 < matrix.n) {
                [str appendString:@","];
            }
        }
        [str appendString:@"}"];
        
        if (i+1 < matrix.m) {
            [str appendString:@","];
        }
    }
    [str appendString:@"\n}"];
    
    return str;
}


extern PFPoint PFPointMake(CGFloat x, CGFloat y, CGFloat z) {
    PFPoint p;
    p.x = x;
    p.y = y;
    p.z = z;
    
    return p;
}

extern PFPoint PFPointMakeFromMatrix(PFMatrix matrix) {
    return PFPointMake(matrix.data[0][0], matrix.data[0][1], matrix.data[0][2]);
}

extern NSString *NSStringFromPFPoint(PFPoint point) {
    NSString *str = [NSString stringWithFormat:@"(%f,%f,%f)", point.x, point.y, point.z];
    
    return str;
}


#pragma mark -
#pragma mark CGPoint methods

extern CGPoint CGPointMakeNormalizedPoint(CGPoint point, CGFloat distance) {
    CGPoint nPoint = CGPointMake(point.x * 1/distance, point.y * 1/distance);
    
    return nPoint;
}



extern PFAxisDirection PFAxisDirectionMake(CGFloat fromCoordinate, CGFloat toCoordinate, BOOL sensitive) {
    PFAxisDirection direction = PFAxisDirectionNone;
    
    CGFloat distance = fabs(fromCoordinate - toCoordinate);
				
    if (distance > PFAxisDirectionMinimumDistance || sensitive) {
        if (fromCoordinate > toCoordinate) {
            direction = PFAxisDirectionPositive;
        } else if (fromCoordinate < toCoordinate) {
            direction = PFAxisDirectionNegative;
        }
    }
    
    return direction;
}

extern PFAxisDirection PFDirectionMakeXAxis(CGPoint fromPoint, CGPoint toPoint) {
    return PFAxisDirectionMake(fromPoint.x, toPoint.x, NO);
}

extern PFAxisDirection PFDirectionMakeYAxis(CGPoint fromPoint, CGPoint toPoint) {
    return PFAxisDirectionMake(fromPoint.y, toPoint.y, NO);
}

extern PFAxisDirection PFDirectionMakeXAxisSensitive(CGPoint fromPoint, CGPoint toPoint) {
    return PFAxisDirectionMake(fromPoint.x, toPoint.x, YES);
}

extern PFAxisDirection PFDirectionMakeYAxisSensitive(CGPoint fromPoint, CGPoint toPoint) {
    return PFAxisDirectionMake(fromPoint.y, toPoint.y, YES);
}

