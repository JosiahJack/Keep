//==========================================================================
//  check.qc -- by Patrick Martin               Last updated:  9-8-1997
//--------------------------------------------------------------------------
//  This file contains code that determines whether an entity or a
//  location is inside the various contents found in Quake.
//==========================================================================

//-------------------------------------------------------- New Code --------
//  This checks for obstacles such as solid entities or walls inside
//  the bbox and along its borders.  If an obstacle is met, FALSE is
//  returned.
//--------------------------------------------------------------------------
float(entity head, vector spot) PM_TraceCheck =
{
        local   vector  p1, p2;

// Check for obstacles inside the bbox.
// Order:  1)--- to +++    2)+-- to -++    3)++- to --+    4)-+- to +-+
        p1 = spot + self.mins;
        p2 = spot + self.maxs;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1_x = spot_x + self.maxs_x;
        p2_x = spot_x + self.mins_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1_y = spot_y + self.maxs_y;
        p2_y = spot_y + self.mins_y;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1_x = spot_x + self.mins_x;
        p2_x = spot_x + self.maxs_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

// Check for obstacles along the bbox boundaries.
// Order:  1)+++ to ++-    2)+-+ to +--    3)--+ to ---    4)-++ to -+-
//         5)--- to +--    6)+-- to ++-    7)++- to -+-    8)-+- to ---
//         9)+++ to -++   10)-++ to --+   11)--+ to -+-   12)-+- to +++
        p1 = p2 = spot + self.maxs;
        p2_z = spot_z + self.mins_z;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1_x = p2_x = spot_x + self.mins_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1_y = p2_y = spot_y + self.mins_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1_x = p2_x = spot_x + self.maxs_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2 = spot + self.mins;
        p2_x = spot_x + self.maxs_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_y = spot_y + self.maxs_y;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_x = spot_x + self.mins_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_y = spot_y + self.mins_y;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2 = spot + self.maxs;
        p2_x = spot_x + self.mins_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_y = spot_y + self.mins_y;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_x = spot_x + self.maxs_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_y = spot_y + self.maxs_y;
        traceline (p1, p2, FALSE, head);
        return (trace_fraction == 1);
};

//-------------------------------------------------------- New Code --------
//  This checks if a bbox is inside a wall or sky.  The bbox's origin
//  and corners are checked.  If any one points is within a solid or sky,
//  TRUE is returned.
//--------------------------------------------------------------------------
float(entity head, vector spot) PM_InWall =
{
        local   vector  p;

// Check origin.
        p = spot;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

// Check bbox faces.
// Order:  1)-00  2)+00  3)0-0  4)0+0  5)00-  6)00+
        p_x = spot_x + head.mins_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.maxs_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p = spot;
        p_y = spot_y + head.mins_y;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_y = spot_y + head.maxs_y;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p = spot;
        p_z = spot_z + head.mins_z;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_z = spot_z + head.maxs_z;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

// Check bbox corners.
// Order:  1)+++  2)-++  3)+-+  4)--+  5)++-  6)-+-  7)+--  8)---
        p_x = spot_x + head.maxs_x;
        p_y = spot_y + head.maxs_y;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.mins_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.maxs_x;
        p_y = spot_y + head.mins_y;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.mins_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.maxs_x;
        p_y = spot_y + head.maxs_y;
        p_z = spot_z + head.mins_z;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.mins_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.maxs_x;
        p_y = spot_y + head.mins_y;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.mins_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        return (pointcontents(p) == CONTENT_SKY);
};

//-------------------------------------------------------- New Code --------
//  This is a variation of InWall.  The bbox is checked if it is a
//  empty air; that is not inside solid, water, or anything else.
//  If any one point is within a brush, FALSE is returned.
//--------------------------------------------------------------------------
float(entity head, vector spot) PM_InEmpty =
{
        local   vector  p;

// Check origin.
        p = spot;
        if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

// Check bbox faces.
// Order:  1)-00  2)+00  3)0-0  4)0+0  5)00-  6)00+
        p_x = spot_x + head.mins_x;
        if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

        p_x = spot_x + head.maxs_x;
        if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

        p = spot;
        p_y = spot_y + head.mins_y;
        if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

        p_y = spot_y + head.maxs_y;
        if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

        p = spot;
        p_z = spot_z + head.mins_z;
        if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

        p_z = spot_z + head.maxs_z;
        if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

// Check bbox corners.
// Order:  1)+++  2)-++  3)+-+  4)--+  5)++-  6)-+-  7)+--  8)---
        p_x = spot_x + head.maxs_x;
        p_y = spot_y + head.maxs_y;
        if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

        p_x = spot_x + head.mins_x;
        if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

        p_x = spot_x + head.maxs_x;
        p_y = spot_y + head.mins_y;
        if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

        p_x = spot_x + head.mins_x;
        if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

        p_x = spot_x + head.maxs_x;
        p_y = spot_y + head.maxs_y;
        p_z = spot_z + head.mins_z;
        if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

        p_x = spot_x + head.mins_x;
        if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

        p_x = spot_x + head.maxs_x;
        p_y = spot_y + head.mins_y;
        if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

        p_x = spot_x + head.mins_x;
        return (pointcontents(p) == CONTENT_EMPTY);
};

//-------------------------------------------------------- New Code --------
//  This checks if the entity is in a body of liquid.
//--------------------------------------------------------------------------
float(entity head) PM_InLiquid =
{
        if (pointcontents(head.origin) == CONTENT_WATER)  return TRUE;
        if (pointcontents(head.origin) == CONTENT_SLIME)  return TRUE;
        if (pointcontents(head.origin) == CONTENT_LAVA)   return TRUE;

        return FALSE;    // Entity is not in liquid.
};

//--------------------------------------------------------------------------
//  END OF FILE.
//--------------------------------------------------------------------------
