CLASS z2ui5_cl_app_scheme DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
" creates a UI5 application that allows the user to enter Lisp expressions and evaluate them
" (REPL = Read Eval Print Loop). The UI has a code editor, an input area, a console area (not used yet),
" and an output area.
" User events such as button clicks are used to UI in response to the user's actions.
    INTERFACES z2ui5_if_app .

    TYPES: BEGIN OF ts_screen,
            code_area         TYPE string,
            input_area        TYPE string,
            console_area      TYPE string,
            output_area       TYPE string,

            path TYPE string,
            input_port_state TYPE string,

            log TYPE string,
            output TYPE string,

            port TYPE REF TO if_serializable_object,
            input_port TYPE REF TO if_serializable_object,
            output_port TYPE REF TO if_serializable_object,
            interpreter TYPE REF TO if_serializable_object,
            environment TYPE REF TO if_serializable_object,
            code_stack TYPE string_table,
            stack TYPE REF TO if_serializable_object,
           END OF ts_screen.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA:
      BEGIN OF app, " Store the state of the class, to be passed between the methods
        check_initialized TYPE abap_bool,
        view_main         TYPE string,
        view_popup        TYPE string,
        get               TYPE z2ui5_if_client=>ty_s_get,
        next              TYPE z2ui5_if_client=>ty_s_next,
      END OF app.
    DATA screen TYPE ts_screen.

  PROTECTED SECTION.
    METHODS init IMPORTING client TYPE REF TO z2ui5_if_client.
    METHODS evaluate IMPORTING trace TYPE abap_boolean DEFAULT abap_false
                               client TYPE REF TO z2ui5_if_client.
    METHODS trace IMPORTING client TYPE REF TO z2ui5_if_client.
    METHODS format_all.
    METHODS sample_code RETURNING VALUE(result) TYPE string.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_render_main RETURNING VALUE(result) TYPE string.
    METHODS z2ui5_on_render_popup RETURNING VALUE(result) TYPE string.
  PRIVATE SECTION.

    METHODS reset.
    METHODS refresh_scheme IMPORTING client TYPE REF TO z2ui5_if_client.

    METHODS sample_code1 RETURNING VALUE(result) TYPE string.
    METHODS sample_code2 RETURNING VALUE(result) TYPE string.
    METHODS sample_code3 RETURNING VALUE(result) TYPE string.
    METHODS refresh IMPORTING client TYPE REF TO z2ui5_if_client.
    METHODS repl IMPORTING code TYPE string
                           trace TYPE abap_boolean DEFAULT abap_false
                           client TYPE REF TO z2ui5_if_client
                 RETURNING VALUE(response) TYPE string.

ENDCLASS.



CLASS Z2UI5_CL_APP_SCHEME IMPLEMENTATION.


  METHOD evaluate.
    DATA(response) = repl( code = screen-code_area
                           trace = trace
                           client = client ).
    format_all( ).
    reset( ).
    app-next-t_scroll_pos = VALUE #( ( name = 'id_console' value = '99999' )
                                     ( name = 'id_output' value = '99999' ) ).
  ENDMETHOD.


  METHOD format_all.
    screen-console_area = screen-log.
    screen-output_area = screen-output.
  ENDMETHOD.


  METHOD init.
    app-check_initialized = abap_true.
    CLEAR screen.
    refresh_scheme( client ).
    screen-code_area = sample_code( ).
    CALL FUNCTION 'Y2UI5_GET_STATE'
      IMPORTING ev_state = screen-input_port_state.
  ENDMETHOD.


  METHOD refresh.
    DATA lo_port TYPE REF TO lcl_lisp_port.
    DATA lo_log TYPE REF TO lif_log.
    DATA lo_int TYPE REF TO lcl_lisp_profiler.
    DATA lo_env TYPE REF TO lcl_lisp_environment.
    DATA lo_stack TYPE REF TO lcl_stack.

    lo_port = lcl_lisp_new=>port( iv_port_type = c_port_textual
                                  iv_input     = abap_true
                                  iv_output    = abap_true
                                  iv_error     = abap_true
                                  iv_buffered  = abap_false
                                  io_client    = client ).
    screen-port ?= lo_port.
    lo_log ?= lcl_lisp_new=>port( iv_port_type = c_port_textual
                                  iv_input     = abap_false
                                  iv_output    = abap_true
                                  iv_error     = abap_true
                                  iv_buffered  = abap_true
                                  io_client    = client ).
    screen-output_port ?= lo_log.
    lo_env ?= screen-environment.
    lo_int = lcl_lisp_profiler=>create( io_port = lo_port
                                        ii_log = lo_log
                                        io_env = lo_env
                                        iv_trace = abap_false ).

    lo_stack = NEW #( screen-code_stack ).
    screen-interpreter ?= lo_int.
    screen-environment ?= lo_int->env.
    screen-stack ?= lo_stack.
  ENDMETHOD.


  METHOD refresh_scheme.
    refresh( client ).
    reset( ).
    screen-output = |==> ABAP List Processing Output!\n|.
    screen-log = |==> ABAP Scheme -- Console { sy-uname } -- { sy-datlo DATE = ENVIRONMENT } { sy-uzeit TIME = ENVIRONMENT }\n|.
    format_all( ).
  ENDMETHOD.


  METHOD repl.
    " evaluates the Scheme expression entered in the code area
    DATA lo_int TYPE REF TO lcl_lisp_profiler. "The Lisp interpreter.
    DATA output TYPE string.
    DATA lo_port TYPE REF TO lcl_lisp_port.
    DATA lo_env TYPE REF TO lcl_lisp_environment.
    DATA lo_buffered_port TYPE REF TO lcl_lisp_buffered_port.

    TRY.
        lo_port ?= screen-port.
        lo_port->client = client.

        lo_env ?= screen-environment.
        lo_buffered_port ?= screen-output_port.

        lo_int = lcl_lisp_profiler=>create( io_port = lo_port
                                            ii_log = lo_buffered_port
                                            io_env = lo_env
                                            iv_trace = trace ).
        response = lo_int->eval_repl( EXPORTING code = code
                                      IMPORTING output = output ).
        response = |[ { lo_int->runtime } µs ] { response }|.

      CATCH cx_root INTO DATA(lx_root).
        response = lx_root->get_text( ).

    ENDTRY.

    screen-output &&= output && |\n|.
    screen-log &&= |{ code }\n=> { response }\n|.
  ENDMETHOD.


  METHOD reset.
    CAST lcl_stack( screen-stack )->push( screen-code_area ).
    CLEAR screen-code_area.
  ENDMETHOD.


  METHOD sample_code.
    CONSTANTS c_max_index TYPE i VALUE 3.

    DATA(random) = cl_abap_random=>create( seed = 42 ).
    DATA(index) = random->intinrange( low = 1 high = c_max_index ).

    CASE index.
      WHEN 1.
        result = sample_code3( ).
      WHEN 2.
        result = sample_code2( ).
      WHEN OTHERS.
        result = sample_code1( ).
    ENDCASE.
  ENDMETHOD.


  METHOD sample_code1.
    result = `(+ 1 3 4 4)`.
  ENDMETHOD.


  METHOD sample_code2.
    result = `(list-ref (list "hop" "skip" "jump") 0)    ; extract by position. Index starts with 0`.
  ENDMETHOD.


  METHOD sample_code3.
    result =    `;; https://see.stanford.edu/materials/icsppcs107/30-Scheme-Functions.pdf` &&
                `;; Predicate function: _leap-year?_ Lap year check` &&
                `;; -----------------------------------------------` &&
                `;; Illustrates the use of the 'or, 'and, and 'not special forms. The question mark after the` &&
                `;; function name isn't required, it's just customary to include a question mark at the end` &&
                `;; of a function that returns a true or false.` &&
                `;;` &&
                `;; A year is a leap year if it's divisible by 400, or if it's divisible by 4 but not by 100.` &&
                `;;` &&
                `(define (leap-year? year)` &&
                `  (or (and (zero? (remainder year 4))` &&
                `  (not (zero? (remainder year 100))))` &&
                `  (zero? (remainder year 400))))`.
  ENDMETHOD.


  METHOD trace.
    TYPES: BEGIN OF ts_header,
             user TYPE syuname,
             time TYPE syuzeit,
           END OF ts_header.
    DATA header TYPE ts_header.

    header-user = sy-uname.
    header-time = sy-uzeit.
*   Run
    evaluate( trace = abap_true
              client = client ).

  ENDMETHOD.


  METHOD Z2UI5_ON_EVENT.
    CHECK app-get-event IS NOT INITIAL.

    CASE app-get-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack ) ).

      WHEN 'DB_LOAD'.
        " screen-code_area
        client->popup_message_toast( 'Download successfull' ).

      WHEN 'DB_SAVE'.
        "lcl_mime_api=>save_data( ).
        client->popup_message_box( text = 'Upload successfull. File saved!' type = 'success' ).

      WHEN 'BUTTON_RESET'.
        refresh_scheme( client ).

      WHEN 'SCHEME_INPUT_RETURN'.
        DATA(lo_reader) = CAST z2ui5_cl_app_scheme_reader( client->get_app( client->get( )-id_prev_app ) ).
        screen-input_area = lo_reader->mv_input.
        CALL FUNCTION 'Y2UI5_CLOSE_POPUP'.  " end await process
        CALL FUNCTION 'Y2UI5_GET_STATE'
          IMPORTING ev_state = screen-input_port_state.

      WHEN 'BUTTON_INPUT_CONFIRM'.
        "lcl_lisp_port=>last_input = screen-input_area.

      WHEN 'BUTTON_INPUT_CANCEL'.
        CLEAR screen-input_area.

      WHEN 'BUTTON_PREV'.
        screen-code_area = CAST lcl_stack( screen-stack )->previous( ).

      WHEN 'BUTTON_NEXT'.
        screen-code_area = CAST lcl_stack( screen-stack )->next( ).

      WHEN 'BUTTON_TRACE'.
        trace( client ).

      WHEN 'BUTTON_SEXP'.

      WHEN 'BUTTON_EVAL'.
        evaluate( client ).

    ENDCASE.
  ENDMETHOD.

  METHOD Z2UI5_ON_INIT.
    init( client ).
    app-view_main = 'VIEW_MAIN'.
  ENDMETHOD.

  METHOD Z2UI5_ON_RENDER_MAIN.
    "DATA(view) = client->factory_view( 'ABAP_SCHEME' ).

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
              )->page(
                   id = 'id_page'
                   title = 'abapScheme - Workbench'
                   shownavbutton = abap_true
                   navbuttonpress = client->_event( 'BACK' ) ).

    page->header_content(
      )->overflow_toolbar(
        )->button(
            text  = 'Evaluate'
            press = client->_event( 'BUTTON_EVAL' )
            icon = 'sap-icon://begin'
            type    = 'Emphasized'
        )->toolbar_spacer(
        )->button( text = 'S-Expression' press = client->_event( 'BUTTON_SEXP' )
                   icon = 'sap-icon://tree'
        )->button( text = 'Trace' press = client->_event( 'BUTTON_TRACE' )
                    icon = 'sap-icon://step'
        )->button(
             text = 'Previous'
             press = client->_event( 'BUTTON_PREV' )
             icon  = 'sap-icon://navigation-left-arrow'
        )->button(
             text = 'Next'
             press = client->_event( 'BUTTON_NEXT' )
             icon  = 'sap-icon://navigation-right-arrow'
        )->button(
             text = 'Refresh'
             type  = 'Reject'
             press = client->_event( 'BUTTON_RESET' )
             icon  = 'sap-icon://delete'
        )->link( text = 'Help on..' href = 'https://github.com/nomssi/abap_scheme/wiki'
                 " icon  = 'sap-icon://learning-assistant' // 'sap-icon://sys-help'
       )->get_parent( ).


    DATA(grid) = page->grid( 'L12 M12 S12' )->content( 'layout' ).

    grid->simple_form( 'Code Editor - Untitled' )->content( 'form'
        )->code_editor( value = client->_bind( screen-code_area )
                        type = 'scheme'
                        editable = abap_true
                        height = '200px' ).

    grid->simple_form( 'Input' )->content( 'form'
         )->input( id = 'id_input'
                   showClearIcon = abap_true
                   value = client->_bind( screen-input_area )
         )->button(
              text  = 'Confirm'
              press = client->_event( 'BUTTON_INPUT_CONFIRM' )
              type  = 'Emphasized' ).

    grid->simple_form( )->content( 'form'
        )->text_area( value = client->_bind( screen-output_area )
                      id = 'id_output'
                      width = '100%'
                      height = '200px' ).

    grid->simple_form( 'Console' )->content( 'form'
      )->text_area( value = client->_bind( screen-console_area )
                    id = 'id_console'
                    width = '100%'
                    height = '200px' ).


    result = page->get_root( )->xml_get( ).

  ENDMETHOD.

  METHOD Z2UI5_ON_RENDER_POPUP.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(popup) = view->dialog(
                    contentwidth  = '500px'
                    title = 'Scheme Input Dialog'
                    icon = 'sap-icon://question-mark' ).

    popup->content(
        )->simple_form(
        )->label( 'Enter value'
        )->input( id = 'id_input'
                  showClearIcon = abap_true
                  value = client->_event( screen-input_area ) ).

    popup->footer( )->overflow_toolbar(
          )->toolbar_spacer(
          )->button(
              text  = 'Cancel'
              press = client->_event( 'BUTTON_INPUT_CANCEL' )
          )->button(
              text  = 'Confirm'
              press = client->_event( 'BUTTON_INPUT_CONFIRM' )
              type  = 'Emphasized' ).
    result = popup->get_root( )->xml_get( ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client     = client.
    app-get        = client->get( ).
    app-view_popup = ``.

    IF app-check_initialized EQ abap_false.
      app-check_initialized = abap_true.
      z2ui5_on_init( ).
    ENDIF.

    z2ui5_on_event( ).

    "view rendering
    CASE app-view_main.
      WHEN 'VIEW_MAIN'.
      app-next-xml_main = z2ui5_on_render_main( ).
    ENDCASE.

    CASE app-view_popup.
      WHEN 'VIEW_POPUP'.
      app-next-xml_popup = z2ui5_on_render_popup( ).
    ENDCASE.

    client->set_next( app-next ).
    CLEAR app-get.
    CLEAR app-next.


  ENDMETHOD.

ENDCLASS.
