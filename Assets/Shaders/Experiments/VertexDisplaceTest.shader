Shader "Custom/VertexDisplaceTest"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define TAU 6.28318530718

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal: TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            Interpolators vert (MeshData v)
            {
                Interpolators o;

                // float3 vertexWorldPosition = mul(unity_ObjectToWorld, v.vertex);
                // float3 worldViewDir = vertexWorldPosition - _WorldSpaceCameraPos;

                // vertexWorldPosition += worldViewDir;

                // v.vertex = mul(unity_WorldToObject, vertexWorldPosition);


                // v.vertex.y = 
                float3 objectSpaceCameraPos = mul(unity_WorldToObject, _WorldSpaceCameraPos);
                float3 objectViewDir = v.vertex.xyz - objectSpaceCameraPos;
                // v.vertex += float4(objectViewDir, 0);

                v.vertex.xyz = v.vertex.xyz + (objectViewDir * (20/length(objectViewDir)));

                // v.vertex = float4(v.vertex.xyz + (objectViewDir * (20/length(objectViewDir))), 1);



                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = v.uv;
                return o;
            }

            float InverseLerp( float a, float b, float v ) {
                return (v-a)/(b-a);
            }

            float4 frag (Interpolators i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
                return float4(.7,.7,.7,1);
            }
            ENDCG
        }
    }
}
