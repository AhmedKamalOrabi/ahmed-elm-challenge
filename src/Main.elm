module Main exposing (main)

import Browser
import Debug exposing (log)
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Events
import Images


type alias Model =
    FormData


type Msg
    = UpdateFormField Field
    | SubmitForm
    | HandleReset


type alias FormData =
    { firstName : Field
    , lastName : Field
    , gender : Field
    , formIsValid : Bool
    , formIsSubmitted : Bool
    , isFirstNameValid : Bool
    , isLastNameValid : Bool
    , isGenderValid : Bool
    }


type Field
    = FirstName String String
    | LastName String String
    | Gender String String


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
    { firstName = FirstName "" ""
    , lastName = LastName "" ""
    , gender = Gender "" ""
    , formIsValid = False
    , formIsSubmitted = False
    , isFirstNameValid = False
    , isLastNameValid = False
    , isGenderValid = False
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
            ( submitForm model, Cmd.none )

        HandleReset ->
            ( handleReset model, Cmd.none )


submitForm : Model -> Model
submitForm model =
    let
        isFirstNameValid =
            String.isEmpty (getFieldValue model.firstName) == False

        isLastNameValid =
            String.isEmpty (getFieldValue model.lastName) == False

        isGenderValid =
            String.isEmpty (getFieldValue model.gender) == False
    in
    if isFirstNameValid && isLastNameValid && isGenderValid then
        { model | formIsValid = True, formIsSubmitted = True, isFirstNameValid = isFirstNameValid, isLastNameValid = isLastNameValid, isGenderValid = isGenderValid }

    else
        { model | formIsValid = False, formIsSubmitted = True, isFirstNameValid = isFirstNameValid, isLastNameValid = isLastNameValid, isGenderValid = isGenderValid }



-- TODO: Implement the function body for `updateFormField` so it actually updates the form data


updateFormField : Field -> Model -> Model
updateFormField field model =
    let
        newValue =
            getFieldValue field

        isValidValue =
            String.isEmpty newValue == False
    in
    case field of
        FirstName _ _ ->
            { model | firstName = FirstName "" newValue, isFirstNameValid = isValidValue }

        LastName _ _ ->
            { model | lastName = LastName "" newValue, isLastNameValid = isValidValue }

        Gender _ _ ->
            { model | gender = Gender "" newValue, isGenderValid = isValidValue }


getFieldValue : Field -> String
getFieldValue field =
    case field of
        FirstName _ val ->
            val

        LastName _ val ->
            val

        Gender _ val ->
            val


handleReset : Model -> Model
handleReset model =
    { model
        | firstName = FirstName "" ""
        , lastName = LastName "" ""
        , gender = Gender "" ""
        , formIsValid = False
        , formIsSubmitted = False
        , isFirstNameValid = False
        , isLastNameValid = False
        , isGenderValid = False
    }


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.div (showFormValues model)
            [ Html.h2 [] [ Html.text "Form Values" ]
            , Html.ul []
                [ Html.li []
                    [ Html.strong [] [ Html.text "First name: " ]
                    , Html.span [] [ Html.text (getFieldValue model.firstName) ]
                    ]
                , Html.li []
                    [ Html.strong [] [ Html.text "Last name: " ]
                    , Html.span [] [ Html.text (getFieldValue model.lastName) ]
                    ]
                , Html.li []
                    [ Html.strong [] [ Html.text "Gender: " ]
                    , Html.span [] [ Html.text (getFieldValue model.gender) ]
                    ]
                ]
            , Html.button [ Events.onClick HandleReset ] [ Html.text "Reset" ]
            ]
        , Html.div [ Attr.class "form-container" ]
            [ Html.span (showIsFormValidOrNot model) [ Html.text "Form is invalid" ]
            , Html.header [ Attr.class "logo-container" ] [ Images.shoreLogo ]
            , Html.form [ Events.onSubmit SubmitForm ]
                [ inputWrapper
                    []
                    [ renderFormInput "First name" <|
                        Html.input
                            ([ Attr.type_ "text"
                             , Attr.autofocus True
                             , Events.onInput (UpdateFormField << FirstName "")
                             , Attr.value <| getFieldValue model.firstName
                             ]
                                ++ getFirstNameClass model
                            )
                            []
                    , renderFormInput "Last name" <|
                        Html.input
                            ([ Attr.type_ "text"
                             , Events.onInput (UpdateFormField << LastName "")
                             , Attr.value <| getFieldValue model.lastName
                             ]
                                ++ getLastNameClass model
                            )
                            []
                    , renderFormRadioGroup "Gender"
                        [ ( "Male", "male" ), ( "Female", "female" ) ]
                        (getFieldValue model.gender)
                        (UpdateFormField << Gender "")
                    ]
                , Html.div [ Attr.class "submit-button-container" ]
                    [ Html.button [ Attr.class "submit-button", Attr.type_ "submit" ]
                        [ Html.text "Submit"
                        ]
                    ]
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


showFormValues model =
    if model.formIsSubmitted == True && model.formIsValid == True then
        []

    else
        [ Attr.class "none" ]


getFirstNameClass model =
    if model.formIsSubmitted && model.isFirstNameValid == False then
        [ Attr.class "inputError" ]

    else
        []


getLastNameClass model =
    if model.formIsSubmitted && model.isLastNameValid == False then
        [ Attr.class "inputError" ]

    else
        []


getGenderClass model =
    if model.formIsSubmitted && model.isGenderValid == False then
        [ Attr.class "inputError" ]

    else
        []


showIsFormValidOrNot model =
    if model.formIsSubmitted && model.formIsValid == False then
        [ Attr.class "error" ]

    else
        [ Attr.class "none" ]



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
