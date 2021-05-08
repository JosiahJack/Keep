Void function spawn_borkedvigil(vec : Vector);
var
 head : Object;
{
  head = spawn();
  head.origin = vec;
  head.deathtype = "falling";
  head.think = borkedvigilthink;
  head.nextthink = time + 0.1;
}

Void function borkedvigilthink();
var
 mark : Object;
{
  dprint("|");
  mark = find(world, soul, "yes");
  while (mark) {
    if (visible(mark)) {
      if (mark.health > 0 && mark.origin_z < -1530) {
        T_Damage(mark, self, self, 9999);
        }
      }
    mark = find(mark, soul, "yes");
    }
  self.think = borkedvigilthink;
  self.nextthink = time + 0.1;
}

