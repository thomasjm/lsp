{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE StandaloneDeriving         #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE TypeInType                 #-}
{-# OPTIONS_GHC -Wno-unticked-promoted-constructors #-}
module Language.LSP.Types.LspId where

import qualified Data.Aeson                                 as A
import           Data.Text                                  (Text)
import           Data.Hashable
import           Data.IxMap
import Language.LSP.Types.Method

-- | Id used for a request, Can be either a String or an Int
data LspId (m :: Method f Request) = IdInt Int | IdString Text
  deriving (Show,Read,Eq,Ord)

instance A.ToJSON (LspId m) where
  toJSON (IdInt i)    = A.toJSON i
  toJSON (IdString s) = A.toJSON s

instance A.FromJSON (LspId m) where
  parseJSON v@(A.Number _) = IdInt <$> A.parseJSON v
  parseJSON  (A.String  s) = return (IdString s)
  parseJSON _              = mempty

instance IxOrd LspId where
  type Base LspId = Either Int Text
  toBase (IdInt i) = Left i
  toBase (IdString s) = Right s

data SomeLspId where
  SomeLspId :: LspId m -> SomeLspId

deriving instance Show SomeLspId
instance Eq SomeLspId where
  SomeLspId a == SomeLspId b = toBase a == toBase b
instance Ord SomeLspId where
  SomeLspId a `compare` SomeLspId b = toBase a `compare` toBase b
instance Hashable SomeLspId where
  hashWithSalt n (SomeLspId a) = hashWithSalt n (toBase a)
