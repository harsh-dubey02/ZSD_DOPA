CLASS zcl_dopa_preview DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_bgmc_operation .
    INTERFACES if_bgmc_op_single_tx_uncontr .
    INTERFACES if_serializable_object .
    METHODS constructor
      IMPORTING
        iv_vbeln TYPE vbeln_va.

  PROTECTED SECTION.
    DATA: im_vbeln TYPE vbeln_va.

    METHODS modify
      RAISING
        cx_bgmc_operation.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DOPA_PREVIEW IMPLEMENTATION.


  METHOD constructor .
    im_vbeln = iv_vbeln.
  ENDMETHOD.


  METHOD if_bgmc_op_single_tx_uncontr~execute.
    modify( ).
  ENDMETHOD.


  METHOD modify.
    DATA : lwa_data TYPE zsdt_dopa.
    DATA :lv_pdftest TYPE string.
    DATA lo_pfd TYPE REF TO zcl_dopa_64.
CREATE OBJECT lo_pfd.


    lo_pfd->get_pdf_64(
      EXPORTING
        io_vbeln = im_vbeln
      RECEIVING
        pdf_64   = DATA(pdf_64)
    ).
    lwa_data-vbeln = im_vbeln.
    lwa_data-base64 = pdf_64.
    MODIFY zsdt_dopa FROM @lwa_data.
    CLEAR lwa_data.

  ENDMETHOD.
ENDCLASS.
