// Bridge include: adds Meta Avatar SDK compute-skinning vertex fetch support
// to any URP shader. Include this AFTER URP Core.hlsl.
//
// Usage in vertex struct:  uint vertexID : SV_VertexID;
// Usage in vertex body:    OVR_FETCH_POS_NORM(posOS, normOS, input.vertexID);
//                          OVR_FETCH_POS(posOS, input.vertexID);  // depth/shadow passes

#ifndef OVR_VERTEX_FETCH_BRIDGE_INCLUDED
#define OVR_VERTEX_FETCH_BRIDGE_INCLUDED

#if defined(OVR_VERTEX_FETCH_EXTERNAL_BUFFER)
    #include "Packages/com.meta.xr.sdk.avatars/Scripts/ShaderUtils/OvrAvatarSupportDefines.hlsl"
    #if defined(OVR_SUPPORT_EXTERNAL_BUFFERS)
        #include "Packages/com.meta.xr.sdk.avatars/Scripts/ShaderUtils/OvrAvatarVertexFetch.hlsl"
        #include "Packages/com.meta.xr.sdk.avatars/Scripts/ShaderUtils/OvrAvatarCommonVertexParams.hlsl"

        #define OVR_FETCH_POS_NORM(posOS, normOS, vid)                                          \
            if (u_IsExternalAttributeSourceValid != 0) {                                         \
                uint _ovrIdx = (uint)(vid) * (uint)_OvrNumOutputEntriesPerAttribute             \
                             + (uint)_OvrAttributeOutputLatestAnimFrameEntryOffset;              \
                posOS  = OvrGetPositionEntryFromExternalBuffer(_ovrIdx);                         \
                normOS = OvrGetFrenetEntryFromExternalBuffer(_ovrIdx).xyz;                       \
            }

        #define OVR_FETCH_POS(posOS, vid)                                                        \
            if (u_IsExternalAttributeSourceValid != 0) {                                         \
                uint _ovrIdx = (uint)(vid) * (uint)_OvrNumOutputEntriesPerAttribute             \
                             + (uint)_OvrAttributeOutputLatestAnimFrameEntryOffset;              \
                posOS  = OvrGetPositionEntryFromExternalBuffer(_ovrIdx);                         \
            }
    #else
        #define OVR_FETCH_POS_NORM(posOS, normOS, vid)
        #define OVR_FETCH_POS(posOS, vid)
    #endif
#else
    #define OVR_FETCH_POS_NORM(posOS, normOS, vid)
    #define OVR_FETCH_POS(posOS, vid)
#endif

#endif // OVR_VERTEX_FETCH_BRIDGE_INCLUDED
