-- ABWORDS

{-# LANGUAGE CPP #-}
#define OPTS OPTIONS_GHC
{-# OPTS -O3 #-}

import Data.List
import Control.Monad

isNice w = go 0 0 w
  where
    go aN bN []       = aN == bN
    go aN bN ('a':xs) = go (aN + 1) bN xs
    go aN bN ('b':xs) | aN == bN  = False 
                      | otherwise = go aN (bN + 1) xs

sub = tail . init

splits w = zip (tail (inits w)) (tail (init (tails w)))

sim w1@(_:_:_) w2@(_:_:_) = isNice w1' && isNice w2' && sim w1' w2'
                         || any p (zip3 (splits w1) w2s (reverse w2s))
  where
    w1' = sub w1
    w2' = sub w2
    w2s = splits w2
    p ((w1L, w1R), (w2L, w2R), (w2L', w2R'))
      = isNice w1L   && isNice w1R &&
      ( isNice w2L   && isNice w2R
     && sim w1L w2L  && sim w1R w2R
     || isNice w2L'  && isNice w2R'
     && sim w1L w2R' && sim w1R w2L' )

sim [] [] = True
sim _  _  = False

subseqs2 (x:xs) = map ((,) x) xs ++ subseqs2 xs
subseqs2 _      = []

diversity = length
          . filter (not . uncurry sim)
          . subseqs2

main = do n <- readLn
          forM_ [1..n] $ \_ -> do
            k  <- readLn
            ws <- sequence (replicate k getLine)
            print (diversity ws)
            getLine

a = "aabaabbbab"
b = "abababaabb"
c = "abaaabbabb"

{-
a = "aabaabbbab"
b = "abababaabb"
c = "abaaabbabb"

x = any p (splits b)
  where
    p (i, w1L, w1R) = isNice w1L   && isNice w1R

test = map (uncurry sim)
         [ (a, b), (b, a)
         , (a, c), (c, a)
         , (b, c), (c, b) ]
       
trace (w1++","++w2) $ 

{-
splitsI w = go [] 0 w
  where
    go l i []       = []
    go l i xs@(h:t) = (i, reverse l, xs)
                    : go (h : l) (i + 1) t
-}
-}
                            