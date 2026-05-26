#ifndef NPR_EFFECT_XTOON_INCLUDED
#define NPR_EFFECT_XTOON_INCLUDED

// X-Toon Extended Toon Shader — Meta Avatar SDK adaptation
// Based on Barla, Thollot & Markosian "X-Toon: An Extended Toon Shader" (NPAR 2006).
//
// Replaces the 1D NdotL toon ramp with a 2D texture:
//   U axis — lighting intensity (luminance of the composited PBR colour)
//   V axis — abstraction level  (depth proxy, surface curvature, or manual)
//
// Constraint: AppSpecificPostManipulation receives the fully-composited PBR
// colour; raw NdotL is not accessible. Luminance of that colour is used as
// the U-axis lighting proxy (it already encodes shadows, SSS, rim light, etc.).
// The V-axis depth proxy reuses length(worldViewDir), the same scalar used by
// the Hierarchical technique — no extra inputs required.

TEXTURE2D(_XToonRamp);
SAMPLER(sampler_XToonRamp);

float  _XToonLightSensitivity;   // 0 = U fixed at 0.5 (no light response), 1 = full range
float  _XToonRampSmoothing;       // softens the shadow/lit boundary on the ramp
float4 _XToonShadowColor;         // tint applied to shadow regions
float  _XToonShadowStrength;      // 0 = no shadow tint, 1 = full shadow tint
float  _XToonDetailMode;          // 0 = Depth, 1 = Curvature, 2 = Manual
float  _XToonDetailBias;          // constant bias added to V before sampling
float  _XToonDepthNear;           // world-space distance for full-detail (V=0)
float  _XToonDepthFar;            // world-space distance for max abstraction (V=1)
float  _XToonManualDetail;        // V override when DetailMode == 2
float4 _XToonSpecularColor;       // stylised specular highlight colour
float  _XToonSpecularSize;        // angular size of the specular spot
float  _XToonSpecularSmoothness;  // edge softness of the specular spot
float  _XToonSpecularStrength;    // 0 = no specular, 1 = full
float  _XToonLightingStrength;    // blend between original PBR and stylised result

// Compute the V coordinate (abstraction level) of the 2D ramp.
// worldViewDir.xyz is the world-space view vector; its magnitude equals
// the camera-to-surface distance, matching the depth proxy in Hierarchical.
float _XToonComputeDetailAxis(float3 worldViewDir, float3 normalWS)
{
    if (_XToonDetailMode < 0.5)
    {
        // Depth: farther objects become more abstract (higher V)
        float depth = length(worldViewDir);
        float t = saturate((depth - _XToonDepthNear) / max(0.001, _XToonDepthFar - _XToonDepthNear));
        return saturate(t + _XToonDetailBias);
    }
    else if (_XToonDetailMode < 1.5)
    {
        // Curvature: flat surfaces become more abstract (high curvature = low V)
        float3 dNdx = ddx(normalWS);
        float3 dNdy = ddy(normalWS);
        float curvature = length(dNdx) + length(dNdy);
        float t = 1.0 - saturate(curvature * 10.0);
        return saturate(t * (1.0 - _XToonDetailBias) + _XToonDetailBias);
    }
    else
    {
        // Manual: artist-set constant
        return saturate(_XToonManualDetail);
    }
}

float4 ApplyNPREffect(float4 color, float2 uv, half3 worldNormal, half3 worldViewDir)
{
    float3 normalWS = normalize((float3)worldNormal);
    float3 viewDir  = normalize((float3)worldViewDir);

    // --- U axis: lighting intensity from PBR luminance ---
    float lum  = dot(color.rgb, float3(0.2126, 0.7152, 0.0722));
    // Lerp toward 0.5 to reduce light sensitivity (same formula as standalone XToon)
    float rampU = lerp(0.5, saturate(lum), _XToonLightSensitivity);

    // --- V axis: abstraction level ---
    float rampV = _XToonComputeDetailAxis((float3)worldViewDir, normalWS);

    // --- Sample 2D toon ramp (U=light, V=abstraction) ---
    float3 rampColor = SAMPLE_TEXTURE2D(_XToonRamp, sampler_XToonRamp, float2(rampU, rampV)).rgb;

    // --- Abstraction: compress U toward 0.5 as V increases ---
    // Higher V (more abstract) means lighting bands widen and flatten.
    float abstractU    = lerp(rampU, 0.5, rampV * 0.6);
    float dynSmoothing = lerp(_XToonRampSmoothing, _XToonRampSmoothing + 0.35, rampV);
    float shadowMask   = smoothstep(0.5 - dynSmoothing, 0.5 + dynSmoothing, abstractU);

    float3 toonColor     = color.rgb * rampColor;
    float3 shadowedColor = lerp(toonColor * _XToonShadowColor.rgb, toonColor, shadowMask);
    float3 finalColor    = lerp(color.rgb, shadowedColor, _XToonShadowStrength);

    // --- Stylised specular (Blinn-Phong dot, applied on top of ramp) ---
    // Reconstruct a plausible half-direction from the main light direction proxy.
    // Because AppSpecificPostManipulation has no light direction, we use the
    // view direction reflected around the normal as a self-consistent specular.
    // This produces a view-dependent highlight consistent with the toon aesthetic.
    float3 reflDir  = reflect(-viewDir, normalWS);
    float RdotV     = saturate(dot(reflDir, viewDir));
    float specular  = smoothstep(1.0 - _XToonSpecularSize - _XToonSpecularSmoothness,
                                 1.0 - _XToonSpecularSize + _XToonSpecularSmoothness,
                                 RdotV);
    finalColor = lerp(finalColor, _XToonSpecularColor.rgb, specular * _XToonSpecularStrength);

    // --- Blend between original PBR and fully stylised result ---
    finalColor = lerp(color.rgb, finalColor, _XToonLightingStrength);

    return float4(finalColor, color.a);
}

#endif // NPR_EFFECT_XTOON_INCLUDED
