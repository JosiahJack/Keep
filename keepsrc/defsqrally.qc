//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Quake Rally, Qmaster
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 0
// Function count: 0
//
// Implements: Definitions for rally car entity fields and global variables
//
// Description:
// Defines the necessary values for vehicle behavior.  Added a few new ones to
// handle Keep's vehicle system.
//=============================================================================

.float in_a_vehicle;		// True or false indicating if in a vehicle or not
.float vehicle_index;		// Car type
.string vehicle_model;		// String path of the base model
.float vehicle_skindex;		// Skin number
float modelindex_null;
.entity veh_tail;
.entity vehicleattachment;