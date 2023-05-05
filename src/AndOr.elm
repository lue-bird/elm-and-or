module AndOr exposing
    ( AndOr(..)
    , onBothAlter, onOnlyAlter
    , justOnBoth, justOnOnly
    )

{-| One, the other or both.

@docs AndOr


## alter

@docs onBothAlter, onOnlyAlter


## transform

@docs justOnBoth, justOnOnly

-}

import Or exposing (Or)


{-| Either both or only the [first or second](Or#Or).

When (not) to use this? → [readme](https://dark.elm.dmy.fr/packages/lue-bird/elm-and-or/latest/)

-}
type AndOr first second
    = Both ( first, second )
    | Only (Or first second)


{-| In case we have `Both`, change them based on their current values

    import Or


    AndOr.Only (Or.First "hello")
        |> AndOr.onBothAlter (Tuple.mapFirst String.toUpper)
    --> AndOr.Only (Or.First "hello")

    AndOr.Both ( "hello", "there" )
        |> AndOr.onBothAlter (Tuple.mapFirst String.toUpper)
    --> AndOr.Both ( "HELLO", "there" )

Prefer a `case..of` if you handle both cases

-}
onBothAlter : (( first, second ) -> ( first, second )) -> (AndOr first second -> AndOr first second)
onBothAlter bothChange =
    \andOr ->
        case andOr of
            Only only ->
                only |> Only

            Both both ->
                both |> bothChange |> Both


{-| In case we have `Only` one of them, change it based on its current value

    import Or


    AndOr.Only (Or.First "hello")
        |> AndOr.onOnlyAlter (Or.onFirstMap String.toUpper)
    --> AndOr.Only (Or.First "HELLO")

    AndOr.Both ( "hello", "there" )
        |> AndOr.onOnlyAlter (Or.onFirstMap String.toUpper)
    --> AndOr.Both ( "hello", "there" )

Prefer a `case..of` if you handle both cases

-}
onOnlyAlter : (Or first second -> Or first second) -> (AndOr first second -> AndOr first second)
onOnlyAlter onlyChange =
    \andOr ->
        case andOr of
            Both both ->
                both |> Both

            Only only ->
                only |> onlyChange |> Only


{-| `Just` if both values are present, `Nothing` if only one is present

    import Or


    AndOr.Both ( 0, 1 ) |> AndOr.justOnBoth --> Just ( 0, 1 )

    AndOr.Only (Or.First 0) |> AndOr.justOnBoth --> Nothing

    AndOr.Only (Or.Second 1) |> AndOr.justOnBoth --> Nothing

Prefer a `case..of` if you handle both cases

-}
justOnBoth : AndOr first second -> Maybe ( first, second )
justOnBoth =
    \andOr ->
        case andOr of
            Only _ ->
                Nothing

            Both both ->
                both |> Just


{-| `Just` if only one value is present, `Nothing` if both are present

    import Or


    AndOr.Both ( 0, 1 ) |> AndOr.justOnOnly --> Nothing

    AndOr.Only (Or.First 0) |> AndOr.justOnOnly --> Just (Or.First 0)

    AndOr.Only (Or.Second 1) |> AndOr.justOnOnly --> Just (Or.Second 1)

    AndOr.Only (Or.Second 1)
        |> AndOr.justOnOnly
        |> Maybe.andThen Or.justOnSecond
    --> Just 1

Prefer a `case..of` if you handle both cases

-}
justOnOnly : AndOr first second -> Maybe (Or first second)
justOnOnly =
    \andOr ->
        case andOr of
            Both _ ->
                Nothing

            Only only ->
                only |> Just
