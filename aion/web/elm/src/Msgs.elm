module Msgs exposing(..)

import Navigation exposing (Location)

type Msg
  = UpdateUsername String
  | OnLocationChange Location
