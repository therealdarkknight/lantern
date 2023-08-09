#include "postgres.h"

#include "distfunc.h"

#include "math.h"

float l2sq_dist_impl(float4 const* ax, float4 const* bx, float4 dim)
{
    float4 distance = 0.0;
    for(size_t i = 0; i < dim; i++) {
        float4 diff = ax[ i ] - bx[ i ];
        distance += diff * diff;
    }
    return distance;
}

float l1_dist_impl(float4 const* ax, float4 const* bx, float4 dim)
{
    float4 distance = 0.0;
    for(size_t i = 0; i < dim; i++) {
        float4 a = ax[ i ];
        float4 b = bx[ i ];
        float4 diff = a > b ? a - b : b - a;
        distance += diff;
    }
    return distance;
}
