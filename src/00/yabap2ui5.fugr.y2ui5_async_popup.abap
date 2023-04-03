FUNCTION Y2UI5_ASYNC_POPUP.
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
