module And exposing
    ( And
    , firstMap, secondMap
    )

{-| two parts as one

@docs And


## change

@docs firstMap, secondMap

-}


{-| Both a first and second part, conveniently represented as a tuple.

Using this type instead of a tuple
visually unifies it with all the other types such as `List`, `Maybe`, or `Result`.

This in my opinion reads a tad better, especially as a type argument:

    List (Maybe ( String, Int ))

becomes:

    List (Maybe (And String Int))

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
