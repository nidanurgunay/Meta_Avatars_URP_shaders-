#ifndef NPR_EFFECT_KUWAHARA_INCLUDED
#define NPR_EFFECT_KUWAHARA_INCLUDED

// Classic 3x3 Kuwahara painterly filter adapted for the Meta Avatar shader.
// Samples a 3x3 grid of the base colour texture (9 lookups total, shared across
// 4 overlapping quadrants). Outputs the mean of the quadrant with lowest variance,
// producing a painterly / oil-painting abstraction effect.
//
// Full anisotropic Kuwahara (Kyprianidis 2009) requires a multi-pass structure
// tensor which is impossible in a single fragment hook, so this uses the classic
// isotropic formulation. The look is subtler but runs cheaply on Quest hardware.
// Requires ENABLE_NPR_EDGES + EFFECT_KUWAHARA keywords.

float _KuwaharaRadius;    // UV-space sample distance (0.5–8, × 0.001)
float _KuwaharaStrength;  // Blend with original colour (0–1)

float4 ApplyNPREffect(float4 color, float2 uv, half3 worldNormal, half3 worldViewDir)
{
    float r = _KuwaharaRadius * 0.001;

    // Sample the full 3×3 neighbourhood once — positions reused across quadrants.
    float4 c00 = tex2D(u_BaseColorSampler, uv + float2(-r, -r));
    float4 c10 = tex2D(u_BaseColorSampler, uv + float2( 0, -r));
    float4 c20 = tex2D(u_BaseColorSampler, uv + float2( r, -r));
    float4 c01 = tex2D(u_BaseColorSampler, uv + float2(-r,  0));
    float4 c11 = tex2D(u_BaseColorSampler, uv                  );
    float4 c21 = tex2D(u_BaseColorSampler, uv + float2( r,  0));
    float4 c02 = tex2D(u_BaseColorSampler, uv + float2(-r,  r));
    float4 c12 = tex2D(u_BaseColorSampler, uv + float2( 0,  r));
    float4 c22 = tex2D(u_BaseColorSampler, uv + float2( r,  r));

    // Each quadrant shares an edge with its neighbours — classic 2×2 overlap.
    // TL: c00 c10 c01 c11
    // TR: c10 c20 c11 c21
    // BL: c01 c11 c02 c12
    // BR: c11 c21 c12 c22
    float4 mTL = (c00 + c10 + c01 + c11) * 0.25;
    float4 mTR = (c10 + c20 + c11 + c21) * 0.25;
    float4 mBL = (c01 + c11 + c02 + c12) * 0.25;
    float4 mBR = (c11 + c21 + c12 + c22) * 0.25;

    // Variance = sum of squared colour distances from the quadrant mean.
    float vTL = dot(c00.rgb-mTL.rgb, c00.rgb-mTL.rgb) + dot(c10.rgb-mTL.rgb, c10.rgb-mTL.rgb)
              + dot(c01.rgb-mTL.rgb, c01.rgb-mTL.rgb) + dot(c11.rgb-mTL.rgb, c11.rgb-mTL.rgb);
    float vTR = dot(c10.rgb-mTR.rgb, c10.rgb-mTR.rgb) + dot(c20.rgb-mTR.rgb, c20.rgb-mTR.rgb)
              + dot(c11.rgb-mTR.rgb, c11.rgb-mTR.rgb) + dot(c21.rgb-mTR.rgb, c21.rgb-mTR.rgb);
    float vBL = dot(c01.rgb-mBL.rgb, c01.rgb-mBL.rgb) + dot(c11.rgb-mBL.rgb, c11.rgb-mBL.rgb)
              + dot(c02.rgb-mBL.rgb, c02.rgb-mBL.rgb) + dot(c12.rgb-mBL.rgb, c12.rgb-mBL.rgb);
    float vBR = dot(c11.rgb-mBR.rgb, c11.rgb-mBR.rgb) + dot(c21.rgb-mBR.rgb, c21.rgb-mBR.rgb)
              + dot(c12.rgb-mBR.rgb, c12.rgb-mBR.rgb) + dot(c22.rgb-mBR.rgb, c22.rgb-mBR.rgb);

    // Select the most uniform (lowest variance) quadrant.
    float4 best = mTL; float bv = vTL;
    if (vTR < bv) { best = mTR; bv = vTR; }
    if (vBL < bv) { best = mBL; bv = vBL; }
    if (vBR < bv) { best = mBR; }

    color.rgb = lerp(color.rgb, best.rgb, _KuwaharaStrength);
    return color;
}

#endif // NPR_EFFECT_KUWAHARA_INCLUDED
