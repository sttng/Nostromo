.module Nostromo
End:
TopEdgeClip = (End + $FF) & $FF00
BottomEdgeClip = Nostromo.TopEdgeClip + $100
Maths.Trig.Table = Nostromo.BottomEdgeClip + $100
.include "Variables.inc"
.endmodule