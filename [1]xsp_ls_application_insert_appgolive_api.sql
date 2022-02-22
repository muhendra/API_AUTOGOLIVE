ALTER PROCEDURE dbo.xsp_ls_application_insert_appgolive_api
(
   @p_ls_applicationid       int out
   ,@p_c_code                nvarchar(6)
   ,@p_applicdt              datetime
   ,@p_lessee                nvarchar(10)
   ,@p_name                  nvarchar(60)
   ,@p_leasetype             numeric
   ,@p_applstype             numeric
   ,@p_applsback             numeric
   ,@p_buyback               numeric
   ,@p_vendor                numeric
   ,@p_appstatus             nvarchar(10)
   ,@p_loc_code              nvarchar(3)
   ,@p_cat_code              nvarchar(3)
   ,@p_ind_code              nvarchar(10)
   ,@p_supp_code             nvarchar(10)
   ,@p_yearmade              nvarchar(4)
   ,@p_mktcode               nvarchar(20)
   ,@p_module                numeric
   ,@p_jnsguna               nvarchar(2)
   ,@p_cre_date              datetime
   ,@p_cre_by                nvarchar(15)
   ,@p_cre_ip_address        nvarchar(15)
   ,@p_mod_date              datetime
   ,@p_mod_by                nvarchar(15)
   ,@p_mod_ip_address        nvarchar(15)
   ,@p_descs                 nvarchar(250)
   ,@p_curr_user             nvarchar(20)
   ,@p_product_facility_code nvarchar(10)
   ,@p_campaign_code         nvarchar(10)
   ,@p_split_po              nvarchar(1)
   ,@p_price_list_code       nvarchar(20)
   ,@p_rental_pay            int
   ,@p_tenor                 int
   ,@p_allow_deviation       nvarchar(1)
   ,@p_purpose_loan_hd_code  int
   ,@p_purpose_loan_dt_code  int
   ,@p_loc_code_bi           nvarchar(10)
   ,@p_ojk_tujuan_pembiayaan nvarchar(20)
   ,@p_ojk_sumber_pembiayaan nvarchar(20)
   ,@p_mcode                 nvarchar(15)
   ,@p_strclease             nvarchar(1)
   ,@p_golive_date			datetime
   ,@p_contract_date		datetime
   ,@p_bast_date			datetime
   ,@p_reff_no				nvarchar(100)=''
   ,@p_rate					decimal(9,6)=0
   ,@p_amount_finance		decimal(18,2)=0
)
as
begin
   declare
      @f_ls_applicationid      int
      ,@p_campaign_asset_desc  nvarchar(100)
      ,@p_campaign_detail_id   int
      ,@p_campaign_detail_desc nvarchar(100)
      ,@p_campaign_tenor_id    int
      ,@p_campaign_tenor_desc  nvarchar(10)
      ,@p_campaign_desc        nvarchar(200)
      ,@msg                    nvarchar(1000) 
	  ,@for_log				   nvarchar(4000) 
      ,@f_leasetype         numeric
      ,@f_applstype        numeric
      ,@f_applsback        numeric
      ,@f_currency         nvarchar(3)
      ,@f_costlease        numeric(17, 2)
      ,@f_vat              nvarchar(1)
      ,@f_dplease          numeric(17, 2)
      ,@f_amtlease         numeric(17, 2)
      ,@f_gdlease          numeric(17, 2)
      ,@f_costcurr         nvarchar(4)
      ,@f_noofinit         numeric(3, 0)
      ,@f_lsperiod         numeric
      ,@f_pmtsched         numeric
      ,@f_rentalpay        numeric
      ,@f_effrate1         numeric(12, 8)
      ,@f_effrate          numeric(12, 8)
      ,@f_roi              numeric(12, 8)
      ,@f_inttype          numeric
      ,@f_strclease        nvarchar(1)
                                          --,@f_rental				numeric(17,2)  
      ,@f_flatrate         numeric(12, 8)
      ,@f_rntduedt1        datetime
      ,@f_intraterev       numeric
      ,@f_ovdint           numeric(5, 2)
      ,@f_slvrate          numeric(5, 2)
      ,@f_bench            nvarchar(10)
      ,@f_margin           numeric(12, 8)
      ,@f_threshold        nvarchar(1)
      ,@f_adjthresh        numeric(12, 8)
      ,@f_paywith          numeric
      ,@f_insurance        nvarchar(10)
      ,@f_typeins          nvarchar(10)
      ,@f_otherins         nvarchar(20)
      ,@f_premiins         numeric(17, 2)
      ,@f_premirate        numeric(5, 2)
      ,@f_biayapolis       numeric(17, 2)
      ,@f_refdealer        numeric(17, 2)
      ,@f_refcust          numeric(17, 2)
      ,@f_insentifsls      numeric(17, 2)
      ,@f_insentifagen     numeric(17, 2)
      ,@f_feebase          numeric(17, 2)
      ,@f_weight_gold      numeric(10, 2)
      ,@f_gold_price       numeric(18, 2)
      ,@f_hde              numeric(18, 2)
      ,@f_first_payment    numeric(18, 2)
      ,@f_dev_code         nvarchar(1)
      ,@f_deviation        nvarchar(255)  -- old type Text  
      ,@f_payment_to_store numeric(18, 2)
      ,@f_loan_type        nvarchar(1)
      ,@f_dp_pct           numeric(5, 2)
      ,@f_rvlease          numeric(17, 2)
      ,@f_rvsddp           numeric(18, 0)
      ,@f_disc_amt         numeric(18, 2)
      ,@f_sec_deposit      numeric(18, 2)
      ,@f_acq_amt          numeric(18, 2)
      ,@f_ol_margin        numeric(18, 2)
      ,@f_ol_margin_pct    numeric(9, 6)
      ,@f_license_fee      numeric(18, 2)
      ,@f_mtn_rpr          numeric(18, 2)
      ,@f_insurance_fee    numeric(18, 2)
      ,@f_others_fee       numeric(18, 2)
      ,@f_cost_of_fund     numeric(18, 2)
      ,@f_plafond          numeric(18, 2)
      ,@f_region_code      nvarchar(10)
      ,@f_channel_ref_no   nvarchar(50)
      ,@f_fc_disb_date     datetime
      ,@f_last_duedate     datetime
      ,@f_ext_flatrate     numeric(12, 8)
      ,@f_refund_rate      numeric(12, 8)
      ,@f_refund_amt       numeric(18, 2)
      ,@f_effrate_thn1     numeric(12, 8)
      ,@f_effrate_thn2     numeric(12, 8)
      ,@f_effrate_thn3     numeric(12, 8)
      ,@f_dp_paid          nvarchar(1)
      ,@f_premibuyrate     decimal(9, 6)
      ,@f_premibuyins      decimal(18, 2)
      ,@f_premidiscount    decimal(18, 2)
      ,@f_premifee         decimal(18, 2)
      ,@f_premiads         decimal(18, 2)
      ,@f_ad_bank          nvarchar(50)
      ,@f_paidbyotherstat  int
      ,@f_paidbyothername  nvarchar(200) 
	  ,@f_applicno		   nvarchar(20)
	  ,@f_ls_agree		   nvarchar(20)
   
  

   if isnull(@p_campaign_code, '') = ''
   begin
      set @msg = N'Mohon di cek Untuk Campaign code tidak boleh kosong' ;

      raiserror(@msg, 16, -1) ;

      return ;
   end ;

   select
         @p_campaign_desc = DESCRIPTION   --as 'p_campaign_desc'  
   from  dbo.MASTER_CAMPAIGN
   where CODE = @p_campaign_code ;

   if isnull(@p_campaign_desc, '') = ''
   begin
      set @msg = N'Mohon di cek Untuk Campaign code ' + @p_campaign_code + N' tidak ada dalam master package' ;

      raiserror(@msg, 16, -1) ;

      return ;
   end ;

   if isnull(@p_price_list_code, '') = ''
   begin
      set @msg = N'Mohon di cek Untuk price list code tidak boleh kosong' ;

      raiserror(@msg, 16, -1) ;

      return ;
   end ;

   select
         @p_campaign_asset_desc = pck.PACKAGE_NAME
   from  master_price_list            pl
         left join dbo.MASTER_PACKAGE pck on pl.PACKAGE_CODE = pck.PACKAGE_CODE
   where pl.C_CODE = @p_price_list_code ;

   if isnull(@p_campaign_asset_desc, '') = ''
   begin
      set @msg = N'Mohon di cek Untuk price list code ' + @p_price_list_code + N' tidak ada dalam master price list' ;

      raiserror(@msg, 16, -1) ;

      return ;
   end ;

   select
            top 1
            @p_campaign_detail_id = ID
            ,@p_campaign_detail_desc
                                  = case
                                       when rental_pay = 1 then 'Advance'
                                       else 'Arrears'
                                    end + N' ' + cast(ASSET_YEAR_RANGE_MIN as nvarchar(10)) + N' - '
                                    + case
                                         when asset_year_range_max = '9999' then 'Up'
                                         else cast(ASSET_YEAR_RANGE_MAX as nvarchar(4))
                                      end + N' DP ' + cast(DP as nvarchar(10)) + N' %' -- as 'campaign_detail_desc'  
   from     master_campaign_detail
   where    campaign_code  = @p_campaign_code
            and rental_pay = @p_rental_pay
            and @p_yearmade
            between ASSET_YEAR_RANGE_MIN and ASSET_YEAR_RANGE_MAX
   order by ASSET_YEAR_RANGE_MAX desc ;

   if isnull(@p_campaign_detail_id, 0) = 0
   begin
      set @msg
         = N'Mohon di cek Untuk kode header ' + @p_campaign_code + N', rental pay '
           + cast(@p_rental_pay as nvarchar(10)) + N', tahun ' + @p_yearmade + N' dan Tenor '
           + cast(@p_tenor as nvarchar(10)) + N' tidak ada pada master package detail' ;

      raiserror(@msg, 16, -1) ;

      return ;
   end ;

   select
         @p_campaign_tenor_id    = id
         ,@p_campaign_tenor_desc = tenor  --as 'campaign_tenor_desc'  
   from  dbo.master_campaign_rate_by_tenor
   where CAMPAIGN_DETAIL_ID = @p_campaign_detail_id
         and TENOR          = @p_tenor ;
   
   if isnull(@p_campaign_tenor_id, 0) = 0
   begin
 
      set @f_lsperiod = 24 ;
      select
            @p_campaign_tenor_id    = id
            ,@p_campaign_tenor_desc = tenor  --as 'campaign_tenor_desc'  
      from  dbo.master_campaign_rate_by_tenor
      where CAMPAIGN_DETAIL_ID = @p_campaign_detail_id
            and TENOR          = @f_lsperiod ;
      if isnull(@p_campaign_tenor_id, 0) = 0
      begin
         set @msg
            = N'Mohon di cek Untuk kode header ' + @p_campaign_code + N', rental pay '
              + cast(@p_rental_pay as nvarchar(10)) + N', tahun ' + @p_yearmade + N' tidak ada pada master package detail' ;
   
         raiserror(@msg, 16, -1) ;
   
         return ;
      end ;
   end ;

    --set @for_log = 'p_c_code : ' + @p_c_code + ' p_lessee : ' + @p_lessee + ' p_module : ' + cast(@p_module as nvarchar(5)) 
				--+ ' p_product_facility_code : ' + @p_product_facility_code + ' p_campaign_code : ' + @p_campaign_code 
				--+ ' p_yearmade : ' + @p_yearmade + ' p_price_list_code : ' + @p_price_list_code + ' p_rental_pay : ' + cast(@p_rental_pay as nvarchar(5)) 
				--+ ' p_tenor : ' + cast(@p_tenor as nvarchar(4)) + ' p_purpose_loan_hd_code : ' +  cast(@p_purpose_loan_hd_code as nvarchar(7)) 
				--+ ' p_purpose_loan_dt_code : ' +  cast(@p_purpose_loan_dt_code as nvarchar(7)) + ' p_strclease : ' + @p_strclease
				--+ ' p_campaign_detail_id : ' + cast(@p_campaign_detail_id as nvarchar(10))  + ' p_campaign_tenor_id : ' +  cast(@p_campaign_tenor_id as nvarchar(10))

   exec dbo.sp_ls_application_insert_appentry
      @p_ls_applicationid = @f_ls_applicationid output      -- int  
      ,@p_c_code = @p_c_code                                -- nvarchar(6)  
      ,@p_applicdt = @p_applicdt                            -- datetime  
      ,@p_lessee = @p_lessee                                -- nvarchar(10)  
      ,@p_name = @p_name                                    -- nvarchar(60)  
      ,@p_leasetype = @p_leasetype                          -- numeric(18, 0)  
      ,@p_applstype = @p_applstype                          -- numeric(18, 0)  
      ,@p_applsback = @p_applsback                          -- numeric(18, 0)  
      ,@p_buyback = @p_buyback                              -- numeric(18, 0)  
      ,@p_vendor = @p_vendor                                -- numeric(18, 0)  
      ,@p_appstatus = N'NEW'                                -- nvarchar(10)  
      ,@p_loc_code = @p_loc_code                            -- nvarchar(3)  
      ,@p_cat_code = @p_cat_code                            -- nvarchar(3)  
      ,@p_ind_code = @p_ind_code                            -- nvarchar(10)  
      ,@p_supp_code = @p_supp_code                          -- nvarchar(10)  
      ,@p_yearmade = @p_yearmade
      ,@p_stnkname = N''                                    -- nvarchar(100)  
      ,@p_mktcode = @p_mktcode                              -- nvarchar(20)  
      ,@p_module = @p_module                                -- numeric(18, 0)  
      ,@p_ob_market = 0                                     -- numeric(18, 0)  
      ,@p_ob_value = 0                                      -- numeric(18, 0)  
      ,@p_jnsproduk = '11'                                  -- nvarchar(2)  
      ,@p_jnsguna = @p_jnsguna                              -- nvarchar(2)  
      ,@p_orientasi = '9'                                   -- nvarchar(1)  
      ,@p_accountno = null                                  -- nvarchar(20)  
      ,@p_invoice = N'0'                                    -- nvarchar(1)  
      ,@p_addcol = null                                     -- nvarchar(40)  
      ,@p_addyear = null                                    -- numeric(18, 0)  
      ,@p_addvalue = 0                                      -- numeric(18, 0)  
      ,@p_cre_date = @p_cre_date                            -- datetime  
      ,@p_cre_by = @p_cre_by                                -- nvarchar(15)  
      ,@p_cre_ip_address = @p_cre_ip_address                -- nvarchar(15)  
      ,@p_mod_date = @p_mod_date                            -- datetime  
      ,@p_mod_by = @p_mod_by                                -- nvarchar(15)  
      ,@p_mod_ip_address = @p_mod_ip_address                -- nvarchar(15)  
      ,@p_vat = '0'                                         -- nvarchar(1)  
      ,@p_descs = @p_descs                                  -- nvarchar(250)  
      ,@p_objaddress = null                                 -- nvarchar(100)  
      ,@p_main_contract = null                              -- nvarchar(20)  
      ,@p_mer_no = null                                     -- nvarchar(20)  
      ,@p_mer_date = null                                   -- datetime  
      ,@p_review_no_mer = null                              -- nvarchar(20)  
      ,@p_review_mer_date = null                            -- datetime  
      ,@p_curr_user = @p_curr_user                          -- nvarchar(20)  
      ,@p_product_facility_code = @p_product_facility_code  -- nvarchar(10)  
      ,@p_campaign_code = @p_campaign_code                  -- nvarchar(10)  
      ,@p_campaign_desc = @p_campaign_desc                  -- nvarchar(200)  
      ,@p_split_po = @p_split_po                            -- nvarchar(1)  
      ,@p_price_list_code = @p_price_list_code              -- nvarchar(20)  
      ,@p_campaign_asset_desc = @p_campaign_asset_desc      -- nvarchar(100)  
      ,@p_campaign_detail_id = @p_campaign_detail_id        -- int  
      ,@p_campaign_detail_desc = @p_campaign_detail_desc    -- nvarchar(100)  
      ,@p_campaign_tenor_id = @p_campaign_tenor_id          -- int  
      ,@p_campaign_tenor_desc = @p_campaign_tenor_desc      -- nvarchar(10)  
      ,@p_sf_contract = N''                                 -- nvarchar(20)  
      ,@p_allow_deviation = @p_allow_deviation              -- nvarchar(1)  
      ,@p_plafond_no = N''                                  -- nvarchar(20)  
      ,@p_apprno = '04'                                     -- nvarchar(20)  
      ,@p_purpose_loan_hd_code = @p_purpose_loan_hd_code    -- int  
      ,@p_purpose_loan_dt_code = @p_purpose_loan_dt_code    -- int  
      ,@p_loc_code_bi = @p_loc_code_bi                      -- nvarchar(10)  
      ,@p_ojk_tujuan_pembiayaan = @p_ojk_tujuan_pembiayaan  -- nvarchar(20)  
      ,@p_ojk_sumber_pembiayaan = @p_ojk_sumber_pembiayaan  -- nvarchar(20)  
      ,@paidbyothersstat = 0                                -- int  
      ,@paidbyothersname = N''                              -- nvarchar(200)  
      ,@p_mcode = @p_mcode
      ,@p_strclease = @p_strclease ;

   set @p_ls_applicationid = @f_ls_applicationid ;

   

   select
		 @f_applicno		  = APPLICNO
		 ,@f_leasetype        = LEASETYPE
         ,@f_applstype        = APPLSTYPE
         ,@f_applsback        = APPLSBACK
         ,@f_currency         = CURRENCY
         ,@f_costlease        = COSTLEASE
         ,@f_vat              = VAT
         ,@f_dplease          = DPLEASE
         ,@f_amtlease         = AMTLEASE
         ,@f_gdlease          = GDLEASE
         ,@f_costcurr         = COSTCURR
         ,@f_noofinit         = NOOFINIT
         ,@f_lsperiod         = LSPERIOD
         ,@f_pmtsched         = PMTSCHED
         ,@f_rentalpay        = RENTALPAY
         ,@f_effrate1         = EFFRATE1
         ,@f_effrate          = EFFRATE
         ,@f_roi              = ROI
         ,@f_inttype          = INTTYPE
         ,@f_strclease        = STRCLEASE
         ,@f_flatrate         = FLATRATE
         ,@f_rntduedt1        = RNTDUEDT1
         ,@f_intraterev       = INTRATEREV
         ,@f_ovdint           = OVDINT
         ,@f_slvrate          = SLVRATE
         ,@f_bench            = BENCH
         ,@f_margin           = MARGIN
         ,@f_threshold        = THRESHOLD
         ,@f_adjthresh        = ADJTHRESH
         ,@f_paywith          = PAYWITH
         ,@f_insurance        = INSURANCE
         ,@f_typeins          = TYPEINS
         ,@f_otherins         = OTHERINS
         ,@f_premiins         = PREMIINS
         ,@f_premirate        = PREMIRATE
         ,@f_biayapolis       = BIAYAPOLIS
         ,@f_refdealer        = REFDEALER
         ,@f_refcust          = REFCUST
         ,@f_insentifsls      = INSENTIFSLS
         ,@f_insentifagen     = INSENTIFAGEN
         ,@f_feebase          = FEEBASE
         ,@f_weight_gold      = WEIGHT_GOLD
         ,@f_gold_price       = GOLD_PRICE
         ,@f_hde              = HDE
         ,@f_first_payment    = FIRST_PAYMENT
         ,@f_dev_code         = DEV_CODE
         ,@f_deviation        = DEVIATION
         ,@f_payment_to_store = PAYMENT_TO_STORE
         ,@f_loan_type        = LOAN_TYPE
         ,@f_dp_pct           = DP_PCT
         ,@f_rvlease          = RVLEASE
         ,@f_rvsddp           = RVSDDP
         ,@f_disc_amt         = DISC_AMT
         ,@f_sec_deposit      = SEC_DEPOSIT
         ,@f_acq_amt          = ACQ_AMT
         ,@f_ol_margin        = OL_MARGIN
         ,@f_ol_margin_pct    = OL_MARGIN_PCT
         ,@f_license_fee      = LICENSE_FEE
         ,@f_mtn_rpr          = MTN_RPR
         ,@f_insurance_fee    = INSURANCE_FEE
         ,@f_others_fee       = OTHERS_FEE
         ,@f_cost_of_fund     = COST_OF_FUND
         ,@f_plafond          = PLAFOND
         ,@f_region_code      = REGION_CODE
         ,@f_channel_ref_no   = CHANNEL_REF_NO
         ,@f_fc_disb_date     = FC_DISB_DATE
         ,@f_last_duedate     = LAST_DUEDATE
         ,@f_ext_flatrate     = EXT_FLATRATE
         ,@f_refund_rate      = REFUND_RATE
         ,@f_refund_amt       = REFUND_AMT
         ,@f_effrate_thn1     = EFFRATE_THN1
         ,@f_effrate_thn2     = EFFRATE_THN2
         ,@f_effrate_thn3     = EFFRATE_THN3
         ,@f_dp_paid          = DP_PAID
         ,@f_premibuyrate     = PREMIBUYRATE
         ,@f_premibuyins      = PREMIBUYINS
         ,@f_premidiscount    = PREMIDISCOUNT
         ,@f_premifee         = PREMIFEE
         ,@f_premiads         = PREMIADS
         ,@f_ad_bank          = AD_BANK
         ,@f_paidbyotherstat  = PAIDBYOTHERSTAT
         ,@f_paidbyothername  = PAIDBYOTHERNAME
   from  dbo.ls_application
   where ls_applicationid = @p_ls_applicationid ;

    
   if isnull(@p_rate,0) <> 0
   begin
		set @f_flatrate = @p_rate
		set @f_lsperiod = @p_tenor
		set @f_dplease = 0
		set @f_amtlease = @p_amount_finance
		set @f_dp_paid = 0
		set @f_dp_pct = 0 
   end

   exec dbo.sp_ls_application_update_termcondition
      @p_ls_applicationid = @p_ls_applicationid
      ,@p_leasetype = @f_applstype                 -- numeric(18, 0)  
      ,@p_applstype = @f_applstype                 -- numeric(18, 0)  
      ,@p_applsback = @f_applsback                 -- numeric(18, 0)  
      ,@p_currency = N'IDR'                        -- nvarchar(3)  
      ,@p_costlease = @f_costlease                 -- numeric(17, 2)  
      ,@p_vat = N'1'                               -- nvarchar(1)  
      ,@p_dplease = @f_dplease                     -- numeric(17, 2)  
      ,@p_amtlease = @f_amtlease                   -- numeric(17, 2)  
      ,@p_gdlease = @f_gdlease                     -- numeric(17, 2)  
      ,@p_costcurr = null                          -- nvarchar(4)  
      ,@p_noofinit = @f_noofinit                   -- numeric(3, 0)  
      ,@p_lsperiod = @f_lsperiod                   -- numeric(18, 0)  
      ,@p_pmtsched = @f_pmtsched                   -- numeric(18, 0)  
      ,@p_rentalpay = @f_rentalpay                 -- numeric(18, 0)  
      ,@p_effrate1 = @f_flatrate                   -- numeric(12, 8)  
      ,@p_effrate = @f_effrate                     -- numeric(12, 8)  
      ,@p_roi = @f_roi                             -- numeric(12, 8)  
      ,@p_inttype = @f_inttype                     -- numeric(18, 0)  
      ,@p_strclease = @p_strclease                 -- nvarchar(1)  
      ,@p_flatrate = @f_flatrate                   -- numeric(12, 8)  
      ,@p_rntduedt1 = @p_golive_date               
      ,@p_intraterev = @f_intraterev               -- numeric(18, 0)  
      ,@p_ovdint = @f_ovdint                       -- numeric(5, 2)  
      ,@p_slvrate = @f_slvrate                     -- numeric(5, 2)  
      ,@p_bench = N''                              -- nvarchar(10)  
      ,@p_margin = @f_margin                       -- numeric(12, 8)  
      ,@p_threshold = N'0'                         -- nvarchar(1)  
      ,@p_adjthresh = @f_adjthresh                 -- numeric(12, 8)  
      ,@p_interview1 = null
      ,@p_interview2 = null
      ,@p_interview3 = null
      ,@p_interview4 = null
      ,@p_interview5 = null
      ,@p_interview6 = null
      ,@p_interview7 = null
      ,@p_interview8 = null
      ,@p_interview9 = null
      ,@p_interview10 = null
      ,@p_interview11 = null
      ,@p_interview12 = null
      ,@p_paywith = @f_paywith                     -- numeric(18, 0)  
      ,@p_insurance = N''                          -- nvarchar(10)  
      ,@p_typeins = N''                            -- nvarchar(10)  
      ,@p_otherins = null                          -- nvarchar(20)  
      ,@p_premiins = @f_premiins                   -- numeric(17, 2)  
      ,@p_premirate = @f_premirate                 -- numeric(5, 2)  
      ,@p_biayapolis = @f_biayapolis               -- numeric(17, 2)  
      ,@p_refdealer = @f_refdealer                 -- numeric(17, 2)  
      ,@p_refcust = @f_refcust                     -- numeric(17, 2)  
      ,@p_insentifsls = @f_insentifsls             -- numeric(17, 2)  
      ,@p_insentifagen = @f_insentifagen           -- numeric(17, 2)  
      ,@p_feebase = @f_feebase                     -- numeric(17, 2)  
      ,@p_cre_date = @p_cre_date                   -- datetime  
      ,@p_cre_by = @p_cre_by                       -- nvarchar(15)  
      ,@p_cre_ip_address = @p_cre_ip_address       -- nvarchar(15)  
      ,@p_mod_date = @p_mod_date                   -- datetime  
      ,@p_mod_by = @p_mod_by                       -- nvarchar(15)  
      ,@p_mod_ip_address = @p_mod_ip_address       -- nvarchar(15)  
      ,@p_applicdt = @p_applicdt
      ,@p_module = @p_module                       -- nvarchar(1)  
      ,@p_channel = N''                            -- nvarchar(1)  
      ,@p_weight_gold = @f_weight_gold             -- numeric(10, 2)  
      ,@p_gold_price = @f_gold_price               -- numeric(18, 2)  
      ,@p_hde = @f_hde                             -- numeric(18, 2)  
      ,@p_first_payment = @f_first_payment         -- numeric(18, 2)  
      ,@p_dev_code = N''                           -- nvarchar(1)  
      ,@p_deviation = null                         -- text  
      ,@p_payment_to_store = @f_payment_to_store   -- numeric(18, 2)  
      ,@p_loan_type = N''                          -- nvarchar(1)  
      ,@p_dp_pct = @f_dp_pct                       -- numeric(5, 2)  
      ,@p_rvlease = @f_rvlease                     -- numeric(17, 2)  
      ,@p_rvsddp = 2                               -- numeric(18, 0)  
      ,@p_disc_amt = @f_disc_amt                   -- numeric(18, 2)  
      ,@p_sec_deposit = @f_sec_deposit             -- numeric(18, 2)  
      ,@p_acq_amt = @f_acq_amt                     -- numeric(18, 2)  
      ,@p_ol_margin = @f_ol_margin                 -- numeric(18, 2)  
      ,@p_ol_margin_pct = @f_ol_margin_pct         -- numeric(9, 6)  
      ,@p_license_fee = @f_license_fee             -- numeric(18, 2)  
      ,@p_mtn_rpr = @f_mtn_rpr                     -- numeric(18, 2)  
      ,@p_insurance_fee = @f_insurance_fee         -- numeric(18, 2)  
      ,@p_others_fee = @f_others_fee               -- numeric(18, 2)  
      ,@p_cost_of_fund = null                      -- numeric(18, 2)  
      ,@p_plafond = null                           -- numeric(18, 2)  
      ,@p_region_code = N'0'                       -- nvarchar(10)  
      ,@p_channel_ref_no = null
      ,@p_fc_disb_date = null
      ,@p_last_duedate = null
      ,@p_ext_flatrate = @f_ext_flatrate           -- numeric(12, 8)  
      ,@p_refund_rate = @f_refund_rate             -- numeric(12, 8)  
      ,@p_refund_amt = @f_refund_amt               -- numeric(18, 2)  
      ,@p_effrate_thn1 = @f_effrate_thn1           -- numeric(12, 8)  
      ,@p_effrate_thn2 = @f_effrate_thn2           -- numeric(12, 8)  
      ,@p_effrate_thn3 = @f_effrate_thn3           -- numeric(12, 8)  
      ,@p_dp_paid = @f_dp_paid                     -- nvarchar(1)  
      ,@p_premibuyrate = @f_premibuyrate           -- decimal(9, 6)  
      ,@p_premibuyins = @f_premibuyins             -- decimal(18, 2)  
      ,@p_premidiscount = @f_premidiscount         -- decimal(18, 2)  
      ,@p_premifee = @f_premifee                   -- decimal(18, 2)  
      ,@p_premiads = @f_premiads                   -- decimal(18, 2)  
      ,@p_ad_bank = N''                            -- nvarchar(50)  
      ,@paidbyotherstat = 0                        -- int  
      ,@paidbyothersname = @p_name ;
	
   -- calculate amort
   exec sp_amortisation_calc_proc
      @p_Ls_applicationID = @p_ls_applicationid ;
	  
   -- 
   exec dbo.xsp_ls_application_calc_tdp_disb
      @p_applicno = @f_applicno
      ,@p_sf_terminate = '1900-01-01'           -- datetime
      ,@p_disburse_amt1 = @f_amtlease      -- decimal(18, 2)
      ,@p_mod_date = @p_mod_date                -- datetime
      ,@p_mod_by = @p_mod_by                    -- nvarchar(15)
      ,@p_mod_ip_address = @p_mod_ip_address ;  -- nvarchar(15)
	
	exec dbo.sp_ls_application_approve_creditcommittee
	   @p_ls_applicationid = @p_ls_applicationid
	   ,@p_applicno = @f_applicno
	   ,@p_cre_date = @p_cre_date                   -- datetime  
	   ,@p_cre_by = @p_cre_by                       -- nvarchar(15)  
	   ,@p_cre_ip_address = @p_cre_ip_address       -- nvarchar(15)  
	   ,@p_mod_date = @p_mod_date                   -- datetime  
	   ,@p_mod_by = @p_mod_by                       -- nvarchar(15)  
	   ,@p_mod_ip_address = @p_mod_ip_address       -- nvarchar(15)
	   ,@p_user_id = @p_mod_by
	
	 SELECT @f_ls_agree=LSAGREE from dbo.LS_AGREEMENT where APPLICNO = @f_applicno 

	 update ls_agreement set contract_date = @p_contract_date,golive_date = @p_golive_date,po_date = @p_bast_date where lsagree = @f_ls_agree

	 exec dbo.xsp_ls_agreement_post_legal_to_new
	    @p_ls_agree = @f_ls_agree
	    ,@p_jf_bank = N''                      -- nvarchar(5)
	    ,@p_cre_date = @p_cre_date                   -- datetime  
	    ,@p_cre_by = @p_cre_by                       -- nvarchar(15)  
	    ,@p_cre_ip_address = @p_cre_ip_address       -- nvarchar(15)  
	    ,@p_mod_date = @p_mod_date                   -- datetime  
	    ,@p_mod_by = @p_mod_by                       -- nvarchar(15)  
	    ,@p_mod_ip_address = @p_mod_ip_address       -- nvarchar(15)

	exec dbo.xsp_ls_agreement_post_golive
	   @p_lsagree = @f_ls_agree
	   ,@p_golive_date = @p_golive_date
	   ,@p_bastk_date = @p_bast_date
	   ,@p_contract_date = @p_contract_date
	   ,@p_cre_date = @p_cre_date                   -- datetime  
	   ,@p_cre_by = @p_cre_by                       -- nvarchar(15)  
	   ,@p_cre_ip_address = @p_cre_ip_address       -- nvarchar(15)  
	   ,@p_mod_date = @p_mod_date                   -- datetime  
	   ,@p_mod_by = @p_mod_by                       -- nvarchar(15)  
	   ,@p_mod_ip_address = @p_mod_ip_address       -- nvarchar(15)
	
	 
	 
end ;
GO
