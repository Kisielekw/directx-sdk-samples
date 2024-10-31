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
VS_OUTPUT VS_main( float4 Pos : POSITION, float4 Color : COLOR )
{
    VS_OUTPUT output = (VS_OUTPUT)0;
    output.Pos = mul( Pos, World );
    output.Pos = mul( output.Pos, View );
    output.Pos = mul( output.Pos, Projection );
    output.Color = Color;
    return output;
}


//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( VS_OUTPUT input ) : SV_Target
{
    return input.Color;
}

VS_OUTPUT VS(float4 Pos : POSITION, float4 Color : COLOR)
{
    VS_OUTPUT output = (VS_OUTPUT)0;

    float3 transfrom = float3(1, 0.3, 1);
	float3 scale = float3(0.2, 3, 3);
	float angle = 1.0f;
    
    //translation matrix
	matrix translation = {
		float4(1, 0, 0, 0),
		float4(0, 1, 0, 0),
		float4(0, 0, 1, 0),
		float4(transfrom, 1)
	};

	//scale matrix
	matrix scaling = {
		float4(scale.x, 0, 0, 0),
		float4(0, scale.y, 0, 0),
		float4(0, 0, scale.z, 0),
		float4(0, 0, 0, 1)
	};

	//rotation matrix
	float c = cos(angle);
	float s = sin(angle);
	matrix rotation = {
		float4(c, 0, s, 0),
		float4(0, 1, 0, 0),
		float4(-s, 0, c, 0),
		float4(0, 0, 0, 1)
	};

	matrix translation_scaling = mul(translation, scaling);
	matrix my_world = mul(translation_scaling, rotation);

    output.Pos = mul(Pos, my_world);
    output.Pos = mul(output.Pos, View);
    output.Pos = mul(output.Pos, Projection);
    output.Color = Color;
    
    return output;
}