module RayMarch.Distance where

import RayMarch.Types
import RayMarch.Quaternion
import RayMarch.Operate

(<&>) :: Distance -> Distance -> Distance
(x <&> y) p = let
    a@(ad,ao) = x p
    b@(bd,bo) = y p
  in if ad > bd then a else b

(<|>) :: Distance -> Distance -> Distance
(x <|> y) p = let
    a@(ad,ao) = x p
    b@(bd,bo) = y p
  in if ad < bd then a else b

(<~>) :: Distance -> Distance -> Distance
(x <~> y) p = let
    (ad,ao) = x p
    (bd,bo) = y p
    d = ad`smin`bd
    r = (d-ad)/(bd-ad)
    obj p v = do
      a <- ao p v
      b <- bo p v
      return $ a<*>(1-r) <+> b<*>r
  in (d,obj)

(<\>) :: Distance -> Distance -> Distance
(x <\> y) p = let
    a@(ad,ao) = x p
    b@(bd,bo) = y p
  in (ad`max`(-bd),ao)
 
scale :: Float -> Distance -> Distance
scale s d p = let
    (l,o) = d (p </> s)  
  in (l*s, o)

transpose :: Vector -> Distance -> Distance
transpose v d p = d (p <-> v)

rotate :: Quaternion -> Distance -> Distance
rotate q d p = d $ apply (inverse q) p
