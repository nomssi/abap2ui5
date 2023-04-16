class Z2UI5_CL_APP_SCHEME_READER definition
  public
  create public .

public section.

  interfaces Z2UI5_IF_APP .

  CLASS-METHODS factory
    IMPORTING
      i_text                     TYPE string DEFAULT 'Enter Value'
      i_cancel_text              TYPE string DEFAULT 'Cancel'
      i_cancel_event             TYPE string DEFAULT 'BUTTON_CANCEL'
      i_confirm_text             TYPE string DEFAULT 'Confirm'
      i_confirm_event            TYPE string DEFAULT 'BUTTON_CONFIRM'
      i_check_show_previous_view TYPE abap_bool DEFAULT abap_true
    RETURNING
      VALUE(result)              TYPE REF TO Z2UI5_CL_APP_SCHEME_READER.


  DATA check_initialized TYPE abap_boolean.

  data MV_INPUT type STRING.

  data mv_text type STRING.
  DATA mv_cancel_text TYPE string.
  DATA mv_cancel_event TYPE string.
  DATA mv_confirm_text TYPE string.
  DATA mv_confirm_event TYPE string.
  DATA mv_check_show_previous_view TYPE abap_bool.
  data mv_next_event type string VALUE 'SCHEME_INPUT_RETURN'.

ENDCLASS.



CLASS Z2UI5_CL_APP_SCHEME_READER IMPLEMENTATION.


  METHOD factory.

    result = NEW #( ).

    result->mv_text = i_text.
    result->mv_cancel_text = i_cancel_text.
    result->mv_cancel_event = i_cancel_event.
    result->mv_confirm_text = i_confirm_text.
    result->mv_confirm_event = i_confirm_event.
    result->mv_check_show_previous_view = i_check_show_previous_view.

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~CONTROLLER.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
    ENDIF.

    CASE client->get( )-event.

      WHEN mv_confirm_event. " Go back
        mv_next_event = client->get( )-event.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack ) ).

      WHEN mv_cancel_event.  " Go back
        CLEAR mv_input.
        mv_next_event = client->get( )-event.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack ) ).

    ENDCASE.

    client->set_next( VALUE #(
      "  event = mv_next_event
        check_set_prev_view = mv_check_show_previous_view
        xml_popup = z2ui5_cl_xml_view=>factory(
         )->dialog( stretch = abap_true
                    contentwidth  = '500px'
                    icon = 'sap-icon://question-mark'
                    title = 'Scheme Input Dialog'
           )->content(
              )->simple_form(
                  )->label( mv_text
                  )->input( id = 'id_input'
                            showClearIcon = abap_true
                            value = client->_bind( mv_input )
           )->get_parent( )->get_parent(
           )->footer(
                    )->overflow_toolbar(
                        )->toolbar_spacer(
                        )->button(
                            text  = mv_confirm_text
                            press = client->_event( mv_cancel_event )
                        )->button(
                            text  = mv_confirm_text
                            press = client->_event( mv_confirm_event )
                            type  = 'Emphasized'
           )->get_root( )->xml_get( ) ) ).

  ENDMETHOD.
ENDCLASS.
