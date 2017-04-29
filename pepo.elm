module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
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


init : ( Model, Cmd Msg )
init =
    ( { position = 0, interval = 5.0, active = False }, Cmd.none )



-- Update


type Msg
    = Toggle
    | AdjustInterval String
    | Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Toggle ->
            ( { model | active = not model.active }, Cmd.none )

        AdjustInterval stringVal ->
            case String.toFloat stringVal of
                Ok value ->
                    ( { model | interval = value }, Cmd.none )

                Err errMsg ->
                    ( model, Cmd.none )

        Tick time ->
            if model.active then
                ( { model | position = (model.position + 1) % 6 }, Cmd.none )
            else
                ( model, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.active then
        every (second * model.interval) Tick
    else
        Sub.none



-- View


controlBlockAttrs : Attribute msg
controlBlockAttrs =
    style
        [ ( "float", "left" )
        , ( "min-width", "3em" )
        ]


positionAttrs : Attribute msg
positionAttrs =
    style
        [ ( "text-align", "center" )
        , ( "vertical-align", "center" )
        , ( "font-size", "10em" )
        ]


view : Model -> Html Msg
view model =
    div
        []
        [ div
            [ style
                [ ( "background-color", "gray" )
                , ( "color", "white" )
                , ( "height", "2em" )
                ]
            ]
            [ div
                [ controlBlockAttrs ]
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
                [ controlBlockAttrs ]
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
        , div
            [ positionAttrs ]
            [ text
                (case ( model.active, model.position ) of
                    ( True, pos ) ->
                        toString pos

                    ( False, _ ) ->
                        ""
                )
            ]
        ]
