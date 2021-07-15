module Images exposing (shoreLogo)

import Html exposing (Html)
import Svg exposing (path, svg)
import Svg.Attributes exposing (d, height, style, version, viewBox, width)


shoreLogo : Html msg
shoreLogo =
    svg [ height "1.3em", style "vertical-align:middle", version "1.1", viewBox "0 0 40 40", width "1.3em" ]
        [ path [ d "M37.3,14.3c-2.7,-3.5 -7.8,-4.2 -11.4,-1.4c-0.1,0 -0.1,0.1 -0.2,0.1l-5,4.1l0,-15.9c0,-0.7 -0.5,-1.2 -1.2,-1.2c-0.3,0 -0.6,0.1 -0.8,0.3l-15.6,12.8c-3.6,2.9 -4.1,8.1 -1.3,11.7c2.7,3.5 7.8,4.2 11.4,1.5c0.1,0 0.1,-0.1 0.2,-0.1l5,-4.1l0,15.8c0,0.7 0.5,1.2 1.2,1.2c0.3,0 0.6,-0.1 0.8,-0.3l15.6,-12.8c3.5,-2.9 4.1,-8.1 1.3,-11.7Zm-19,4.7l-6.5,5.3c-2.4,2 -6,1.6 -8.1,-0.8l-0.1,-0.1c-2,-2.6 -1.6,-6.3 0.9,-8.4l13.9,-11.3l-0.1,15.3Zm16.2,5.2l-13.8,11.2l0,-15.3l6.5,-5.3c1.2,-1 2.7,-1.4 4.2,-1.3c1.5,0.2 3,1 3.9,2.2c2.1,2.6 1.7,6.3 -0.8,8.5Z", style "fill:currentColor;fill-rule:nonzero;" ]
            []
        ]
