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
        Cull Off

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

            float map(float s, float a1, float a2, float b1, float b2)
            {
                return b1 + (s-a1)*(b2-b1)/(a2-a1);
            }
 

            sampler2D _MainTex;
            float4 _MainTex_ST;

            Interpolators vert (MeshData v)
            {
                Interpolators o;

                // WORLD SPACE.
                // float3 vertexWorldPosition = mul(unity_ObjectToWorld, v.vertex);
                // float3 worldViewDir = vertexWorldPosition - _WorldSpaceCameraPos;
                // vertexWorldPosition = vertexWorldPosition + (worldViewDir * (1/(1*pow(length(worldViewDir), 2))));
                // o.vertex = mul(UNITY_MATRIX_VP, vertexWorldPosition);

                // float4 vertexWorldPosition = mul(unity_ObjectToWorld, v.vertex);
                // float4 worldViewDir = vertexWorldPosition - float4(_WorldSpaceCameraPos,1);
                // vertexWorldPosition = vertexWorldPosition + (worldViewDir * 100*(1/(1*pow(length(worldViewDir), 2))));
                // o.vertex = mul(UNITY_MATRIX_VP, vertexWorldPosition);

                // float4 vertexWorldPosition = mul(unity_ObjectToWorld, v.vertex);
                // float3 worldViewDir = vertexWorldPosition.xyz - _WorldSpaceCameraPos;
                // vertexWorldPosition.xyz = vertexWorldPosition.xyz + (worldViewDir * 100*(1/(1*pow(length(worldViewDir), 2))));
                // // vertexWorldPosition.xyz = vertexWorldPosition.xyz + worldViewDir;
                // o.vertex = mul(UNITY_MATRIX_VP, vertexWorldPosition);

                // vertexWorldPosition += worldViewDir;

                // v.vertex = mul(unity_WorldToObject, vertexWorldPosition);

                // OBJECT SPACE.
                // Almost working but weirdness around camera position 0,0,0
                // float3 objectSpaceCameraPos = mul(unity_WorldToObject, _WorldSpaceCameraPos);
                // float3 objectViewDir = v.vertex.xyz - objectSpaceCameraPos;
                // v.vertex.xyz = v.vertex.xyz + (objectViewDir * (1/(1*pow(length(objectViewDir), 2))));

                
                // float3 objectViewDir = ObjSpaceViewDir(v.vertex);
                // // v.vertex.xyz = v.vertex.xyz + ((objectViewDir/length(objectViewDir)) * (1/(pow(length(objectViewDir), 1))));
                // // v.vertex.xyz = v.vertex.xyz + ((objectViewDir/length(objectViewDir)));
                // v.vertex.xyz = v.vertex.xyz + (v.normal.xyz * (1/(pow(length(objectViewDir), 2)))); // use normal instead?

                // float3 objectViewDir = ObjSpaceViewDir(v.vertex);
                // float remappedObjectViewMultiplier = saturate( map(length(objectViewDir), 3, 20, .25, 0) );
                // v.vertex.xyz = v.vertex.xyz + (remappedObjectViewMultiplier * ((objectViewDir/length(objectViewDir)) * (1/(pow(length(objectViewDir), 2)))));
                
                // float3 objectViewDir = ObjSpaceViewDir(v.vertex);
                // float remappedObjectViewMultiplier = max(map(length(objectViewDir), 10, 20, 3, 0), 3);
                // v.vertex.xyz = v.vertex.xyz + (remappedObjectViewMultiplier * ((objectViewDir/length(objectViewDir))));

                float3 objectViewDir = ObjSpaceViewDir(v.vertex);
                // v.vertex.xyz = v.vertex.xyz + ((objectViewDir/length(objectViewDir)) * (1/(pow(length(objectViewDir), 1))));
                // v.vertex.xyz = v.vertex.xyz + ((objectViewDir/length(objectViewDir)));
                float remappedObjectViewMultiplier = 10 * saturate( map(length(objectViewDir), 10, 30, 1, 0) );
                v.vertex.xyz = v.vertex.xyz - (v.normal.xyz * remappedObjectViewMultiplier * (1/(pow(length(objectViewDir), 2))));

                // Should we do this?
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                
                
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                // o.uv = v.uv;
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
