CLASS zcl_dopa_64 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS get_pdf_64
      IMPORTING
                VALUE(io_vbeln) TYPE vbeln_va
      RETURNING VALUE(pdf_64)   TYPE string.
    DATA : lv_item    TYPE string,
           lv_header  TYPE string,
           lv_footer  TYPE string,
           lv_xml     TYPE string,
           lv_rate    TYPE I_SalesOrderItemPricingElement-ConditionRateValue,
           lv_gst     TYPE I_SalesOrderItemPricingElement-ConditionRateValue,
           lv_freight TYPE I_SalesOrderItemPricingElement-ConditionRateValue,
           lv_comm    TYPE I_SalesOrderItemPricingElement-ConditionRateValue,
           lv_dis     TYPE I_SalesOrderItemPricingElement-ConditionRateValue,
           lv_srno    TYPE i.
    TYPES: BEGIN OF ty_header,
             dopa_no(10)       TYPE c,
             COMP_name(60)     TYPE c,
             Procees_order(60) TYPE c,
             comp_add          TYPE string,
             tel_no(20)        TYPE c,
             website(40)       TYPE c,
             po_no(10)         TYPE c,
             buy_name(50)      TYPE c,
             buy_add           TYPE string,
             buy_dlno(20)      TYPE c,
             gst_no(15)        TYPE c,
             pan_no(15)        TYPE c,
             iec_no(15)        TYPE c,
             cbn_no(15)        TYPE c,
             msme(20)          TYPE c,
             mfg_no(20)        TYPE c,
             date(10)          TYPE c,
             po_date(10)       TYPE c,
             consignee(20)     TYPE c,
             cons_add          TYPE string,
             cons_dl_no(15)    TYPE c,
             cin_no(15)        TYPE c,
             fssai_no(15)      TYPE c,
           END OF ty_header.
    DATA: gs_header TYPE ty_header.
    TYPES: BEGIN OF ty_FOOTER,
             Transporter(20)    TYPE c,
             Freight            TYPE I_SalesOrderItemPricingElement-ConditionRateValue,
             payterm(40)        TYPE c,
             credit_limit(30)   TYPE c,
             credit_exp(20)     TYPE c,
             overdue_date(10)   TYPE c,
             past_track(40)     TYPE c,
             door_del(50)       TYPE c,
             commission         TYPE I_SalesOrderItemPricingElement-ConditionRateValue,
             discount           TYPE I_SalesOrderItemPricingElement-ConditionRateValue,
             insurance_no(15)   TYPE c,
             other_spcf(25)     TYPE c,
             desp_req(15)       TYPE c,
             please_furnish(15) TYPE c,
             letter_add(20)     TYPE c,
             left_name(20)      TYPE c,
             right_name(20)     TYPE c,
           END OF ty_FOOTER.
    DATA: gs_footer TYPE ty_footer.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DOPA_64 IMPLEMENTATION.


  METHOD get_pdf_64.

    SELECT SINGLE *
            FROM I_SalesDocument
            WHERE SalesDocument = @io_vbeln
            INTO  @DATA(wa_head).

    IF sy-subrc = 0.
      SELECT *
             FROM I_SalesDocumentItem
             WHERE SalesDocument = @wa_head-SalesDocument
             INTO TABLE @DATA(li_item).
      IF li_item IS NOT INITIAL.
        SELECT *
               FROM  i_product
               FOR ALL ENTRIES IN @li_item
               WHERE Product = @li_item-Product
               INTO TABLE @DATA(li_product).
      ENDIF.
      SELECT SINGLE *
                     FROM i_salesorderpartner
                     WHERE SalesOrder = @wa_head-SalesDocument
                     AND PartnerFunction = 'AG'
                     INTO @DATA(wa_buyer).
      SELECT SINGLE *
                    FROM i_salesorderpartner
                    WHERE SalesOrder = @wa_head-SalesDocument
                    AND PartnerFunction = 'WE'
                    INTO @DATA(wa_cons).
      SELECT SINGLE *
               FROM i_salesorderpartner
               WHERE SalesOrder = @wa_head-SalesDocument
               AND PartnerFunction = 'SP'
               INTO @DATA(wa_TRANS).

      SELECT SINGLE *
                   FROM i_address_2
                   WITH PRIVILEGED ACCESS
                   WHERE AddressID = @wa_buyer-AddressID
                   INTO @DATA(wa_buyeradd).

      SELECT SINGLE *
                    FROM i_countrytext WHERE country = @wa_buyeradd-country
                    AND language = @sy-langu
                    INTO @DATA(wa_country_B).

      SELECT SINGLE *
                    FROM i_regiontext WHERE country = @wa_buyeradd-country
                    AND region = @wa_buyeradd-region
                    AND language = @sy-langu
                    INTO @DATA(wa_region_B).

      SELECT SINGLE *
                   FROM i_address_2
                   WITH PRIVILEGED ACCESS
                   WHERE AddressID = @wa_cons-AddressID
                   INTO @DATA(wa_CONSADD).

      SELECT SINGLE *
                    FROM i_countrytext WHERE country = @wa_CONSADD-country
                    AND language = @sy-langu
                    INTO @DATA(wa_country_C).

      SELECT SINGLE *
                    FROM i_regiontext WHERE country = @wa_CONSADD-country
                    AND region = @wa_CONSADD-region
                    AND language = @sy-langu
                    INTO @DATA(wa_region_C).
      SELECT *
              FROM I_SalesOrderItemPricingElement
              WHERE SalesOrder =  @io_vbeln
                      INTO TABLE @DATA(li_price).

    ENDIF.
    gs_header-comp_name = 'KOPRAN RESEARCH LAB LTD'.
    gs_header-dopa_no = wa_head-SalesDocument.
    gs_header-procees_order = 'DOMESTIC ORDER PROCESSING ADVICE'.
    gs_header-comp_add = '1076, Parijat House, Dr. E. Moses Road, Worli, Mumbai – 400 018, Maharashtra (India)'.
    gs_header-tel_no = 'Tel : 02243661111'.
    gs_header-website = 'Website : www.kopran.com'.
    gs_header-po_no = wa_head-PurchaseOrderByCustomer.
    gs_header-date = |{ wa_head-SalesDocumentDate+6(2) }.{ wa_head-SalesDocumentDate+4(2) }.{ wa_head-SalesDocumentDate+0(4) }|.
    gs_header-po_date = |{ wa_head-CustomerPurchaseOrderDate+6(2) }.{ wa_head-CustomerPurchaseOrderDate+4(2) }.{ wa_head-CustomerPurchaseOrderDate+0(4) }|.
    gs_header-buy_name = wa_buyer-FullName.
*    gs_header-comp_name = wa_cons-FullName.
    gs_headeR-buy_add = |{ wa_buyeradd-HouseNumber },{ wa_buyeradd-Building },{ wa_buyeradd-StreetName },{ wa_buyeradd-StreetSuffixName1 },{ wa_buyeradd-CityName }-{ wa_buyeradd-PostalCode },{ wa_buyeradd-Region },{ wa_buyeradd-DeliveryServiceNumber }|.
    gs_headeR-cons_add = |{ wa_consadd-HouseNumber },{ wa_consadd-Building },{ wa_consadd-StreetName },{ wa_consadd-StreetSuffixName1 },{ wa_consadd-CityName }-{ wa_consadd-PostalCode },{ wa_consadd-Region },{ wa_consadd-DeliveryServiceNumber }|.
    lv_header = |<form1>| &&
                 |<Main>| &&
                 |<company_name>{ gs_header-COMP_name }</company_name>| &&
                 |<comp_add>{ gs_header-comp_add }</comp_add>| &&
                 |<tel_no>{ gs_header-tel_no }</tel_no>| &&
                 |<website>{ gs_header-website }</website>| &&
                 |<Procees_order>{ gs_header-procees_order }</Procees_order>| &&
                 |<dopa_no>{ gs_header-dopa_no }</dopa_no>| &&
                 |<po_no>{ gs_header-po_no }</po_no>| &&
                 |<buy_name>{ gs_header-buy_name }</buy_name>| &&
                 |<buy_add>{ gs_header-buy_add }</buy_add>| &&
                 |<buy_dlno>{ gs_header-buy_dlno }</buy_dlno>| &&
                 |<gst_no>{ gs_header-gst_no }</gst_no>| &&
                 |<pan_no>{ gs_header-pan_no }</pan_no>| &&
                 |<iec_no>{ gs_header-iec_no }</iec_no>| &&
                 |<cbn_no>{ gs_header-cbn_no }</cbn_no>| &&
                 |<msme>{ gs_header-msme }</msme>| &&
                 |<mfg_no>{ gs_header-mfg_no }</mfg_no>| &&
                 |<date>{ gs_header-date }</date>| &&
                 |<po_date>{ gs_header-po_date }</po_date>| &&
                 |<consignee>{ gs_header-consignee }</consignee>| &&
                 |<cons_add>{ gs_header-cons_add }</cons_add>| &&
                 |<cons_dl_no>{ gs_header-cons_dl_no }</cons_dl_no>| &&
                 |<cin_no>{ gs_header-cin_no }</cin_no>| &&
                 |<fssai_no>{ gs_header-fssai_no }</fssai_no>| &&
                 |<Table1>| &&
                 |<HeaderRow/>|.

    CLEAR lv_srno.
    LOOP AT li_item INTO DATA(lwa_item).
      lv_srno = lv_srno + 1.
      TRY.
          DATA(wa_product) = li_product[ Product = lwa_item-Product ].
        CATCH cx_sy_itab_line_not_found.
          CLEAR: wa_product.
      ENDTRY.

      TRY.
          lv_rate = li_price[ SalesOrderItem =  lwa_item-SalesDocumentItem ConditionType = 'ZPRO' ]-ConditionRateValue.
        CATCH cx_sy_itab_line_not_found.
          CLEAR: lv_rate.
      ENDTRY.

      TRY.
          lv_gst = li_price[ SalesOrderItem =  lwa_item-SalesDocumentItem ConditionType = 'ZGST' ]-ConditionRateValue.
        CATCH cx_sy_itab_line_not_found.
          CLEAR: lv_gst.
      ENDTRY.

      TRY.
          lv_freight = li_price[ SalesOrderItem =  lwa_item-SalesDocumentItem ConditionType = 'ZFRE' ]-ConditionRateValue.
        CATCH cx_sy_itab_line_not_found.
          CLEAR: lv_freight.
      ENDTRY.

      TRY.
          lv_comm = li_price[ SalesOrderItem =  lwa_item-SalesDocumentItem ConditionType = 'ZCOM' ]-ConditionRateValue.
        CATCH cx_sy_itab_line_not_found.
          CLEAR: lv_comm.
      ENDTRY.

      TRY.
          lv_dis = li_price[ SalesOrderItem =  lwa_item-SalesDocumentItem ConditionType = 'ZDIS' ]-ConditionRateValue.
        CATCH cx_sy_itab_line_not_found.
          CLEAR: lv_dis.
      ENDTRY.

      lv_ITEM = lv_ITEM && "#EC CI_NOORDER
      |<Row1>| &&
      |<srno>{ lv_srno }</srno>| &&
      |<mat_name>{ lwa_item-Material }</mat_name>| &&
      |<des>Ad retia sedebam</des>| &&
      |<hsn>Vale</hsn>| &&
      |<quantity>{ lwa_item-OrderQuantity }</quantity>| &&
      |<Pack>Si manu vacuas</Pack>| &&
      |<uom>{ wa_product-BaseUnit }</uom>| &&
      |<rate>{ lv_rate }</rate>| &&
      |<gst>{ lv_gst }</gst>| &&
      |<amount>Proinde</amount>| &&
      |</Row1>|.

      gs_footer-freight = lv_freight + gs_footer-freight.
      gs_footer-discount = lv_dis + gs_footer-discount.
      gs_footer-commission = lv_comm + gs_footer-commission.
      CLEAR: lv_gst, lv_rate,lv_freight,lv_dis,lv_comm.
    ENDLOOP.
    gs_footer-payterm = wa_head-PaymentPlan.
    gs_footer-transporter = wa_trans-FullName.
    lv_footer = |<FooterRow>| &&
    |<total>{ wa_head-TotalNetAmount }</total>| &&
    |</FooterRow>| &&
    |</Table1>| &&
    |<Transporter>{ gs_footer-transporter }</Transporter>| &&
    |<Freight>{ gs_footer-freight }</Freight>| &&
    |<payterm>{ gs_footer-payterm }</payterm>| &&
    |<credit_limit>{ gs_footer-credit_limit }</credit_limit>| &&
    |<credit_exp>{ gs_footer-credit_exp }</credit_exp>| &&
    |<overdue_date>{ gs_footer-overdue_date }</overdue_date>| &&
    |<past_track>{ gs_footer-past_track }</past_track>| &&
    |<door_del>{ gs_footer-door_del }</door_del>| &&
    |<commission>{ gs_footer-commission }</commission>| &&
    |<discount>{ gs_footer-discount }</discount>| &&
    |<insurance_no>{ gs_footer-insurance_no }</insurance_no>| &&
    |<other_spcf>{ gs_footer-other_spcf }</other_spcf>| &&
    |<desp_req>{ gs_footer-desp_req }</desp_req>| &&
    |<please_furnish>{ gs_footer-please_furnish }</please_furnish>| &&
    |<letter_add>{ gs_footer-letter_add }</letter_add>| &&
    |<left_name>{ gs_footer-left_name }</left_name>| &&
    |<right_name>{ gs_footer-right_name }</right_name>| &&
    |</Main>| &&
    |</form1>|.

    lv_xml = |{ lv_header }{ lv_item }{ lv_footer }|.
    CALL METHOD zadobe_ads_class=>getpdf
      EXPORTING
        template = 'ZDOPA/ZDOPA_LAYOUT'
        xmldata  = lv_xml
      RECEIVING
        result   = DATA(lv_result).

    IF lv_result IS NOT INITIAL.

      pdf_64 = lv_result.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
