module Select.Select.RemoveItem exposing (svgPath, view)

import Html.Attributes as HtmlAttrs
import Select.Config exposing (Config)
import Select.Styles as Styles
import Svg exposing (..)
import Svg.Attributes as Attrs


view : Config userMsg item -> Svg msg
view config =
    svg
        ([ Attrs.class (config.removeItemSvgClass ++ Styles.removeItemSvgClass)
         , Attrs.width "14"
         , Attrs.height "14"
         , Attrs.viewBox "0 0 20 20"
         ]
            ++ ((config.removeItemSvgStyles ++ Styles.removeItemSvgStyles)
                    |> List.map (\( f, s ) -> HtmlAttrs.style f s)
               )
        )
        [ path [ Attrs.d svgPath ] [] ]


svgPath : String
svgPath =
    "M14.348 14.849c-0.469 0.469-1.229 0.469-1.697 0l-2.651-3.030-2.651 3.029c-0.469 0.469-1.229 0.469-1.697 0-0.469-0.469-0.469-1.229 0-1.697l2.758-3.15-2.759-3.152c-0.469-0.469-0.469-1.228 0-1.697s1.228-0.469 1.697 0l2.652 3.031 2.651-3.031c0.469-0.469 1.228-0.469 1.697 0s0.469 1.229 0 1.697l-2.758 3.152 2.758 3.15c0.469 0.469 0.469 1.229 0 1.698z"
