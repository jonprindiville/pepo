module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random exposing (generate, int)
import Svg exposing (..)
import Svg.Attributes exposing (..)
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
    div [ Html.Attributes.style [ ( "width", cssWidth ) ] ] []


controlStyle : Html.Attribute msg
controlStyle =
    Html.Attributes.style [ ( "margin", "0.5em" ) ]


renderToggleControl : Model -> Html Msg
renderToggleControl model =
    div
        [ controlStyle ]
        [ button [ onClick Toggle ]
            [ Html.text
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
        [ controlStyle
        , Html.Attributes.style
            [ ( "width", "25vw" )
            , ( "text-align", "center" )
            ]
        ]
        [ input
            [ Html.Attributes.type_ "range"
            , Html.Attributes.min "0.1"
            , Html.Attributes.max "10"
            , value (toString model.interval)
            , step "0.1"
            , onInput AdjustInterval
            , Html.Attributes.style [ ( "width", "25vw" ) ]
            ]
            []
        , Html.text (toString model.interval ++ "s per position")
        ]


renderControls : Model -> Html Msg
renderControls model =
    div
        [ Html.Attributes.style
            [ ( "background-color", "gray" )
            , ( "color", "white" )
            , ( "height", "10vh" )
            , ( "display", "flex" )
            , ( "flex-direction", "row" )
            , ( "justify-content", "space-around" )
            , ( "align-items", "center" )
            , ( "z-index", "1" )
            ]
        ]
        [ renderToggleControl model
        , flexboxSpacer "30%"
        , renderIntervalControl model
        ]


courtLineStyle : List (Svg.Attribute msg)
courtLineStyle =
    [ stroke "black"
    , strokeWidth "70"
    , strokeLinejoin "round"
    , fill "none"
    ]


svgCourt : Html Msg
svgCourt =
    -- the dimensions here are based on figures in millimeters that I pulled
    -- from a diagram of an actual squash court
    svg
        [ Html.Attributes.style
            [ ( "position", "absolute" )
            , ( "height", "90vh" )
            , ( "width", "100vw" )
            , ( "opacity", "0.3" )
            , ( "z-index", "-1" )
            ]
        , viewBox "0 0 6400 9750"
        ]
        [ polyline
            -- left service box
            (courtLineStyle ++ [ points "0,7140 1600,7140 1600,5490" ])
            []
        , polyline
            -- right service box
            (courtLineStyle ++ [ points "4800,5490 4800,7140 6400,7140" ])
            []
        , line
            -- front of service boxes
            (courtLineStyle ++ [ x1 "0", x2 "6400", y1 "5490", y2 "5490" ])
            []
        , line
            -- half court line
            (courtLineStyle ++ [ x1 "3200", x2 "3200", y1 "5490", y2 "9750" ])
            []
        , polyline
            -- court outline
            [ stroke "grey"
            , strokeWidth "30"
            , fill "none"
            , points "0,0 6400,0 6400,9750 0,9750 0,0"
            ]
            []
        ]


renderPositions : Model -> Html Msg
renderPositions model =
    div
        [ Html.Attributes.style
            [ ( "height", "90vh" )
            , ( "text-align", "center" )
            , ( "font-size", "20vw" )
            , ( "display", "flex" )
            , ( "flex-direction", "column" )
            , ( "justify-content", "center" )
            ]
        ]
        [ svgCourt
        , div
            []
            [ Html.text
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
        [ Html.Attributes.style
            [ ( "height", "100%" )
            , ( "font-family", "sans-serif" )
            ]
        ]
        [ renderControls model
        , renderPositions model
        ]
