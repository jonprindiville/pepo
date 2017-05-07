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


controlBlockStyle : Attribute msg
controlBlockStyle =
    style
        [ ( "float", "left" )
        , ( "min-width", "3em" )
        ]


renderControls : Model -> Html Msg
renderControls model =
    div
        [ style
            [ ( "background-color", "gray" )
            , ( "color", "white" )
            , ( "height", "2em" )
            ]
        ]
        [ div
            [ controlBlockStyle ]
            [ button [ onClick Toggle ]
                [ text
                    (if (model.active == True) then
                        "Stop"
                     else
                        "Start"
                    )
                ]
            ]
        , div
            [ controlBlockStyle ]
            [ input
                [ type_ "range"
                , Html.Attributes.min "0"
                , Html.Attributes.max "10"
                , value (toString model.interval)
                , step "0.1"
                , onInput AdjustInterval
                ]
                []
            , text (toString model.interval ++ " seconds")
            ]
        ]


renderPositions : Model -> Html Msg
renderPositions model =
    div
        [ style
            [ ( "text-align", "center" )
            , ( "vertical-align", "center" )
            , ( "font-size", "10em" )
            ]
        ]
        [ text
            (case ( model.active, model.position ) of
                ( True, pos ) ->
                    toString pos

                ( False, _ ) ->
                    ""
            )
        ]


view : Model -> Html Msg
view model =
    div
        []
        [ renderControls model
        , renderPositions model
        ]
