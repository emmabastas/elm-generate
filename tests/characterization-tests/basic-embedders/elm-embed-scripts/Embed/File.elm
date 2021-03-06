module Embed.File exposing (read)

{-|

@docs read

-}

import Embed
import Embed.Internal
import Json.Decode as Decode
import Json.Encode as Encode


{-| Read the contents of a file on disk.

The path is read relative to the directory where elm.json is located.

    read "myMarkdown.md"

    read "/home/user/myElmProject/myMarkdown.md"

-}
read : String -> Embed.Task String
read path =
    Embed.andThen
        (\result ->
            case result of
                Ok contents ->
                    Embed.succeed contents

                Err message ->
                    Embed.fail message
        )
        (read_ path)


read_ : String -> Embed.Task (Result String String)
read_ path =
    Embed.Internal.Task "Embed.File.read_"
        [ Encode.string path ]
        (Decode.oneOf
            [ Decode.field "Ok" (Decode.map Ok Decode.string)
            , Decode.field "Err" (Decode.map Err Decode.string)
            ]
            |> Decode.map Embed.succeed
        )
