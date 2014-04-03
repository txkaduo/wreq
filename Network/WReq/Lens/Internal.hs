{-# LANGUAGE RankNTypes, TemplateHaskell #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}

module Network.WReq.Lens.Internal
    (
      HTTP.Request
    , method
    , secure
    , host
    , port
    , path
    , queryString
    , requestHeaders
    , requestBody
    , proxy
    , hostAddress
    , rawBody
    , decompress
    , redirectCount
    , responseTimeout
    , checkStatus
    , getConnectionWrapper
    , cookieJar
    -- * Useful functions
    , assoc
    , assoc2
    ) where

import Control.Lens hiding (makeLenses)
import Data.List (partition)
import Network.WReq.Lens.Machinery (makeLenses)
import qualified Network.HTTP.Client as HTTP

makeLenses ''HTTP.Request

assoc :: (Eq k) => k -> IndexedTraversal' k [(k, a)] a
assoc i = traverse . itraversed . index i

assoc2 :: Eq k => k -> Lens' [(k,a)] [a]
-- This is only a lens up to the ordering of the list (which changes
-- when we modify the list).
-- assoc2 :: (Eq b, Functor f) => b -> ([a] -> f [a]) -> [(b, a)] -> f [(b, a)]
assoc2 k f = fmap (uncurry ((++) . fmap ((,) k))) .
             _1 (f . fmap snd) . partition ((==k) . fst)
