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

VS_OUTPUT VS_main(float4 Pos : POSITION, float4 Color : COLOR)
{
    VS_OUTPUT output = (VS_OUTPUT)0;

    float3 translate = float3(1.0, 0.3, 1.0);
    float3 scale = float3(0.2, 3.0, 3.0);
    float rotation = 1.0;

	matrix transMatrix = {
		{1.0, 0.0, 0.0, 0.0},
		{0.0, 1.0, 0.0, 0.0},
		{0.0, 0.0, 1.0, 0.0},
		{translate.x, translate.y, translate.z, 1.0}
	};

	matrix scaleMatrix = {
		{scale.x, 0.0, 0.0, 0.0},
		{0.0, scale.y, 0.0, 0.0},
		{0.0, 0.0, scale.z, 0.0},
		{0.0, 0.0, 0.0, 1.0}
	};

	//rotate around y axis
	matrix rotateMatrix = {
		{cos(rotation), 0.0, sin(rotation), 0.0},
		{0.0, 1.0, 0.0, 0.0},
		{-sin(rotation), 0.0, cos(rotation), 0.0},
		{0.0, 0.0, 0.0, 1.0}
	};

	matrix worldMatrix = mul(transMatrix, scaleMatrix);
	worldMatrix = mul(worldMatrix, rotateMatrix);

    output.Pos = mul(Pos, worldMatrix);
    output.Pos = mul(output.Pos, View);
    output.Pos = mul(output.Pos, Projection);
    output.Color = Color;
    return output;
}

VS_OUTPUT VS_Room(float4 Pos : POSITION, float4 Color : COLOR)
{
    VS_OUTPUT output = (VS_OUTPUT) 0;
    
    float3 translate = float3(0.0, 0.0, 0.0);
    float3 scale = float3(7.0, 7.0, 7.0);
    float rotation = 0.0;

    matrix transMatrix =
    {
        { 1.0, 0.0, 0.0, 0.0 },
        { 0.0, 1.0, 0.0, 0.0 },
        { 0.0, 0.0, 1.0, 0.0 },
        { translate.x, translate.y, translate.z, 1.0 }
    };

    matrix scaleMatrix =
    {
        { scale.x, 0.0, 0.0, 0.0 },
        { 0.0, scale.y, 0.0, 0.0 },
        { 0.0, 0.0, scale.z, 0.0 },
        { 0.0, 0.0, 0.0, 1.0 }
    };

	//rotate around y axis
    matrix rotateMatrix =
    {
        { cos(rotation), 0.0, sin(rotation), 0.0 },
        { 0.0, 1.0, 0.0, 0.0 },
        { -sin(rotation), 0.0, cos(rotation), 0.0 },
        { 0.0, 0.0, 0.0, 1.0 }
    };

    matrix worldMatrix = mul(transMatrix, scaleMatrix);
    worldMatrix = mul(worldMatrix, rotateMatrix);
    
    output.Pos = mul(Pos, worldMatrix);
    output.Pos = mul(output.Pos, View);
    output.Pos = mul(output.Pos, Projection);
    output.Color = Color;
    return output;
}

VS_OUTPUT VS_Small(float4 Pos : POSITION, float4 Color : COLOR)
{
    VS_OUTPUT output = (VS_OUTPUT) 0;
    
    float3 translate = float3(0.0, -2, 0.0);
    float3 scale = float3(1.0, 1.0, 1.0);
    float rotation = 3.1416;

    matrix transMatrix =
    {
        { 1.0, 0.0, 0.0, 0.0 },
        { 0.0, 1.0, 0.0, 0.0 },
        { 0.0, 0.0, 1.0, 0.0 },
        { translate.x, translate.y, translate.z, 1.0 }
    };

    matrix scaleMatrix =
    {
        { scale.x, 0.0, 0.0, 0.0 },
        { 0.0, scale.y, 0.0, 0.0 },
        { 0.0, 0.0, scale.z, 0.0 },
        { 0.0, 0.0, 0.0, 1.0 }
    };

	//rotate around y axis
    matrix rotateMatrix =
    {
        { cos(rotation), 0.0, sin(rotation), 0.0 },
        { 0.0, 1.0, 0.0, 0.0 },
        { -sin(rotation), 0.0, cos(rotation), 0.0 },
        { 0.0, 0.0, 0.0, 1.0 }
    };

    matrix worldMatrix = mul(transMatrix, scaleMatrix);
    worldMatrix = mul(worldMatrix, rotateMatrix);
    
    output.Pos = mul(Pos, worldMatrix);
    output.Pos = mul(output.Pos, View);
    output.Pos = mul(output.Pos, Projection);
    output.Color = Color;
    return output;
}

VS_OUTPUT VS_Large(float4 Pos : POSITION, float4 Color : COLOR)
{
    VS_OUTPUT output = (VS_OUTPUT) 0;
    
    float3 translate = float3(-2.0, 0.0, 2.0);
    float3 scale = float3(1.0, 2.0, 1.0);
    float rotation = 3.1416;

    matrix transMatrix =
    {
        { 1.0, 0.0, 0.0, 0.0 },
        { 0.0, 1.0, 0.0, 0.0 },
        { 0.0, 0.0, 1.0, 0.0 },
        { translate.x, translate.y, translate.z, 1.0 }
    };

    matrix scaleMatrix =
    {
        { scale.x, 0.0, 0.0, 0.0 },
        { 0.0, scale.y, 0.0, 0.0 },
        { 0.0, 0.0, scale.z, 0.0 },
        { 0.0, 0.0, 0.0, 1.0 }
    };

	//rotate around y axis
    matrix rotateMatrix =
    {
        { cos(rotation), 0.0, sin(rotation), 0.0 },
        { 0.0, 1.0, 0.0, 0.0 },
        { -sin(rotation), 0.0, cos(rotation), 0.0 },
        { 0.0, 0.0, 0.0, 1.0 }
    };

    matrix worldMatrix = mul(scaleMatrix, rotateMatrix);
    worldMatrix = mul(worldMatrix, transMatrix);
    
    output.Pos = mul(Pos, worldMatrix);
    output.Pos = mul(output.Pos, View);
    output.Pos = mul(output.Pos, Projection);
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

float4 PS1(VS_OUTPUT input) : SV_Target
{
    return float4(1, 0, 0, 1);
}

float4 PS2(VS_OUTPUT input) : SV_Target
{
    return float4(0, 1, 0, 1);
}

float4 PS3(VS_OUTPUT input) : SV_Target
{
    return float4(0, 0, 1, 1);
}
