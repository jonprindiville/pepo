module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random exposing (generate, int)
import Time exposing (..)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    { position : Int
    , interval : Float
    , active : Bool
    }


newPositionCmd : Cmd Msg
newPositionCmd =
    Random.generate NewPosition (Random.int 0 5)


init : ( Model, Cmd Msg )
init =
    ( { position = 0, interval = 5.0, active = False }, Cmd.none )



-- Update


type Msg
    = Toggle
    | AdjustInterval String
    | Tick Time
    | NewPosition Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Toggle ->
            ( { model | active = not model.active }, newPositionCmd )

        AdjustInterval stringVal ->
            case String.toFloat stringVal of
                Ok value ->
                    ( { model | interval = value }, Cmd.none )

                Err errMsg ->
                    ( model, Cmd.none )

        Tick time ->
            if model.active then
                ( model, newPositionCmd )
            else
                ( model, Cmd.none )

        NewPosition pos ->
            ( { model | position = pos }, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.active then
        every (second * model.interval) Tick
    else
        Sub.none



-- View


flexboxSpacer : String -> Html Msg
flexboxSpacer cssWidth =
    div [ style [ ( "width", cssWidth ) ] ] []


controlStyle : Attribute msg
controlStyle =
    style [ ( "margin", "0.5em" ) ]


renderToggleControl : Model -> Html Msg
renderToggleControl model =
    div
        [ controlStyle ]
        [ button [ onClick Toggle ]
            [ text
                (if (model.active == True) then
                    "Stop"
                 else
                    "Start"
                )
            ]
        ]


renderIntervalControl : Model -> Html Msg
renderIntervalControl model =
    div
        [ controlStyle ]
        [ input
            [ type_ "range"
            , Html.Attributes.min "0"
            , Html.Attributes.max "10"
            , value (toString model.interval)
            , step "0.1"
            , onInput AdjustInterval
            , style [ ( "width", "25vw" ) ]
            ]
            []
        , text (toString model.interval ++ " seconds")
        ]


renderControls : Model -> Html Msg
renderControls model =
    div
        [ style
            [ ( "background-color", "gray" )
            , ( "color", "white" )
            , ( "height", "4em" )
            , ( "display", "flex" )
            , ( "flex-direction", "row" )
            , ( "justify-content", "space-around" )
            , ( "align-items", "center" )
            ]
        ]
        [ renderToggleControl model
        , flexboxSpacer "30%"
        , renderIntervalControl model
        ]


renderPositions : Model -> Html Msg
renderPositions model =
    div
        [ style
            [ ( "height", "100%" )
            , ( "text-align", "center" )
            , ( "font-size", "10em" )
            , ( "display", "flex" )
            , ( "flex-direction", "column" )
            , ( "justify-content", "center" )
            ]
        ]
        [ div
            []
            [ text
                (case ( model.active, model.position ) of
                    ( True, pos ) ->
                        toString pos

                    ( False, _ ) ->
                        ""
                )
            ]
        ]


view : Model -> Html Msg
view model =
    div
        [ style [ ( "height", "100%" ) ] ]
        [ renderControls model
        , renderPositions model
        ]
