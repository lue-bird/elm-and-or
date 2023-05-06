module And exposing
    ( And
    , firstMap, secondMap
    )

{-| two parts as one

@docs And


## change

@docs firstMap, secondMap

-}


{-| Both a first and second part, conveniently represented as a tuple
-}
type alias And first second =
    ( first, second )


{-| Change the first part based on its current value
-}
firstMap : (first -> firstMapped) -> (And first second -> And firstMapped second)
firstMap firstChange =
    \and ->
        and |> Tuple.mapFirst firstChange


{-| Change the second part based on its current value
-}
secondMap : (second -> secondMapped) -> (And first second -> And first secondMapped)
secondMap secondChange =
    \and ->
        and |> Tuple.mapSecond secondChange
