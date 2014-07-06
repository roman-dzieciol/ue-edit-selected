// ============================================================================
//  EditSelected:	 
//  UnrealEd plugin, opens special properties window for selected actor.
// 
//  Copyright 2005 Roman Switch` Dzieciol, neai o2.pl
//  http://wiki.beyondunreal.com/wiki/Switch
// ============================================================================
class EditSelected extends BrushBuilder 
	config;


// ----------------------------------------------------------------------------
// Structs
// ----------------------------------------------------------------------------

struct SEditorActor
{
	var string Actor;
	var int MaxId;
};


// ----------------------------------------------------------------------------
// Internal
// ----------------------------------------------------------------------------

var array<SEditorActor> EditorActors;	// 
var Actor TempEditorActor;				// 
var int WindowsLimit;					//


// ----------------------------------------------------------------------------
// Parameters
// ----------------------------------------------------------------------------

var() config int MaxWindows;	// How many windows can open at once


// ----------------------------------------------------------------------------
// Entry point
// ----------------------------------------------------------------------------

event bool Build()
{
	local Actor A;
	local int counter;
	
	// Find actor reference
	if( !FindAnyActor(A) )
		return false;	
		
	MaxWindows = Clamp(MaxWindows,1,WindowsLimit);
	SaveConfig();

	// Show actor properties
	foreach A.AllActors(class'Actor', A)
	{
		if( A.bSelected )
		{
			A.ConsoleCommand( "editactor name="$ A.name );
			if( ++counter == MaxWindows )
				break;
		}
	}		
	
	return false;
}


// ----------------------------------------------------------------------------
// Internal
// ----------------------------------------------------------------------------

function bool ShowSuccess( coerce string S )
{
	Log( "" $ S, class.name );
	BadParameters( "" $ S );
	return true;
}

function bool ShowError( coerce string S )
{
	Log(  "Error: " $ S, class.name );
	BadParameters( "Error: " $ S );
	return false;
}

function bool FindAnyActor( out Actor A )
{
	local SEditorActor E;
	local int i,j;
	
	for( i=0; i!=EditorActors.Length; ++i )
	{
		E = EditorActors[i];
		for( j=0; j!=E.MaxId; ++j )
		{
			SetPropertyText("TempEditorActor",E.Actor$j);
			if( TempEditorActor != None )
			{
				A = TempEditorActor;
				TempEditorActor = None;
				return true;
			}
		}
	}	
	return ShowError( "Could not find any actors in the level." );
}


// ----------------------------------------------------------------------------
// DefaultProperties
// ----------------------------------------------------------------------------
DefaultProperties
{
	ToolTip="EditSelected"
	BitmapFilename="EditSelected"
	
	MaxWindows=1
	WindowsLimit=8
	
	EditorActors(0)=(Actor="MyLevel.LevelInfo",MaxId=8)
	EditorActors(1)=(Actor="MyLevel.Camera",MaxId=64)
	EditorActors(2)=(Actor="MyLevel.Brush",MaxId=128)
}
