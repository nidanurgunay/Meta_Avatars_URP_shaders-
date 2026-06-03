#ifndef NPR_EFFECT_HATCHING_INCLUDED
#define NPR_EFFECT_HATCHING_INCLUDED

// Tonal Art Map hatching — adapted from Assets/Shaders/NPR/HalftoneHatching.shader.
// Based on Praun et al. "Real-Time Hatching" (SIGGRAPH 2001).
// Four layers activate progressively as tone darkens:
//   Layer 1 (t > 0.15) — primary direction
//   Layer 2 (t > 0.35) — cross direction
//   Layer 3 (t > 0.55) — dense diagonal
//   Layer 4 (t > 0.80) — near-black fill
// Tone is derived from the luminance of the incoming PBR colour.
// Coordinates are UV-space (texcoord_0).
// Requires ENABLE_NPR_EDGES + EFFECT_HATCHING keywords.

float  _HatScale;            // line/cell frequency       (1–100)
float  _HatAngle;            // primary hatch angle°      (0–180)
float  _HatCrossAngle;       // cross-hatch angle°        (0–180)
float  _HatThickness;        // line thickness            (0.01–0.5)
float  _HatToneBias;         // shift the tone value      (-0.5–0.5)
float4 _HatInkColor;         // ink / line colour
float4 _HatPaperColor;       // paper / background colour
float  _HatTextureInfluence; // 0 = flat, 1 = tint with original PBR colour (0–1)
float  _HatStrength;         // blend pattern over original PBR colour (0–1)

// ── Helpers ───────────────────────────────────────────────────────────────────
float2 Hat_Rotate2D(float2 p, float deg)
{
    float rad = deg * 0.01745329251f;
    float c = cos(rad), s = sin(rad);
    return float2(c * p.x - s * p.y, s * p.x + c * p.y);
}

// Returns 0 (gap) → 1 (on-line). Rotates coords and scans along X.
float Hat_HatchLine(float2 coords, float angleDeg, float thickness)
{
    float2 rotated = Hat_Rotate2D(coords, angleDeg);
    float  linePos = frac(rotated.x * _HatScale);
    float  mask    = smoothstep(thickness, thickness + 0.02, abs(linePos - 0.5));
    return 1.0 - mask;
}

// TAM: accumulates hatch layers as darkness (t = 1 - tone) increases.
float Hat_HatchingPattern(float2 coords, float tone)
{
    float t       = 1.0 - tone;
    float pattern = 0.0;

    if (t > 0.15)
        pattern = max(pattern, Hat_HatchLine(coords, _HatAngle, _HatThickness)
                               * smoothstep(0.15, 0.40, t));

    if (t > 0.35)
        pattern = max(pattern, Hat_HatchLine(coords, _HatCrossAngle, _HatThickness)
                               * smoothstep(0.35, 0.60, t));

    if (t > 0.55)
    {
        float denseAngle = (_HatAngle + _HatCrossAngle) * 0.5;
        pattern = max(pattern, Hat_HatchLine(coords, denseAngle, _HatThickness * 1.5)
                               * smoothstep(0.55, 0.80, t));
    }

    if (t > 0.80)
        pattern = max(pattern, smoothstep(0.80, 1.0, t));

    return pattern;
}

float4 ApplyNPREffect(float4 color, float2 uv, half3 worldNormal, half3 worldViewDir)
{
    float lum  = dot(color.rgb, float3(0.299, 0.587, 0.114));
    float tone = saturate(lum + _HatToneBias);

    float pattern = Hat_HatchingPattern(uv, tone);

    float3 paperCol     = lerp(_HatPaperColor.rgb, color.rgb,                       _HatTextureInfluence);
    float3 inkCol       = lerp(_HatInkColor.rgb,   color.rgb * _HatInkColor.rgb,    _HatTextureInfluence);
    float3 patternColor = lerp(paperCol, inkCol, pattern);

    color.rgb = lerp(color.rgb, patternColor, _HatStrength);
    return color;
}

#endif // NPR_EFFECT_HATCHING_INCLUDED
