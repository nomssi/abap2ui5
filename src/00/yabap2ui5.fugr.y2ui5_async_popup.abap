FUNCTION y2ui5_async_popup.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(FOR) TYPE  STRING
*"  CHANGING
*"     VALUE(STATE) TYPE  STRING
*"----------------------------------------------------------------------

  TRY.

    state = c_state_pending.


  CATCH cx_root.
    state = c_state_rejected.
  ENDTRY.

ENDFUNCTION.
