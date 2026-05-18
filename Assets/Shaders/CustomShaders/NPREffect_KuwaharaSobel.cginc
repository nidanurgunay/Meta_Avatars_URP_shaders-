#ifndef NPR_EFFECT_KUWAHARA_SOBEL_INCLUDED
#define NPR_EFFECT_KUWAHARA_SOBEL_INCLUDED

// Combined Kuwahara painterly filter + full Gaussian-prefiltered Sobel edge detection.
// Step 1 — Kuwahara: 9 shared texture samples across 4 overlapping quadrants;
//           the mean of the lowest-variance quadrant is blended over the lit colour.
// Step 2 — Gaussian Sobel (full pipeline): optional configurable-weight 9-tap Gaussian
//           pre-blur at each of 8 Sobel positions; threshold band → 4× progressive
//           smoothstep → power curve → opacity.
// Requires ENABLE_NPR_EDGES + EFFECT_KUWAHARA_SOBEL keywords.

float4 _InnerLineColor;
float  _KSKuwaharaRadius;    // Kuwahara UV offset            (0.5–8, × 0.001)
float  _KSKuwaharaStrength;  // Kuwahara blend                (0–1)
float  _KSEnableGaussBlur;   // 1 = 9-tap Gaussian pre-blur, 0 = point sample
float  _KSSobelSampleDist;   // Sobel kernel UV offset        (0–10, × 0.001)
float  _KSBlurRadius;        // Per-sample Gaussian blur radius (0–5, × 0.001)
float  _KSCenterWeight;      // Gaussian center tap weight    (0.1–0.5)
float  _KSCardinalWeight;    // Gaussian cardinal tap weight  (0–0.3)
float  _KSDiagonalWeight;    // Gaussian diagonal tap weight  (0–0.1)
float  _KSThreshold;         // Sobel threshold base          (0–0.5)
float  _KSThreshMin;         // Threshold band lower multiplier (0–1)
float  _KSThreshMax;         // Threshold band upper multiplier (1–5)
float  _KSTightness;         // 0 = wide/soft → 1 = tight/crisp (4 smoothstep passes)
float  _KSPowerCurve;        // Post-pass power curve         (0.5–5)
float  _KSSobelStrength;     // Edge line opacity             (0–1)

float KS_GaussianLuma(float2 center, float blurR, float cW, float cardW, float diagW)
{
    float3 L = float3(0.299, 0.587, 0.114);
    float  v = 0.0;
    v += dot(tex2D(u_BaseColorSampler, center).rgb,                                L) * cW;
    v += dot(tex2D(u_BaseColorSampler, center + float2( blurR,     0)).rgb,        L) * cardW;
    v += dot(tex2D(u_BaseColorSampler, center + float2(-blurR,     0)).rgb,        L) * cardW;
    v += dot(tex2D(u_BaseColorSampler, center + float2(    0,  blurR)).rgb,        L) * cardW;
    v += dot(tex2D(u_BaseColorSampler, center + float2(    0, -blurR)).rgb,        L) * cardW;
    v += dot(tex2D(u_BaseColorSampler, center + float2( blurR,  blurR)).rgb,       L) * diagW;
    v += dot(tex2D(u_BaseColorSampler, center + float2(-blurR,  blurR)).rgb,       L) * diagW;
    v += dot(tex2D(u_BaseColorSampler, center + float2( blurR, -blurR)).rgb,       L) * diagW;
    v += dot(tex2D(u_BaseColorSampler, center + float2(-blurR, -blurR)).rgb,       L) * diagW;
    return v;
}

float4 ApplyNPREffect(float4 color, float2 uv, half3 worldNormal, half3 worldViewDir)
{
    // ── Kuwahara: 9 shared samples, 4 overlapping 2×2 quadrants ─────────────
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

    // ── Gaussian Sobel (full pipeline) ───────────────────────────────────────
    float off  = _KSSobelSampleDist * 0.001;
    float blur = _KSBlurRadius      * 0.001;

    float cW, cardW, diagW;
    if (_KSEnableGaussBlur > 0.5)
    {
        float totalW = _KSCenterWeight + 4.0 * _KSCardinalWeight + 4.0 * _KSDiagonalWeight;
        totalW = max(totalW, 0.0001);
        cW    = _KSCenterWeight   / totalW;
        cardW = _KSCardinalWeight / totalW;
        diagW = _KSDiagonalWeight / totalW;
    }
    else { cW = 1.0; cardW = 0.0; diagW = 0.0; }

    float tl = KS_GaussianLuma(uv + float2(-off,  off), blur, cW, cardW, diagW);
    float t  = KS_GaussianLuma(uv + float2(   0,  off), blur, cW, cardW, diagW);
    float tr = KS_GaussianLuma(uv + float2( off,  off), blur, cW, cardW, diagW);
    float l  = KS_GaussianLuma(uv + float2(-off,    0), blur, cW, cardW, diagW);
    float ri = KS_GaussianLuma(uv + float2( off,    0), blur, cW, cardW, diagW);
    float bl = KS_GaussianLuma(uv + float2(-off, -off), blur, cW, cardW, diagW);
    float b  = KS_GaussianLuma(uv + float2(   0, -off), blur, cW, cardW, diagW);
    float br = KS_GaussianLuma(uv + float2( off, -off), blur, cW, cardW, diagW);

    float sobelX  = (tr + 2.0*ri + br) - (tl + 2.0*l + bl);
    float sobelY  = (tl + 2.0*t  + tr) - (bl + 2.0*b + br);
    float edgeMag = sqrt(sobelX*sobelX + sobelY*sobelY);

    float minEdge = _KSThreshold * _KSThreshMin;
    float maxEdge = _KSThreshold * _KSThreshMax;
    float edge    = smoothstep(minEdge, maxEdge, edgeMag);

    float hw1 = lerp(0.5, 0.03, _KSTightness);
    edge = smoothstep(0.5 - hw1, 0.5 + hw1, edge);
    float hw2 = lerp(0.5, 0.15, _KSTightness);
    edge = smoothstep(0.5 - hw2, 0.5 + hw2, edge);
    float hw3 = lerp(0.5, 0.25, _KSTightness);
    edge = smoothstep(0.5 - hw3, 0.5 + hw3, edge);
    float hw4 = lerp(0.5, 0.35, _KSTightness);
    edge = smoothstep(0.5 - hw4, 0.5 + hw4, edge);

    edge = pow(edge, _KSPowerCurve);
    edge *= _KSSobelStrength;

    color.rgb = lerp(color.rgb, _InnerLineColor.rgb, edge);
    return color;
}

#endif // NPR_EFFECT_KUWAHARA_SOBEL_INCLUDED
