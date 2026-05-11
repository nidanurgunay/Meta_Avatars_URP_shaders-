#ifndef NPR_EFFECT_KUWAHARA_GAUSS_HIER_INCLUDED
#define NPR_EFFECT_KUWAHARA_GAUSS_HIER_INCLUDED

// Triple-layer NPR effect:
//   Phase 1 — Kuwahara painterly filter    → stylises base colour
//   Phase 2 — Gaussian Sobel (V4 strategy) → texture/colour edge lines
//   Phase 3 — Hierarchical multi-layer     → depth + normal + colour crease edges
// Phases 2 & 3 are fused with max-pooling, then composited over the Kuwahara colour.
// Requires ENABLE_NPR_EDGES + EFFECT_KUW_GAUSS_HIER keywords.

// ── Kuwahara ─────────────────────────────────────────────────────────────────
float  _KGHKuwaharaRadius;    // UV-space Kuwahara sample offset (0.5–8, × 0.001)
float  _KGHKuwaharaStrength;  // Kuwahara blend (0–1)

// ── Gaussian Sobel ────────────────────────────────────────────────────────────
float  _KGHEnableGaussBlur;   // 1 = 9-tap Gaussian pre-blur, 0 = plain point sample
float  _KGHSampleDist;        // Sobel kernel UV offset (0–10, × 0.001)
float  _KGHBlurRadius;        // Per-sample Gaussian blur radius (0–5, × 0.001)
float  _KGHCenterWeight;      // Gaussian center tap weight (0.1–0.5)
float  _KGHCardinalWeight;    // Gaussian cardinal tap weight (0–0.3)
float  _KGHDiagonalWeight;    // Gaussian diagonal tap weight (0–0.1)
float  _KGHGThreshold;        // Sobel threshold base (0–0.5)
float  _KGHGThreshMin;        // Threshold band lower multiplier (0–1)
float  _KGHGThreshMax;        // Threshold band upper multiplier (1–5)
float  _KGHTightness;         // 0=wide/soft → 1=tight/crisp, drives all 4 passes
float  _KGHGPowerCurve;       // Post-pass power curve (0.5–5)
float  _KGHGStrength;         // Gaussian Sobel edge opacity (0–1)

// ── Hierarchical ──────────────────────────────────────────────────────────────
float  _KGHDepthThreshold;    // Depth gradient threshold (0.001–0.2)
float  _KGHNormalThreshold;   // Normal gradient threshold (0.05–1)
float  _KGHColorThreshold;    // Color gradient threshold (0.01–0.5)
float  _KGHDepthWeight;       // Depth layer blend weight (0–1)
float  _KGHNormalWeight;      // Normal layer blend weight (0–1)
float  _KGHColorWeight;       // Color layer blend weight (0–1)
float  _KGHEdgeWidth;         // Roberts Cross UV offset (0.5–10, × 0.001)
float  _KGHAdaptiveStrength;  // Suppress edges in dark areas (0–1)
float  _KGHHStrength;         // Hierarchical edge opacity (0–1)

// ── Shared ────────────────────────────────────────────────────────────────────
float4 _KGHEdgeColor;         // Combined edge colour (default black)

// 9-tap Gaussian luminance — weights are pre-normalised at the call site
float KGH_GaussianLuma(float2 center, float blurR, float cW, float cardW, float diagW)
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
    // ── Phase 1: Kuwahara painterly filter ───────────────────────────────────
    float r = _KGHKuwaharaRadius * 0.001;

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

    color.rgb = lerp(color.rgb, best.rgb, _KGHKuwaharaStrength);

    // ── Phase 2: Gaussian Sobel (V4 strategy) ────────────────────────────────
    float off  = _KGHSampleDist * 0.001;
    float blur = _KGHBlurRadius * 0.001;

    float cW, cardW, diagW;
    if (_KGHEnableGaussBlur > 0.5)
    {
        float totalW = _KGHCenterWeight + 4.0 * _KGHCardinalWeight + 4.0 * _KGHDiagonalWeight;
        totalW = max(totalW, 0.0001);
        cW    = _KGHCenterWeight   / totalW;
        cardW = _KGHCardinalWeight / totalW;
        diagW = _KGHDiagonalWeight / totalW;
    }
    else { cW = 1.0; cardW = 0.0; diagW = 0.0; }

    float tl = KGH_GaussianLuma(uv + float2(-off,  off), blur, cW, cardW, diagW);
    float t  = KGH_GaussianLuma(uv + float2(   0,  off), blur, cW, cardW, diagW);
    float tr = KGH_GaussianLuma(uv + float2( off,  off), blur, cW, cardW, diagW);
    float l  = KGH_GaussianLuma(uv + float2(-off,    0), blur, cW, cardW, diagW);
    float ri = KGH_GaussianLuma(uv + float2( off,    0), blur, cW, cardW, diagW);
    float bl = KGH_GaussianLuma(uv + float2(-off, -off), blur, cW, cardW, diagW);
    float b  = KGH_GaussianLuma(uv + float2(   0, -off), blur, cW, cardW, diagW);
    float br = KGH_GaussianLuma(uv + float2( off, -off), blur, cW, cardW, diagW);

    float sobelX  = (tr + 2*ri + br) - (tl + 2*l + bl);
    float sobelY  = (tl + 2*t  + tr) - (bl + 2*b + br);
    float edgeMag = sqrt(sobelX*sobelX + sobelY*sobelY);

    float minEdge = _KGHGThreshold * _KGHGThreshMin;
    float maxEdge = _KGHGThreshold * _KGHGThreshMax;
    float gEdge   = smoothstep(minEdge, maxEdge, edgeMag);

    float hw1 = lerp(0.5, 0.03, _KGHTightness);
    gEdge = smoothstep(0.5 - hw1, 0.5 + hw1, gEdge);
    float hw2 = lerp(0.5, 0.15, _KGHTightness);
    gEdge = smoothstep(0.5 - hw2, 0.5 + hw2, gEdge);
    float hw3 = lerp(0.5, 0.25, _KGHTightness);
    gEdge = smoothstep(0.5 - hw3, 0.5 + hw3, gEdge);
    float hw4 = lerp(0.5, 0.35, _KGHTightness);
    gEdge = smoothstep(0.5 - hw4, 0.5 + hw4, gEdge);

    gEdge = pow(gEdge, _KGHGPowerCurve);
    gEdge *= _KGHGStrength;

    // ── Phase 3: Hierarchical edge detection ─────────────────────────────────
    float depth     = length((float3)worldViewDir);
    float dDepthX   = ddx(depth);
    float dDepthY   = ddy(depth);
    float depthGrad = sqrt(dDepthX*dDepthX + dDepthY*dDepthY);
    float depthLine = smoothstep(_KGHDepthThreshold - 0.005,
                                 _KGHDepthThreshold + 0.005, depthGrad);

    float3 dNdx    = ddx((float3)worldNormal);
    float3 dNdy    = ddy((float3)worldNormal);
    float normGrad = sqrt(dot(dNdx, dNdx) + dot(dNdy, dNdy));
    float normLine = smoothstep(_KGHNormalThreshold - 0.02,
                                _KGHNormalThreshold + 0.02, normGrad);

    float hoff    = _KGHEdgeWidth * 0.001;
    float3 Lc     = float3(0.299, 0.587, 0.114);
    float lum_tl  = dot(tex2D(u_BaseColorSampler, uv + float2(-hoff,  hoff)).rgb, Lc);
    float lum_tr  = dot(tex2D(u_BaseColorSampler, uv + float2( hoff,  hoff)).rgb, Lc);
    float lum_bl  = dot(tex2D(u_BaseColorSampler, uv + float2(-hoff, -hoff)).rgb, Lc);
    float lum_br  = dot(tex2D(u_BaseColorSampler, uv + float2( hoff, -hoff)).rgb, Lc);
    float colGrad = abs(lum_tl - lum_br) + abs(lum_tr - lum_bl);
    float colLine = smoothstep(_KGHColorThreshold - 0.01,
                               _KGHColorThreshold + 0.01, colGrad);

    float brightness = dot(color.rgb, float3(0.2126, 0.7152, 0.0722));
    float adapt      = lerp(1.0, saturate(brightness * 2.0), _KGHAdaptiveStrength);
    depthLine *= adapt;
    colLine   *= adapt;
    normLine  *= lerp(1.0, adapt, 0.5);

    float hEdge = max(depthLine * _KGHDepthWeight,
                  max(normLine  * _KGHNormalWeight,
                      colLine   * _KGHColorWeight));
    hEdge = smoothstep(0.20, 0.55, hEdge);
    hEdge *= _KGHHStrength;

    // ── Fusion: max-pool Gaussian Sobel and Hierarchical, apply to colour ─────
    float edge = max(gEdge, hEdge);
    color.rgb  = lerp(color.rgb, _KGHEdgeColor.rgb, edge);
    return color;
}

#endif // NPR_EFFECT_KUWAHARA_GAUSS_HIER_INCLUDED
