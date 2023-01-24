Shader "Custom/VertexSpasm"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            float random (float2 uv)
            {
                return frac(sin(dot(uv,float2(12.9898,78.233)))*43758.5453123);
            }

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;

                // float4 movedVertex = float4(1,1,1,1)

                // float sinTime = sin(_Time);

                // if((_Time.w * 300) % 2 < 0.01) {
                //     // float4 movedVertex = v.vertex + float4(random(_Time.x), random(_Time.y), random(_Time.z), 0);
                //     float4 movedVertex = v.vertex + float4(v.normal.xyz, 0) * random(_Time.x);
                    
                //     // movedVertex = movedVertex + float4(_SinTime.y, _SinTime.y, _SinTime.y, 0);
                //     o.vertex = UnityObjectToClipPos(movedVertex);
                // } else {
                //     float4 movedVertex = v.vertex + float4(_SinTime.y, _SinTime.y, _SinTime.y, 0);
                //     o.vertex = UnityObjectToClipPos(movedVertex);
                // }

                float4 movedVertex = v.vertex + float4(v.normal.xyz, 0) * (random(_Time.x)*((_Time.w) % 2));
                    
                    // movedVertex = movedVertex + float4(_SinTime.y, _SinTime.y, _SinTime.y, 0);
                o.vertex = UnityObjectToClipPos(movedVertex);

                // float4 movedVertex = v.vertex + float4(random(_Time.x), random(_Time.y), random(_Time.z), 0);
                // o.vertex = UnityObjectToClipPos(movedVertex);
                    // o.vertex = movedVertex;
                // else {
                //     float4 movedVertex = v.vertex + float4(sinTime, sinTime, sinTime, 0);
                //     o.vertex = UnityObjectToClipPos(movedVertex);
                // }
                
                // float4 movedVertex = v.vertex + float4(sinTime, sinTime, sinTime, 0);
                // o.vertex = UnityObjectToClipPos(movedVertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
