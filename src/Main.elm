module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Events
import Images


type alias Model =
    FormData


type Msg
    = UpdateFormField Field
    | SubmitForm


type alias FormData =
    { firstName : Field
    , lastName : Field
    , gender : Field
    }


type alias FieldError =
    Maybe String


type Field
    = FirstName FieldError String
    | LastName FieldError String
    | Gender FieldError String


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


initialFormData : FormData
initialFormData =
    { firstName = FirstName Nothing ""
    , lastName = LastName Nothing ""
    , gender = Gender Nothing ""
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialFormData, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateFormField field ->
            ( updateFormField field model, Cmd.none )

        SubmitForm ->
            ( model, Cmd.none )



-- TODO: Implement the function body for `updateFormField` so it actually updates the form data


updateFormField : Field -> Model -> Model
updateFormField _ data =
    let
        _ =
            Debug.log "Implement `updateFormField` to actually update the model" ()
    in
    data


getFieldValue : Field -> String
getFieldValue field =
    case field of
        FirstName _ val ->
            val

        LastName _ val ->
            val

        Gender _ val ->
            val


view : Model -> Html Msg
view model =
    Html.div [ Attr.class "form-container" ]
        [ Html.header [ Attr.class "logo-container" ] [ Images.shoreLogo ]
        , Html.form [ Events.onSubmit SubmitForm ]
            [ inputWrapper
                []
                [ renderFormInput "First name" <|
                    Html.input
                        [ Attr.type_ "text"
                        , Events.onInput (UpdateFormField << FirstName Nothing)
                        , Attr.value <| getFieldValue model.firstName
                        ]
                        []
                , renderFormInput "Last name" <|
                    Html.input
                        [ Attr.type_ "text"
                        , Events.onInput (UpdateFormField << LastName Nothing)
                        , Attr.value <| getFieldValue model.lastName
                        ]
                        []
                , renderFormRadioGroup "Gender"
                    [ ( "Male", "male" ), ( "Female", "female" ) ]
                    (getFieldValue model.gender)
                    (UpdateFormField << Gender Nothing)
                ]
            ]
        , Html.div [ Attr.class "submit-button-container" ]
            [ Html.button [ Attr.class "submit-button" ]
                [ Html.text "Submit"
                ]
            ]
        ]


inputWrapper : List (Html.Attribute msg) -> List (Html msg) -> Html msg
inputWrapper =
    Html.node "shore-input-wrapper"


renderFormInput : String -> Html Msg -> Html Msg
renderFormInput fieldLabel field =
    Html.div []
        [ inputWrapper
            []
            [ field
            , Html.label [] [ Html.text fieldLabel ]
            ]
        ]



-- TODO: Implement the function body for `showFormData` so it adds an Html element with all the entered input dumped


showFormData : Model -> Html Never
showFormData _ =
    Html.div [] [ Html.text "Dump user input" ]


type alias RadioButtonConfig =
    { name : String
    , label : String
    , value : String
    , isSelected : Bool
    , onCheck : String -> Msg
    }


renderFormRadioGroup : String -> List ( String, String ) -> String -> (String -> Msg) -> Html Msg
renderFormRadioGroup groupLabel labelsAndValues selectedValue toMsg =
    inputWrapper
        [ Attr.class "radio-buttons-group" ]
        (Html.label [] [ Html.text groupLabel ]
            :: List.map
                (\( label, value ) ->
                    { name = groupLabel
                    , label = label
                    , value = value
                    , isSelected = value == selectedValue
                    , onCheck = toMsg
                    }
                        |> renderFormRadioButton
                )
                labelsAndValues
        )


renderFormRadioButton : RadioButtonConfig -> Html Msg
renderFormRadioButton { name, label, value, isSelected, onCheck } =
    Html.node "shore-radio-wrapper"
        []
        [ Html.input
            [ Attr.type_ "radio"
            , Attr.name name
            , Attr.value value
            , Attr.checked isSelected
            , Events.onInput onCheck
            ]
            []
        , Html.label [] [ Html.text label ]
        ]
