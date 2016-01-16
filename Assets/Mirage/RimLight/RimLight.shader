Shader "Hidden/RimLight"
{
    Properties
    {
        _MainTex("", 2D) = "" {}
        [HDR] _Color("", Color) = (1, 1, 1)
    }
    CGINCLUDE

    #include "UnityCG.cginc"

    sampler2D _MainTex;

	sampler2D_float _CameraDepthTexture;
    sampler2D _CameraGBufferTexture2;
    float4x4 _WorldToCamera;

    half4 _Color;
    float _Exponent;
    float2 _Stripe;

    half4 frag_rim(v2f_img i) : SV_Target
    {
        float4 src = tex2D(_MainTex, i.uv);

        // Sample a linear depth on the depth buffer.
        float depth_s = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
        float depth_o = LinearEyeDepth(depth_s);

        // Sample a view-space normal vector on the g-buffer.
        float3 norm_o = tex2D(_CameraGBufferTexture2, i.uv).xyz * 2 - 1;
        norm_o = mul((float3x3)_WorldToCamera, norm_o);

        // Reconstruct the view-space position.
        float2 p11_22 = float2(unity_CameraProjection._11, unity_CameraProjection._22);
        float2 p13_31 = float2(unity_CameraProjection._13, unity_CameraProjection._23);
        float3 pos_o = float3((i.uv * 2 - float2(1, -1) - p13_31) / p11_22, 1) * depth_o;

        float atten = pow(1 - abs(dot(normalize(pos_o), norm_o)), _Exponent);
        atten *= (depth_s < 1);
        atten *= frac(pos_o.y * _Stripe.x) < _Stripe.y;

        half3 rgb = lerp(src.rgb, _Color.rgb * atten, _Color.a);
        return half4(rgb, 1);
    }

    ENDCG
    SubShader
    {
        Pass
        {
            ZTest Always Cull Off ZWrite Off
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag_rim
            #pragma target 3.0
            ENDCG
        }
    }
}
