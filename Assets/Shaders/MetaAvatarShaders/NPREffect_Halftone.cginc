#ifndef NPR_EFFECT_HALFTONE_INCLUDED
#define NPR_EFFECT_HALFTONE_INCLUDED

// Halftone dot pattern — adapted from Assets/Shaders/NPR/HalftoneHatching.shader.
// Tone is derived from the luminance of the incoming PBR colour (no separate light pass).
// Coordinates are UV-space (texcoord_0), equivalent to ObjectSpace mode in the source shader.
// Requires ENABLE_NPR_EDGES + EFFECT_HALFTONE keywords.

float  _HTScale;            // dot grid frequency       (2–100)
float  _HTSharpness;        // dot edge sharpness       (1–50)
float  _HTAngle;            // grid rotation in degrees (0–90)
float  _HTToneBias;         // shift the tone value     (-0.5–0.5)
float4 _HTInkColor;         // ink / dot colour
float4 _HTPaperColor;       // paper / background colour
float  _HTTextureInfluence; // 0 = flat ink/paper, 1 = tint with original PBR colour (0–1)
float  _HTStrength;         // blend pattern over original PBR colour (0–1)

// ── Helpers ───────────────────────────────────────────────────────────────────
float2 HT_Rotate2D(float2 p, float deg)
{
    float rad = deg * 0.01745329251f;
    float c = cos(rad), s = sin(rad);
    return float2(c * p.x - s * p.y, s * p.x + c * p.y);
}

// Returns 0 (paper) → 1 (ink). Darker tone → larger dot radius.
float HT_HalftonePattern(float2 coords, float tone)
{
    float2 rotated  = HT_Rotate2D(coords, _HTAngle);
    float2 gridPos  = frac(rotated * _HTScale) - 0.5;
    float  dist     = length(gridPos);
    float  dotRadius = sqrt(max(0.0, 1.0 - tone)) * 0.5;
    float  sharpInv  = 0.5 / max(_HTSharpness, 0.001);
    return 1.0 - smoothstep(dotRadius - sharpInv, dotRadius + sharpInv, dist);
}

float4 ApplyNPREffect(float4 color, float2 uv, half3 worldNormal, half3 worldViewDir)
{
    float lum  = dot(color.rgb, float3(0.299, 0.587, 0.114));
    float tone = saturate(lum + _HTToneBias);

    float pattern = HT_HalftonePattern(uv, tone);

    // _HTTextureInfluence blends flat ink/paper against PBR-tinted versions (same as source shader)
    float3 paperCol     = lerp(_HTPaperColor.rgb, color.rgb,                    _HTTextureInfluence);
    float3 inkCol       = lerp(_HTInkColor.rgb,   color.rgb * _HTInkColor.rgb,  _HTTextureInfluence);
    float3 patternColor = lerp(paperCol, inkCol, pattern);

    color.rgb = lerp(color.rgb, patternColor, _HTStrength);
    return color;
}

#endif // NPR_EFFECT_HALFTONE_INCLUDED
