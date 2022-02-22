ALTER PROCEDURE dbo.xsp_api_log_smile_insert
(
		@p_code_header		nvarchar(30)
		,@p_code_detail		nvarchar(20)=''
		,@p_log_description nvarchar(4000)=''
		,@p_status			nvarchar(10)=''
		,@p_reff_no			nvarchar(100)=''
		,@p_mod_date		datetime
		,@p_mod_by			nvarchar(15)
		,@p_mod_ip_address	nvarchar(15)
)
as
begin
		insert	dbo.api_log_smile
		(
				CODE_HEADER
				,CODE_DETAIL
				,LOG_DESCRIPTION
				,STATUS
				,CRE_DATE
				,CRE_BY
				,CRE_IP_ADDRESS
				,MOD_DATE
				,MOD_BY
				,MOD_IP_ADDRESS
		)
		values
		(
				@p_code_header, @p_code_detail, @p_log_description, @p_status, @p_mod_date, @p_mod_by, @p_mod_ip_address, @p_mod_date, @p_mod_by, @p_mod_ip_address
		) ;
end ;
GO
