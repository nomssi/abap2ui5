FUNCTION-POOL YABAP2UI5.                    "MESSAGE-ID ..

CONSTANTS:
  c_state_pending TYPE string VALUE 'PENDING',
  c_state_fulfilled TYPE string VALUE 'FULFILLED',
  c_state_rejected TYPE string VALUE 'REJECTED'.

DATA state TYPE string.
* INCLUDE LYABAP2UI5D...                     " Local class definition
