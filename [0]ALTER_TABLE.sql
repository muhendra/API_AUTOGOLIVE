ALTER TABLE LS_APPLICATION add REFF_NO nvarchar(100)
GO
ALTER TABLE dbo.API_LOG_SMILE add REFF_NO nvarchar(100)
go
ALTER TABLE ls_paymentrequest_batch add BATCH_NO nvarchar(20)
go
ALTER TABLE acc_cashpytpaid_req add BATCH_NO nvarchar(20)