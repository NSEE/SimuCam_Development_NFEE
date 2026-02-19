spwc_dc_data_fifo_inst : spwc_dc_data_fifo PORT MAP (
		aclr	 => aclr_sig,
		data	 => data_sig,
		rdclk	 => rdclk_sig,
		rdreq	 => rdreq_sig,
		wrclk	 => wrclk_sig,
		wrreq	 => wrreq_sig,
		q	 => q_sig,
		rdempty	 => rdempty_sig,
		rdfull	 => rdfull_sig,
		wrempty	 => wrempty_sig,
		wrfull	 => wrfull_sig
	);
