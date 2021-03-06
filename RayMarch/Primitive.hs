module RayMarch.Primitive where

import RayMarch.Types

sphere :: Float -> Object -> Distance
sphere r o p = (len p - r, o)

box :: Vector -> Object -> Distance
box v o p = let
    d = each abs p <-> v
  in (0`min`fold max d + len (each (max 0) d), o)

plane :: Vector -> Float -> Object -> Distance
plane v d o p = (p`dot`v+d, o)
