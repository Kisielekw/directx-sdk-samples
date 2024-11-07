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
}

//--------------------------------------------------------------------------------------
struct VS_OUTPUT
{
    float4 Pos : SV_POSITION;
    float4 Color : COLOR0;
};

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
    float3 lightDir = normalize(lightPos.xyz - output.Pos.xyz);
    float3 normal = normalize(mul(Normal.xyz, World));
    float diff = max(0.0, dot(lightDir, normal));

    output.Pos = mul(output.Pos, View);
    output.Pos = mul(output.Pos, Projection);

    output.Color = (materialAmbient + diff * materialDiff) * lightCol;
    return output;
}


//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( VS_OUTPUT input ) : SV_Target
{
    return input.Color;
}

