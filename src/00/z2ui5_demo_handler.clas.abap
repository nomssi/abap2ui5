class Z2UI5_DEMO_HANDLER definition
  public
  final
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS Z2UI5_DEMO_HANDLER IMPLEMENTATION.


METHOD if_http_extension~handle_request.

   DATA lt_header TYPE tihttpnvp.
   server->request->get_header_fields( CHANGING fields = lt_header ).

   DATA lt_param TYPE tihttpnvp.
   server->request->get_form_fields( CHANGING fields = lt_param ).

   z2ui5_cl_http_handler=>client = VALUE #(
      t_header = lt_header
      t_param  = lt_param
      body     = server->request->get_cdata( ) ).

   DATA(lv_resp) = SWITCH #( server->request->get_method( )
      WHEN 'GET'  THEN z2ui5_cl_http_handler=>main_index_html( )
      WHEN 'POST' THEN z2ui5_cl_http_handler=>main_roundtrip( ) ).

   server->response->set_cdata( lv_resp ).
   server->response->set_status( code = 200 reason = 'success' ).

ENDMETHOD.
ENDCLASS.
