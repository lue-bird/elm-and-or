> both or only one of them

# [`AndOr`](AndOr)

The basic types of this package look like this:
```elm
type AndOr first second
    = Both ( first, second )
    | Only (Or first second)

type Or first second
    = First first
    | Second second
```

Both types can be quite useful! ...But first

## ❌ misuse-cases

[`AndOr`](AndOr#AndOr) and [`Or`](Or#Or) are prone to misuse, just like `Maybe`, tuple, `Bool` etc.

When there is a representation of your data that's more descriptive, use that instead!

Example:
Modeling the result of an operation that can fail, succeed or succeed with warnings
```elm
type alias Fallible a =
    AndOr a Error
```
This is problematic from multiple standpoints:
  - Why should error and warning types be required to be the same?
  - Why not have a unified case for success:
    ```elm
    type alias Fallible a =
        Or { result : a, warnings : List Warning } Error
    ```
  - Who tells you that "first" means "success" and "second" means "error"? (or the other way round?)
  - Why not use descriptive names:
    ```elm
    type Fallible a
        = Success { result : a, warnings : List Warning }
        | UnrecoverableError Error
    ```

## ✔️ use-cases

[`AndOr`](AndOr#AndOr) and [`Or`](Or#Or) are useful for generic operations where no descriptive names exist –
similar to how tuples are used for a partition result because there is no information
on what each side means.

  - generic diffs
      - see [`KeysSet.fold2From`](https://dark.elm.dmy.fr/packages/lue-bird/elm-keysset/latest/KeysSet#fold2From) which is similar to `Dict.merge` but more comprehensible and easier to work with thanks to [`AndOr`](AndOr#AndOr)
  - map2 for a structure (List, Array, ...) where overflow elements aren't disregarded:
    ```elm
    List.AndOr.map2 : (AndOr a b -> c) -> ( List a, List b ) -> List c
    List.AndOr.map2 combine lists =
        case lists of
            ( firstList, [] ) ->
                firstList |> List.map (\first -> Only (Or.First first) |> combine)
            ( [], secondList ) ->
                secondList |> List.map (\first -> Only (Or.Second first) |> combine)
            ( firstHead :: firstTail, secondHead :: secondTail ) ->
                AndOr.Both firstHead secondHead |> combine |> map2BothOrOnly firstTail secondTail
    ```
  - type-safe partitioning for a structure (List, Array, ...):
    ```elm
    List.Or.partition : (a -> Or first second) -> (List a -> ( List first, List second ))
    List.Or.partition chooseSide =
        \list ->
            case list of
                [] ->
                    []
                head :: tail ->
                    case head |> chooseSide of
                        Or.First headFirst ->
                            tail |> List.Or.partition |> Tuple.mapFirst ((::) headFirst)
                        Or.Second headSecond ->
                            tail |> List.Or.partition |> Tuple.mapSecond ((::) headSecond)
    ```

## prior art – [`AndOr`](AndOr)

  - [`joneshf/elm-these`](https://dark.elm.dmy.fr/packages/joneshf/elm-these/latest/)
  - [haskell's `Data.These`](https://hackage.haskell.org/package/these-1.2/docs/Data-These.html)

All of them don't separate out the "only one of both" case.

## prior art – [`Or`](Or)

  - [`kingwither/elmeither`](https://dark.elm.dmy.fr/packages/kingwither/elmeither/latest/)
      - (too few) simple helpers
  - [`toastal/either`](https://dark.elm.dmy.fr/packages/toastal/either/latest/)
      - a lot of helpers, though with weird haskell-ish names like `voidLeft` for setting, `singleton` for `Right` etc.
  - [haskell's `Data.Either`](https://hackage.haskell.org/package/base-4.18.0.0/docs/Data-Either.html)

All of them use `Left` and `Right` as variant names whereas [`Or`](Or#Or)'s `First` and `Second` are consistent with elm's tuple part names.


## suggestions?

The API is pretty slim, only covering the needs I could think of.
If you have an idea for a useful helper → [contribute](https://github.com/lue-bird/elm-and-or/blob/master/contributing.md)
