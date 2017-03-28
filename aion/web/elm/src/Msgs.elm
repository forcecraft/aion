module Msgs exposing(..)

import Navigation exposing (Location)

type Msg
  = Username String
  | OnLocationChange Location
