// Hook into Meta's fragment shader right before it outputs the color.
// (Note: Meta typically uses 'color.rgb' for the final output variable, but 
// depending on the exact SDK version, this may be 'outColor.rgb' or similar).

float edge = ComputeTextureSobel(input.texcoord.xy, _InnerLineWidth);
float edgeMask = smoothstep(_ColorThreshold - 0.01, _ColorThreshold + 0.01, edge);

// Blend the Sobel inner lines over the computed avatar color
color.rgb = lerp(color.rgb, _InnerLineColor.rgb, edgeMask * _InnerLineColor.a);