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
	float4 lightPos;
	float4 eyePos;
}

//--------------------------------------------------------------------------------------

struct VS_INPUT
{
	float4 Pos		: POSITION;
	float3 Normal	: NORMAL;
	float2 TexCoord	: TEXCOORD;
	float3 Tangent	: TANGENT;
	float3 Binormal	: BINORMAL;
};

struct PS_OUTPUT
{
	float4 Pos				: SV_POSITION;
	float3 Normal			: TEXCOORD0;
    float2 TexCoord			: TEXCOORD1;
	float3 ViewDirInTang	: TEXCOORD2;
	float3 LightDirInTang	: TEXCOORD3;
};

Texture2D txColor		: register( t0 );
Texture2D txNormal		: register( t1 );
Texture2D txHight		: register( t2 );
SamplerState txSampler	: register( s0 );

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------

PS_OUTPUT VS(VS_INPUT input)
{
	PS_OUTPUT output = (PS_OUTPUT)0;

	output.Pos = mul(input.Pos, World);
	output.Pos = mul(output.Pos, View);
	output.Pos = mul(output.Pos, Projection);

	float3 viewDirW = eyePos - input.Pos;
	float3 lightDirW = lightPos - input.Pos;

	float3 N = normalize(input.Normal);
	float3 T = normalize(input.Tangent);
	float3 B = normalize(input.Binormal);

	float3x3 mat2Tang = float3x3(T, B, N);

	output.ViewDirInTang = normalize(mul(mat2Tang, viewDirW));
	output.LightDirInTang = normalize(mul(mat2Tang, lightDirW));

	output.TexCoord = input.TexCoord;

	//output.Pos = mul(input.Pos, World);

	//float3 Normal = normalize(mul(input.Normal.xyz, World));

	//output.Pos = mul(output.Pos, View);
	//output.Pos = mul(output.Pos, Projection);
	//
	//output.Normal = Normal;
	//output.PosWold = mul(input.Pos, World);
	//output.TexCoord = input.TexCoord;

	return output;
}

PS_OUTPUT VS_Light(VS_INPUT input)
{
	PS_OUTPUT output = (PS_OUTPUT)0;

	output.Pos = mul(input.Pos, World);
	output.Pos = mul(output.Pos, View);
	output.Pos = mul(output.Pos, Projection);

	return output;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(PS_OUTPUT input) : SV_Target
{
	float4 finalLight = float4(0.1f, 0.1f, 0.1f, 1.0);
	float4 stoneColor = txColor.Sample(txSampler, input.TexCoord).r;
	float4 stoneHight = txHight.Sample(txSampler, input.TexCoord).r;
	
	float dx = ddx(stoneHight);
	float dy = ddy(stoneHight);
	float3 N = normalize(float3(-dx, -dy, 0.2));

	// float3 N = normalize(mul(2.0 * stoneNormal - 1, World)).xyz;

	float3 R = reflect(-input.LightDirInTang, N);
	float3 V = input.ViewDirInTang;
	float spec = max(0, dot(R, V));
	float finalSpec = pow(spec, 30);

	float diff = max(0.0, dot(input.LightDirInTang, N));

	finalLight += (diff * float4(1.0, 1.0, 1.0, 1.0)) + (finalSpec * float4(1.0, 1.0, 1.0, 1.0));

	return  finalLight* stoneColor;
}

float4 PS_Light(PS_OUTPUT input) : SV_Target
{
	return float4(1.0, 1.0, 1.0, 1.0);
}