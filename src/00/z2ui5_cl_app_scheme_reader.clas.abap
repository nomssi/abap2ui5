class Z2UI5_CL_APP_SCHEME_READER definition
  public
  create public .

public section.

  interfaces Z2UI5_IF_APP .

  data MV_INPUT type STRING .

  DATA check_initialized TYPE abap_boolean.

ENDCLASS.



CLASS Z2UI5_CL_APP_SCHEME_READER IMPLEMENTATION.


  METHOD Z2UI5_IF_APP~CONTROLLER.

    CASE client->get( )-lifecycle_method.

      WHEN client->cs-lifecycle_method-on_event.

        IF check_initialized = abap_false.

          check_initialized = abap_true.
          client->set( set_prev_view = abap_true ).
          client->popup_view( 'POPUP_TO_INPUT' ).

        ENDIF.

        CASE client->get( )-event.

         WHEN 'BUTTON_CONFIRM'. " Go back

          WHEN 'BUTTON_CANCEL'.  " Go back
            CLEAR mv_input.

          WHEN OTHERS.
            RETURN.
        ENDCASE.

        client->nav_app_leave( client->get( )-id_prev_app_stack ).
        client->set( event = 'SCHEME_INPUT_RETURN' ).

      WHEN client->cs-lifecycle_method-on_rendering.

        DATA(view) = client->factory_view( 'POPUP_TO_INPUT' ).
        view->dialog( contentwidth  = '500px'
                      icon = 'sap-icon://question-mark'
                      title = 'Scheme Input Dialog'
          )->content(
              )->simple_form(
                  )->label( 'Enter Value'
                  )->input( id = 'id_input'
                            showClearIcon = abap_true
                            value = client->_bind( mv_input )
          )->get_parent( )->get_parent(
          )->footer( )->overflow_toolbar(
              )->toolbar_spacer(
              )->button(
                  text  = 'Cancel'
                  press = client->_event( 'BUTTON_CANCEL' )
              )->button(
                  text  = 'Confirm'
                  press = client->_event( 'BUTTON_CONFIRM' )
                  type  = 'Emphasized' ).

    ENDCASE.


  ENDMETHOD.
ENDCLASS.
