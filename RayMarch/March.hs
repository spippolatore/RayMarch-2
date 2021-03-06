module RayMarch.March where

import Control.Applicative
import Control.Monad.Trans.State
import RayMarch.Types

eps :: Float
eps = 0.0001

distance :: Point -> March (Float, Object)
distance p = do
  l <- distancer <$> get
  return $ l p

advance :: Point -> Vector -> March (Maybe Color)
advance p v = do
  w <- get
  let a = advanceCount w
  if a <= advanceLimit w
    then do
      put $ w {advanceCount = a+1}
      c <- advancer w p v
      put $ w {advanceCount = a}
      return c
    else return Nothing

reflect :: Point -> Vector -> March (Maybe Color)
reflect p v = do
  w <- get
  let a = advanceCount w
      r = reflectCount w
  if r <= reflectLimit w
    then do
      put $ w {advanceCount = 0, reflectCount = r+1}
      c <- advancer w p v
      put $ w {advanceCount = a, reflectCount = r}
      return c
    else return Nothing
