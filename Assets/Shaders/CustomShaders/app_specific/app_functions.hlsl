// App specific functions — called from Style2MetaAvatarCore.hlsl via forward declarations.
// This file should persist across successive SDK integrations.

// MOD START MetaNPR: NPR inner edge detection keyword
#pragma multi_compile __ ENABLE_NPR_EDGES
// MOD END MetaNPR

// MOD START MetaNPR: include edge effect when keyword is active
#if defined(ENABLE_NPR_EDGES)
#include "AvatarNPREdgeEffect.cginc"
#endif
// MOD END MetaNPR

void AppSpecificVertexPostManipulation(AvatarVertexInput i, inout VertexToFragment o) {
    // Call app specific functions from here.
}

void AppSpecificPreManipulation(inout avatar_FragmentInput i) {
    // Call app specific functions from here.
}

void AppSpecificFragmentComponentManipulation(avatar_FragmentInput i, inout float3 punctualSpecular,
    inout float3 punctualDiffuse, inout float3 ambientSpecular, inout float3 ambientDiffuse) {
    // Call app specific functions from here.
}

// MOD START MetaNPR: apply NPR edge detection in post-manipulation hook
void AppSpecificPostManipulation(avatar_FragmentInput i, inout avatar_FragmentOutput o) {

#if defined(ENABLE_NPR_EDGES)
    o.color = ApplyNPREdgeEffect(o.color, i.geometry.texcoord_0);
#endif

}
// MOD END MetaNPR
