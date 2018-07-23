open Tea.Html

type properties_labeled_textbox = { 
  id: string;
  input_type: string;
  name: string;
  text: string
}

let view_labeled_textbox properties_labeled_textbox onchange_msg = 
 p []
 [ label [ for' properties_labeled_textbox.id ]
 [ span [] [ text properties_labeled_textbox.text ]
 ; strong [] [ abbr [ title "required" ] [ text "*" ] ]
 ]
 ; input' 
    [ onChange onchange_msg 
    ; type' properties_labeled_textbox.input_type
    ; id properties_labeled_textbox.id
    ; name properties_labeled_textbox.name ][]
 ]

let view_button title msg =
  button
    [ onClick msg
    ]
    [ text title
    ]