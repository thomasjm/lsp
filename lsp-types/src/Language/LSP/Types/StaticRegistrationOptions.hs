{-# LANGUAGE TemplateHaskell #-}
-- Cyclic dependencies mean we have to put poor StaticRegistrationOptions on its own
module Language.LSP.Types.StaticRegistrationOptions where

import Data.Aeson.TH
import Data.Text (Text)
import Language.LSP.Types.Utils

data StaticRegistrationOptions =
  StaticRegistrationOptions
    { _id :: Maybe Text
    } deriving (Read,Show,Eq)
deriveJSON lspOptions ''StaticRegistrationOptions
