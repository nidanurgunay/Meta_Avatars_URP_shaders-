#ifndef NPR_EFFECT_HIERARCHICAL_INCLUDED
#define NPR_EFFECT_HIERARCHICAL_INCLUDED

// Hierarchical multi-layer edge detection — avatar-shader adaptation of
// HierarchicalEdgeDetection.shader (AHEAD-inspired).
// Three layers fused with weighted max-pooling:
//   Layer 1  Depth proxy  — ddx/ddy on camera distance  → silhouette edges
//   Layer 2  Normal       — ddx/ddy on world normal      → surface crease edges
//   Layer 3  Color        — Roberts Cross on base colour → texture/detail edges
// Requires ENABLE_NPR_EDGES + EFFECT_HIERARCHICAL keywords.

float4 _HEdgeColor;
float  _HDepthThreshold;     // depth gradient threshold   (0.001–0.2)
float  _HNormalThreshold;    // normal gradient threshold  (0.05–1.0)
float  _HColorThreshold;     // colour gradient threshold  (0.01–0.5)
float  _HDepthWeight;        // depth layer blend weight   (0–1)
float  _HNormalWeight;       // normal layer blend weight  (0–1)
float  _HColorWeight;        // colour layer blend weight  (0–1)
float  _HEdgeWidth;          // Roberts Cross UV offset    (0.5–10, × 0.001)
float  _HAdaptiveStrength;   // suppress edges in dark areas (0–1)

float4 ApplyNPREffect(float4 color, float2 uv, half3 worldNormal, half3 worldViewDir)
{
    // ── Layer 1: depth proxy ─────────────────────────────────────────────────
    // worldViewDir is the un-normalised camera→surface vector in world space;
    // its length equals the camera-to-surface distance.
    float depth    = length((float3)worldViewDir);
    float dDepthX  = ddx(depth);
    float dDepthY  = ddy(depth);
    float depthGrad = sqrt(dDepthX*dDepthX + dDepthY*dDepthY);
    float depthLine = smoothstep(_HDepthThreshold - 0.005,
                                 _HDepthThreshold + 0.005, depthGrad);

    // ── Layer 2: normal discontinuity ────────────────────────────────────────
    float3 dNdx     = ddx((float3)worldNormal);
    float3 dNdy     = ddy((float3)worldNormal);
    float  normGrad = sqrt(dot(dNdx, dNdx) + dot(dNdy, dNdy));
    float  normLine = smoothstep(_HNormalThreshold - 0.02,
                                 _HNormalThreshold + 0.02, normGrad);

    // ── Layer 3: Roberts Cross on base colour ────────────────────────────────
    float off = _HEdgeWidth * 0.001;
    float3 L  = float3(0.299, 0.587, 0.114);
    float lum_tl = dot(tex2D(u_BaseColorSampler, uv + float2(-off,  off)).rgb, L);
    float lum_tr = dot(tex2D(u_BaseColorSampler, uv + float2( off,  off)).rgb, L);
    float lum_bl = dot(tex2D(u_BaseColorSampler, uv + float2(-off, -off)).rgb, L);
    float lum_br = dot(tex2D(u_BaseColorSampler, uv + float2( off, -off)).rgb, L);
    float colGrad = abs(lum_tl - lum_br) + abs(lum_tr - lum_bl); // Roberts Cross
    float colLine = smoothstep(_HColorThreshold - 0.01,
                               _HColorThreshold + 0.01, colGrad);

    // ── Adaptive sensitivity: reduce edges in dark areas ─────────────────────
    float brightness = dot(color.rgb, float3(0.2126, 0.7152, 0.0722));
    float adapt      = lerp(1.0, saturate(brightness * 2.0), _HAdaptiveStrength);
    depthLine *= adapt;
    colLine   *= adapt;
    normLine  *= lerp(1.0, adapt, 0.5); // normals less sensitive to brightness

    // ── Weighted max-pooling fusion ───────────────────────────────────────────
    float edge = max(depthLine  * _HDepthWeight,
                 max(normLine   * _HNormalWeight,
                     colLine    * _HColorWeight));
    // Sharpen: tight smoothstep pushes partial values toward 0 or 1
    // so lines render as clean black rather than a brownish blend.
    edge = smoothstep(0.20, 0.55, edge);

    color.rgb = lerp(color.rgb, _HEdgeColor.rgb, edge);
    return color;
}

#endif // NPR_EFFECT_HIERARCHICAL_INCLUDED
