//
//  Warp.metal
//  XString
//
//  Created by AeroStar on 17/12/2025.
//

#include <metal_stdlib>
using namespace metal;

// Simple 2D noise
float hash(float2 p) {
    return fract(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
}

float noise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);

    float a = hash(i);
    float b = hash(i + float2(1, 0));
    float c = hash(i + float2(0, 1));
    float d = hash(i + float2(1, 1));

    float2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

[[ stitchable ]]
float2 blobWarp(float2 position, float2 size, float time) {

    // Normalize to center
    float2 center = size * 0.5;
    float2 p = position - center;

    // Rotate the field
    float angle = time * 0.4;
    float s = sin(angle);
    float c = cos(angle);
    p = float2(c * p.x - s * p.y,
               s * p.x + c * p.y);

    // Radial distance
    float r = length(p) / min(size.x, size.y);

    // Animated noise
    float n = noise(p * 0.02 + time * 0.5);

    // Warp strength
    float warp = n * 25.0 * (1.0 - r);

    // Push outward
    float2 direction = normalize(p);
    p += direction * warp;

    return p + center;
}
