#ifndef NPR_EFFECT_KUWAHARA_GAUSS_HIER_INCLUDED
#define NPR_EFFECT_KUWAHARA_GAUSS_HIER_INCLUDED

// Two-phase NPR effect:
//   Phase 1 — Kuwahara painterly filter    → stylises base colour
//   Phase 2 — Hierarchical multi-layer     → depth + normal + colour crease edges
//              (colour layer supports optional Gaussian pre-blur)
// Requires ENABLE_NPR_EDGES + EFFECT_KUW_GAUSS_HIER keywords.

// ── Kuwahara ─────────────────────────────────────────────────────────────────
float  _KGHKuwaharaRadius;    // UV-space Kuwahara sample offset (0.5–8, × 0.001)
float  _KGHKuwaharaStrength;  // Kuwahara blend (0–1)

// ── Hierarchical ──────────────────────────────────────────────────────────────
float  _KGHDepthThreshold;    // Depth gradient threshold    (0.001–0.2)
float  _KGHNormalThreshold;   // Normal gradient threshold   (0.05–1)
float  _KGHColorThreshold;    // Color gradient threshold    (0.01–0.5)
float  _KGHDepthWeight;       // Depth layer blend weight    (0–1)
float  _KGHNormalWeight;      // Normal layer blend weight   (0–1)
float  _KGHColorWeight;       // Color layer blend weight    (0–1)
float  _KGHEdgeWidth;         // Roberts Cross UV offset     (0.5–10, × 0.001)
float  _KGHAdaptiveStrength;  // Suppress edges in dark areas (0–1)
float  _KGHHierTightness;     // 0 = soft/wide, 1 = crisp/thin
float  _KGHHStrength;         // Hierarchical edge opacity   (0–1)

// ── Colour layer optional Gaussian blur ──────────────────────────────────────
float  _KGHEnableGaussBlur;   // 1 = Gaussian pre-blur on colour samples, 0 = point sample
float  _KGHBlurRadius;        // Gaussian blur radius        (0–5, × 0.001)
float  _KGHCenterWeight;      // Gaussian centre tap weight  (0.1–0.5)
float  _KGHCardinalWeight;    // Gaussian cardinal tap weight (0–0.3)
float  _KGHDiagonalWeight;    // Gaussian diagonal tap weight (0–0.1)

// ── Shared ────────────────────────────────────────────────────────────────────
float4 _KGHEdgeColor;         // Edge colour

// Luminance of one colour sample — point or 9-tap Gaussian pre-blur.
float KH_ColorSample(float2 uv)
{
    float3 L = float3(0.299, 0.587, 0.114);
    float v;
    if (_KGHEnableGaussBlur > 0.5)
    {
        float totalW = _KGHCenterWeight + 4.0 * _KGHCardinalWeight + 4.0 * _KGHDiagonalWeight;
        totalW = max(totalW, 0.0001);
        float cW    = _KGHCenterWeight   / totalW;
        float cardW = _KGHCardinalWeight / totalW;
        float diagW = _KGHDiagonalWeight / totalW;
        float br    = _KGHBlurRadius * 0.001;
        v  = dot(tex2D(u_BaseColorSampler, uv).rgb,                               L) * cW;
        v += dot(tex2D(u_BaseColorSampler, uv + float2( br,  0)).rgb,             L) * cardW;
        v += dot(tex2D(u_BaseColorSampler, uv + float2(-br,  0)).rgb,             L) * cardW;
        v += dot(tex2D(u_BaseColorSampler, uv + float2(  0, br)).rgb,             L) * cardW;
        v += dot(tex2D(u_BaseColorSampler, uv + float2(  0,-br)).rgb,             L) * cardW;
        v += dot(tex2D(u_BaseColorSampler, uv + float2( br, br)).rgb,             L) * diagW;
        v += dot(tex2D(u_BaseColorSampler, uv + float2(-br, br)).rgb,             L) * diagW;
        v += dot(tex2D(u_BaseColorSampler, uv + float2( br,-br)).rgb,             L) * diagW;
        v += dot(tex2D(u_BaseColorSampler, uv + float2(-br,-br)).rgb,             L) * diagW;
    }
    else
    {
        v = dot(tex2D(u_BaseColorSampler, uv).rgb, L);
    }
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

    // ── Phase 2: Hierarchical edge detection ─────────────────────────────────
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
    float lum_tl  = KH_ColorSample(uv + float2(-hoff,  hoff));
    float lum_tr  = KH_ColorSample(uv + float2( hoff,  hoff));
    float lum_bl  = KH_ColorSample(uv + float2(-hoff, -hoff));
    float lum_br  = KH_ColorSample(uv + float2( hoff, -hoff));
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
    float hierHW = lerp(0.175, 0.025, _KGHHierTightness);
    hEdge = smoothstep(0.375 - hierHW, 0.375 + hierHW, hEdge);
    hEdge *= _KGHHStrength;

    color.rgb = lerp(color.rgb, _KGHEdgeColor.rgb, hEdge);
    return color;
}

#endif // NPR_EFFECT_KUWAHARA_GAUSS_HIER_INCLUDED
