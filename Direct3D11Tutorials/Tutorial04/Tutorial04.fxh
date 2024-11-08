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
	float4 Color : COLOR0;
};

struct VS_OUTPUT_PS_LIGHT
{
	float4 Pos : SV_POSITION;
	float4 Color : COLOR0;
	float3 Normal : TEXCOORD0;
	float3 PosWold : TEXCOORD1;
    float2 TexCoord : TEXCOORD2;
};

Texture2D txWoodColor : register( t0 );
SamplerState txWoodSampler : register( s0 );

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
VS_OUTPUT VS( float4 Pos : POSITION, float4 Color : COLOR, float4 Normal : Normal )
{
	VS_OUTPUT output = (VS_OUTPUT)0;
	output.Pos = mul( Pos, World );
	output.Pos = mul( output.Pos, View );
	output.Pos = mul( output.Pos, Projection );
	output.Color = Color;
	return output;
}

VS_OUTPUT VS_Light(float4 Pos : POSITION, float4 Color : COLOR, float4 Normal : Normal)
{
	VS_OUTPUT output = (VS_OUTPUT)0;
	
	output.Pos = mul(Pos, World);

	float4 materialAmbient = float4(0.1, 0.1, 0.1, 1.0);
	float4 materialDiff = Color;
	float4 lightCol = float4(1.0, 1.0, 1.0, 1.0);
	float3 lightDir = normalize(lightPos[0].xyz - output.Pos.xyz);
	
	float diff = max(0.0, dot(lightDir, Normal));

	output.Pos = mul(output.Pos, View);
	output.Pos = mul(output.Pos, Projection);

	output.Color = (materialAmbient + diff * materialDiff) * lightCol;
	return output;
}

VS_OUTPUT_PS_LIGHT VS_PSLight(float4 Pos : POSITION, float4 Color : COLOR, float3 Normal : Normal, float2 TexCoord : TEXCOORD)
{
	VS_OUTPUT_PS_LIGHT output = (VS_OUTPUT_PS_LIGHT)0;

	output.Pos = mul(Pos, World);

	float3 normal = normalize(mul(Normal.xyz, World));

	output.Pos = mul(output.Pos, View);
	output.Pos = mul(output.Pos, Projection);

	output.Color = Color;
	output.Normal = normal;
	output.PosWold = mul(Pos, World);
	output.TexCoord = TexCoord;

	return output;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( VS_OUTPUT input ) : SV_Target
{
	return input.Color;
}

float4 PS_Light(VS_OUTPUT_PS_LIGHT input) : SV_Target
{
	float4 finalLight = float4(0.1f, 0.1f, 0.1f, 1.0);
	float4 woodColor = txWoodColor.Sample(txWoodSampler, input.TexCoord);

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