create procedure dbo.xsp_ls_agreement_getrow_api
(
	@p_ls_applicationid		int
)
as
begin

	declare @aplic_no nvarchar(20)

	select	@aplic_no = applicno
	from	dbo.ls_application 
	where	ls_applicationid = @p_ls_applicationid    

	select lsagree from dbo.ls_agreement where applicno = @aplic_no
end
go
