*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

INTERFACE lif_unit_test.
ENDINTERFACE.

  TYPES tv_char TYPE c LENGTH 1.
  TYPES tv_char2 TYPE c LENGTH 2.
  TYPES tv_char03 TYPE c LENGTH 3.
  TYPES tv_char04 TYPE c LENGTH 4.
  TYPES tv_char07 TYPE c LENGTH 7.
  TYPES tv_byte TYPE int1.
  TYPES tv_tabix TYPE sytabix.

  TYPES tv_real TYPE decfloat34.  " floating point data type

"  TYPES tv_int TYPE int4.         " integer data type int4, use int8 and max_int8 if available
"  CONSTANTS c_max_int TYPE tv_int VALUE cl_abap_math=>max_int4.          "  cl_abap_math=>max_int8.

  TYPES tv_int TYPE int8.
  CONSTANTS c_max_int TYPE tv_int VALUE cl_abap_math=>max_int8.


  TYPES tv_index TYPE tv_int.
  TYPES tv_flag TYPE abap_bool.

  TYPES tv_hex04 TYPE c LENGTH 4. " should only contain hex digits
  TYPES tv_xword TYPE x LENGTH 2.

  TYPES tv_type TYPE tv_char.
  TYPES tv_category TYPE tv_char.
  TYPES tv_sign TYPE tv_char2.

  TYPES tv_port_type TYPE tv_char.

  CONSTANTS:
    c_port_textual VALUE IS INITIAL,
    c_port_binary  VALUE 'b'.

  CONSTANTS:
    c_max_float TYPE tv_real VALUE cl_abap_math=>max_decfloat34,
    c_min_float TYPE tv_real VALUE cl_abap_math=>min_decfloat34.

  CONSTANTS:
    c_escape_char           TYPE tv_char VALUE '\',
    c_text_quote            TYPE tv_char VALUE '"',
    c_semi_colon            TYPE tv_char VALUE ';',
    c_vertical_line         TYPE tv_char VALUE '|',

    c_lisp_dot              TYPE tv_char VALUE '.',
    c_lisp_quote            TYPE tv_char VALUE `'`,   "LISP single quote = QUOTE
    c_lisp_backquote        TYPE tv_char VALUE '`',  " backquote = quasiquote
    c_lisp_unquote          TYPE tv_char VALUE ',',
    c_lisp_splicing         TYPE tv_char VALUE '@',
    c_lisp_unquote_splicing TYPE tv_char2 VALUE ',@'.

  CONSTANTS:
    c_lisp_slash     TYPE tv_char VALUE '/',
    c_lisp_directive TYPE tv_char VALUE '!'.

  CONSTANTS:
    c_open_paren  TYPE tv_char VALUE '(',
    c_close_paren TYPE tv_char VALUE ')',
    c_lisp_equal  TYPE tv_char VALUE '='.
  CONSTANTS:
    c_lisp_hash     TYPE tv_char VALUE '#',
    c_lisp_comment  TYPE tv_char VALUE c_semi_colon,
    c_open_curly    TYPE tv_char VALUE '{',
    c_close_curly   TYPE tv_char VALUE '}',
    c_open_bracket  TYPE tv_char VALUE '[',
    c_close_bracket TYPE tv_char VALUE ']'.

  CONSTANTS:
    c_lisp_eof       TYPE tv_hex04 VALUE 'FEFF', " we do not expect this in source code
    c_lisp_input     TYPE string VALUE 'ABAP Lisp Input' ##NO_TEXT,
    c_lisp_nil       TYPE string VALUE `'()`,
    c_expr_separator TYPE string VALUE ` `,   " multiple expression output
    c_undefined      TYPE string VALUE '<undefined>'.

  CONSTANTS:
    c_error_message         TYPE string VALUE 'Error in processing' ##NO_TEXT,
    c_error_unexpected_end  TYPE string VALUE 'Unexpected end' ##NO_TEXT,
    c_error_eval            TYPE string VALUE 'EVAL( ) came up empty-handed' ##NO_TEXT,
    c_error_no_exp_in_body  TYPE string VALUE 'no expression in body' ##NO_TEXT.

  CONSTANTS:
    c_area_eval  TYPE string VALUE `Eval` ##NO_TEXT,
    c_area_parse TYPE string VALUE `Parse` ##NO_TEXT,
    c_area_radix TYPE string VALUE 'Radix' ##NO_TEXT.

  CONSTANTS:
    c_lisp_else TYPE string VALUE 'else' ##NO_TEXT,
    c_lisp_then TYPE tv_char2 VALUE '=>'.
  CONSTANTS:
    c_eval_append           TYPE string VALUE 'append' ##NO_TEXT,
    c_eval_cons             TYPE string VALUE 'cons' ##NO_TEXT,
    c_eval_list             TYPE string VALUE 'list' ##NO_TEXT,

    c_eval_quote            TYPE string VALUE 'quote' ##NO_TEXT,
    c_eval_quasiquote       TYPE string VALUE 'quasiquote' ##NO_TEXT,
    c_eval_unquote          TYPE string VALUE 'unquote' ##NO_TEXT,
    c_eval_unquote_splicing TYPE string VALUE 'unquote-splicing' ##NO_TEXT.

  CONSTANTS:
    c_binary_digits   TYPE c LENGTH 2 VALUE '01',
    c_octal_digits    TYPE c LENGTH 8 VALUE '01234567',
    c_decimal_digits  TYPE c LENGTH 10 VALUE '0123456789',
    c_hex_digits      TYPE c LENGTH 16 VALUE '0123456789ABCDEF',
    c_hex_digits_long TYPE c LENGTH 22 VALUE '0123456789aAbBcCdDeEfF'.

  CONSTANTS:
    c_hex_alpha_lowercase TYPE c LENGTH 6 VALUE 'abcdef',
    c_abcde               TYPE string VALUE `ABCDEFGHIJKLMNOPQRSTUVWXYZ`, " sy-abcde
    c_special_initial     TYPE string VALUE '!$%&*/:<=>?@^_~'.

  CONSTANTS:
    c_plus_sign            TYPE tv_char VALUE `+`,
    c_minus_sign           TYPE tv_char VALUE `-`,
    c_explicit_sign        TYPE tv_char2 VALUE `+-`,

    c_exponent_marker      TYPE tv_char VALUE `E`,
    c_exponent_marker_long TYPE string VALUE `eEsSfFdDlL`,

    c_imaginary_marker TYPE tv_char VALUE 'I',
    c_imaginary_output TYPE tv_char VALUE `i`,
    c_complex_polar    TYPE tv_char VALUE '@'.

  CONSTANTS:
    c_sign_zero TYPE tv_sign VALUE space,
    c_sign_positive TYPE tv_sign VALUE c_plus_sign,
    c_sign_negative TYPE tv_sign VALUE c_minus_sign,
    c_sign_pos_nan TYPE tv_sign VALUE '?+',
    c_sign_neg_nan TYPE tv_sign VALUE '?-'.

  CONSTANTS:
    c_lisp_pos_zero TYPE string VALUE '+0.0',
    c_lisp_neg_zero TYPE string VALUE '-0.0',
    c_lisp_pos_inf  TYPE string VALUE '+INF.0',
    c_lisp_neg_inf  TYPE string VALUE '-INF.0',
    c_lisp_pos_nan  TYPE string VALUE '+NAN.0',
    c_lisp_neg_nan  TYPE string VALUE '-NAN.0',
    c_lisp_pos_img  TYPE string VALUE '+I',
    c_lisp_neg_img  TYPE string VALUE '-I'.

  CONSTANTS:
    c_pattern_radix     TYPE string VALUE 'oObBdDxX',
    c_pattern_exactness TYPE string VALUE 'eEiI'.

  CONSTANTS:
    c_number_exact         TYPE tv_char2 VALUE 'eE',
    c_number_inexact       TYPE tv_char2 VALUE 'iI',
    c_pattern_inexact      TYPE string VALUE '.eE',
    c_pattern_inexact_long TYPE string VALUE '.eEsSfFdDlL'.

  CONSTANTS:
    c_number_octal   TYPE tv_char2 VALUE 'oO',
    c_number_binary  TYPE tv_char2 VALUE 'bB',
    c_number_decimal TYPE tv_char2 VALUE 'dD',
    c_number_hex     TYPE tv_char2 VALUE 'xX'.

  CONSTANTS
    c_pi TYPE tv_real VALUE '3.141592653589793238462643383279502884197169'.

  CONSTANTS
    c_display_rational_digits TYPE i VALUE 5.    " arbitrary cut-off limit for display

  CONSTANTS:
    tv_category_standard TYPE tv_category VALUE space,
    tv_category_macro    TYPE tv_category VALUE 'X',
    tv_category_escape   TYPE tv_category VALUE '@'.

*  Type definitions for the various elements
  CONSTANTS:
    type_symbol        TYPE tv_type VALUE 'S',
    type_integer       TYPE tv_type VALUE 'N',
    type_real          TYPE tv_type VALUE 'R',
    type_complex       TYPE tv_type VALUE 'z',
    type_rational      TYPE tv_type VALUE 'r',
    type_bigint        TYPE tv_type VALUE 'B',   " not used?
    type_string        TYPE tv_type VALUE '"',

    type_boolean       TYPE tv_type VALUE 'b',
    type_char          TYPE tv_type VALUE 'c',
    type_null          TYPE tv_type VALUE '0',
    type_pair          TYPE tv_type VALUE 'C',
    type_lambda        TYPE tv_type VALUE 'L',
    type_call_cc       TYPE tv_type VALUE 'k',
    type_case_lambda   TYPE tv_type VALUE 'A',
    type_native        TYPE tv_type VALUE 'n',
    type_primitive     TYPE tv_type VALUE 'I',
    type_syntax        TYPE tv_type VALUE 'y',
    type_hash          TYPE tv_type VALUE 'h',
    type_vector        TYPE tv_type VALUE 'v',
    type_bytevector    TYPE tv_type VALUE '8',
    type_port          TYPE tv_type VALUE 'o',
    type_not_defined   TYPE tv_type VALUE space,

    type_escape_proc   TYPE tv_type VALUE '@',

    " Types for ABAP integration:
    type_abap_data     TYPE tv_type VALUE 'D',
    type_abap_table    TYPE tv_type VALUE 'T',
    type_abap_query    TYPE tv_type VALUE 'q',
    type_abap_sql_set  TYPE tv_type VALUE 's',
    type_abap_function TYPE tv_type VALUE 'F',
*    type_abap_class    TYPE tv_type VALUE 'a',
*    type_abap_method   TYPE tv_type VALUE 'm',

    "type_env_spec    TYPE tv_type VALUE 'e',
    type_record_type   TYPE tv_type VALUE 'Y',
    type_values        TYPE tv_type VALUE 'V',
    type_abap_turtle   TYPE tv_type VALUE 't'.  " for Turtles graphic

  CONSTANTS:
    c_real_types   TYPE string VALUE 'NrR',  " type_integer && type_rational && type_real
    c_number_types TYPE string VALUE 'NrRz'. " type_integer && type_rational && type_real && type_complex

  CONSTANTS:
    c_value_false TYPE string VALUE `#f`.
