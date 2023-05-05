module Or exposing
    ( Or(..)
    , value
    , onFirstMap, onSecondMap
    , justOnFirst, justOnSecond
    )

{-| One or the other.

@docs Or


## observe

@docs value


## alter

@docs onFirstMap, onSecondMap


## transform

@docs justOnFirst, justOnSecond

-}


{-| One or the other.

When (not) to use this? → [readme](https://dark.elm.dmy.fr/packages/lue-bird/elm-and-or/latest/)

-}
type Or first second
    = First first
    | Second second


{-| Treat the values from the `First` and `Second` case equally

    [ Or.First 0, Or.Second 1 ] |> List.map Or.value
    --> [ 0, 1 ]

-}
value : Or value value -> value
value =
    \or ->
        case or of
            First first ->
                first

            Second second ->
                second


{-| In case it's the `First`, change it based on it's current value

    Or.First "hello" |> Or.onFirstMap String.toUpper
    --> Or.First "HELLO"

    Or.Second "hello" |> Or.onFirstMap String.toUpper
    --> Or.Second "hello"

Prefer a `case..of` if you handle both cases

-}
onFirstMap : (first -> firstMapped) -> (Or first second -> Or firstMapped second)
onFirstMap firstChange =
    \or ->
        case or of
            Second second ->
                second |> Second

            First first ->
                first |> firstChange |> First


{-| In case it's the `Second`, change it based on it's current value

    Or.First "hello" |> Or.onSecondMap String.toUpper
    --> Or.First "hello"

    Or.Second "hello" |> Or.onSecondMap String.toUpper
    --> Or.Second "HELLO"

Prefer a `case..of` if you handle both cases

-}
onSecondMap : (second -> secondMapped) -> (Or first second -> Or first secondMapped)
onSecondMap secondChange =
    \or ->
        case or of
            First first ->
                first |> First

            Second second ->
                second |> secondChange |> Second


{-| `Just` if the first value is present, `Nothing` if the second is present

    Or.First 0 |> Or.justOnFirst --> Just 0

    Or.Second 1 |> Or.justOnFirst --> Nothing

Prefer a `case..of` if you handle both cases

-}
justOnFirst : Or first second_ -> Maybe first
justOnFirst =
    \or ->
        case or of
            Second _ ->
                Nothing

            First first ->
                first |> Just


{-| `Just` if the second value is present, `Nothing` if the first is present

    Or.First 0 |> Or.justOnSecond --> Nothing

    Or.Second 1 |> Or.justOnSecond --> Just 1

Prefer a `case..of` if you handle both cases

-}
justOnSecond : Or first_ second -> Maybe second
justOnSecond =
    \or ->
        case or of
            First _ ->
                Nothing

            Second second ->
                second |> Just
