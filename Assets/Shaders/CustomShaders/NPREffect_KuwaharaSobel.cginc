#ifndef NPR_EFFECT_KUWAHARA_SOBEL_INCLUDED
#define NPR_EFFECT_KUWAHARA_SOBEL_INCLUDED

// Combined Kuwahara painterly filter + Gaussian-prefiltered Sobel edge detection.
// Step 1 — Kuwahara: 9 shared texture samples across 4 overlapping quadrants;
//           the mean of the lowest-variance quadrant is blended over the lit colour.
// Step 2 — Gaussian Sobel: each of 8 Sobel positions is pre-blurred with a 9-tap
//           Gaussian, then gradient magnitude drives edge line compositing.
// Requires ENABLE_NPR_EDGES + EFFECT_KUWAHARA_SOBEL keywords.

float4 _InnerLineColor;
float  _KSKuwaharaRadius;    // Kuwahara UV offset  (0.5-8,  x0.001)
float  _KSKuwaharaStrength;  // Kuwahara blend      (0-1)
float  _KSSobelSampleDist;   // Sobel kernel offset (0-10, x0.001)
float  _KSBlurRadius;        // Gaussian tap offset (0-5,  x0.001)
float  _KSThreshold;         // Edge threshold      (0-0.5)
float  _KSSobelStrength;     // Edge line opacity   (0-1)

float KS_GaussianLuma(float2 center, float blurR)
{
    float3 L = float3(0.299, 0.587, 0.114);
    float  v = 0.0;
    v += dot(tex2D(u_BaseColorSampler, center).rgb,                                 L) * 0.25;
    v += dot(tex2D(u_BaseColorSampler, center + float2( blurR,     0)).rgb,         L) * 0.125;
    v += dot(tex2D(u_BaseColorSampler, center + float2(-blurR,     0)).rgb,         L) * 0.125;
    v += dot(tex2D(u_BaseColorSampler, center + float2(     0,  blurR)).rgb,        L) * 0.125;
    v += dot(tex2D(u_BaseColorSampler, center + float2(     0, -blurR)).rgb,        L) * 0.125;
    v += dot(tex2D(u_BaseColorSampler, center + float2( blurR,  blurR)).rgb,        L) * 0.0625;
    v += dot(tex2D(u_BaseColorSampler, center + float2(-blurR,  blurR)).rgb,        L) * 0.0625;
    v += dot(tex2D(u_BaseColorSampler, center + float2( blurR, -blurR)).rgb,        L) * 0.0625;
    v += dot(tex2D(u_BaseColorSampler, center + float2(-blurR, -blurR)).rgb,        L) * 0.0625;
    return v;
}

float4 ApplyNPREffect(float4 color, float2 uv, half3 worldNormal, half3 worldViewDir)
{
    // ── Kuwahara: 9 shared samples, 4 overlapping 2x2 quadrants ─────────────
    float r = _KSKuwaharaRadius * 0.001;

    float4 c00 = tex2D(u_BaseColorSampler, uv + float2(-r, -r));
    float4 c10 = tex2D(u_BaseColorSampler, uv + float2( 0, -r));
    float4 c20 = tex2D(u_BaseColorSampler, uv + float2( r, -r));
    float4 c01 = tex2D(u_BaseColorSampler, uv + float2(-r,  0));
    float4 c11 = tex2D(u_BaseColorSampler, uv                  );
    float4 c21 = tex2D(u_BaseColorSampler, uv + float2( r,  0));
    float4 c02 = tex2D(u_BaseColorSampler, uv + float2(-r,  r));
    float4 c12 = tex2D(u_BaseColorSampler, uv + float2( 0,  r));
    float4 c22 = tex2D(u_BaseColorSampler, uv + float2( r,  r));

    float4 mTL = (c00 + c10 + c01 + c11) * 0.25;
    float4 mTR = (c10 + c20 + c11 + c21) * 0.25;
    float4 mBL = (c01 + c11 + c02 + c12) * 0.25;
    float4 mBR = (c11 + c21 + c12 + c22) * 0.25;

    float vTL = dot(c00.rgb-mTL.rgb, c00.rgb-mTL.rgb) + dot(c10.rgb-mTL.rgb, c10.rgb-mTL.rgb)
              + dot(c01.rgb-mTL.rgb, c01.rgb-mTL.rgb) + dot(c11.rgb-mTL.rgb, c11.rgb-mTL.rgb);
    float vTR = dot(c10.rgb-mTR.rgb, c10.rgb-mTR.rgb) + dot(c20.rgb-mTR.rgb, c20.rgb-mTR.rgb)
              + dot(c11.rgb-mTR.rgb, c11.rgb-mTR.rgb) + dot(c21.rgb-mTR.rgb, c21.rgb-mTR.rgb);
    float vBL = dot(c01.rgb-mBL.rgb, c01.rgb-mBL.rgb) + dot(c11.rgb-mBL.rgb, c11.rgb-mBL.rgb)
              + dot(c02.rgb-mBL.rgb, c02.rgb-mBL.rgb) + dot(c12.rgb-mBL.rgb, c12.rgb-mBL.rgb);
    float vBR = dot(c11.rgb-mBR.rgb, c11.rgb-mBR.rgb) + dot(c21.rgb-mBR.rgb, c21.rgb-mBR.rgb)
              + dot(c12.rgb-mBR.rgb, c12.rgb-mBR.rgb) + dot(c22.rgb-mBR.rgb, c22.rgb-mBR.rgb);

    float4 best = mTL; float bv = vTL;
    if (vTR < bv) { best = mTR; bv = vTR; }
    if (vBL < bv) { best = mBL; bv = vBL; }
    if (vBR < bv) { best = mBR; }

    color.rgb = lerp(color.rgb, best.rgb, _KSKuwaharaStrength);

    // ── Gaussian Sobel: 8 positions each pre-blurred with 9-tap Gaussian ────
    float off  = _KSSobelSampleDist * 0.001;
    float blur = _KSBlurRadius      * 0.001;

    float tl = KS_GaussianLuma(uv + float2(-off,  off), blur);
    float t  = KS_GaussianLuma(uv + float2(   0,  off), blur);
    float tr = KS_GaussianLuma(uv + float2( off,  off), blur);
    float l  = KS_GaussianLuma(uv + float2(-off,    0), blur);
    float ri = KS_GaussianLuma(uv + float2( off,    0), blur);
    float bl = KS_GaussianLuma(uv + float2(-off, -off), blur);
    float b  = KS_GaussianLuma(uv + float2(   0, -off), blur);
    float br = KS_GaussianLuma(uv + float2( off, -off), blur);

    float sobelX  = (tr + 2.0*ri + br) - (tl + 2.0*l + bl);
    float sobelY  = (tl + 2.0*t  + tr) - (bl + 2.0*b + br);
    float edgeMag = sqrt(sobelX*sobelX + sobelY*sobelY);

    float edge = smoothstep(_KSThreshold * 0.5, _KSThreshold * 1.5, edgeMag);
    edge = smoothstep(0.2, 0.8, edge);
    edge *= _KSSobelStrength;

    color.rgb = lerp(color.rgb, _InnerLineColor.rgb, edge);
    return color;
}

#endif // NPR_EFFECT_KUWAHARA_SOBEL_INCLUDED
