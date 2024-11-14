//--------------------------------------------------------------------------------------
// File: Tutorial04.fx
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License (MIT).
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------
cbuffer ConstantBuffer : register( b0 )
{
	matrix World;
	matrix View;
	matrix Projection;
	float4 lightPos[3];
	float4 lightCol[3];
	float4 eyePos;
}

//--------------------------------------------------------------------------------------

struct VS_OUTPUT
{
	float4 Pos : SV_POSITION;
	float3 Normal : TEXCOORD0;
	float3 PosWold : TEXCOORD1;
    float2 TexCoord : TEXCOORD2;
	float3 Tangent : TEXCOORD3;
	float3 Binormal : TEXCOORD4;
};

Texture2D txColor : register( t0 );
Texture2D txNormal : register( t1 );
Texture2D txHight : register( t2 );
SamplerState txSampler : register( s0 );

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------

VS_OUTPUT VS(float4 Pos : POSITION, float3 Normal : NORMAL, float2 TexCoord : TEXCOORD, float3 Tangent : TANGENT, float3 Binormal : BINORMAL)
{
	VS_OUTPUT output = (VS_OUTPUT)0;

	output.Pos = mul(Pos, World);

	float3 normal = normalize(mul(Normal.xyz, World));

	output.Pos = mul(output.Pos, View);
	output.Pos = mul(output.Pos, Projection);
	
	output.Normal = normal;
	output.PosWold = mul(Pos, World);
	output.TexCoord = TexCoord;
	output.Tangent = Tangent;
	output.Binormal = Binormal;

	return output;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(VS_OUTPUT input) : SV_Target
{
	float4 finalLight = float4(0.1f, 0.1f, 0.1f, 1.0);
	float4 woodColor = txColor.Sample(txSampler, input.TexCoord);

	for (int i = 0; i < 3; i++)
	{
		float4 lightColor = lightCol[i];
		float3 lightDir = normalize(lightPos[i].xyz - input.PosWold.xyz);

		float3 R = reflect(-lightDir, input.Normal);
		float3 V = normalize(eyePos - input.PosWold.xyz);
		float spec = max(0.0, dot(R, V));
		float finalSpec = pow(spec, 30);

		float diff = max(0.0, dot(lightDir, input.Normal));

		finalLight += (diff * float4(0.9, 0.9, 0.9, 1.0) + finalSpec * float4(0.3, 0.3, 0.3, 1.0)) * lightColor;
	}

    return finalLight * woodColor;
}