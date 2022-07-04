//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Drake by Patrick Martin
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
// Implements: Shot Leading System for monster aiming
//
// Description:
// Adjusts firing angles based on target's velocity for smart aiming.
//
// The set of numbers in the 'spread' vectors passed to these aim
// functions are angles, not their tangents.
//
// Why pass the angles?  Because the values returned by crandom() with
// tangents passed to it tends to favor the edges.  For example, passing
// a tangent of 10000000 to crandom will very likely return a value that,
// if you calcualated its inverse tangent, be 89.x degrees.
//
// By passing the angle instead, there is no bias for any angle, assuming
// the random() function does its job.  After randomization, the angle may
// be converted to a tangent for whatever purpose.
//=============================================================================

