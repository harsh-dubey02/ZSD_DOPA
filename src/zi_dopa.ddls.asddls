@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View DOPA'
define root view entity ZI_DOPA
  as select from    I_SalesDocument as a
    left outer join zsdt_dopa       as b on a.SalesDocument = b.vbeln
{
  key a.SalesDocument,
      b.base64
}
