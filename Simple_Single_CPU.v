//0612544

module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles

wire     [31:0]currentPC;
wire     [31:0]nextPC;
wire     [31:0]nextPC_two; 
wire     [31:0]nextPC_three;
wire     [31:0]seqPC;
wire     [31:0]branPC;  
wire     [31:0]rs;
wire     [31:0]rt;
wire     [31:0]result;
wire     [31:0]muxOut;
wire     [3-1:0]aluOP;
wire           aluSrc;
wire           regWrite;
wire           regDst;

wire           zero;
wire     [4:0]writeToReg;
wire     [4:0]writeToReg_two;
wire     [3:0]aluCtrl;
wire           branch;                       
wire     [31:0]inst;
wire     [31:0]extendOut;
wire     [31:0]jump;
wire     selectPC;
assign   selectPC = zero&branch;
wire     j;
wire     memRead;
wire     memWrite;
wire     memToReg;
wire     [31:0]writeBackData;
wire     [31:0]writeBackData_two;
wire     [31:0]memData;
wire     jrReturn;
wire     jal;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(nextPC_three),   
	    .pc_out_o(currentPC) 
	    );
	
Adder Adder1(
        .src1_i(currentPC),     
	    .src2_i(32'd4),     
	    .sum_o(seqPC)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(currentPC),  
	    .instr_o(inst)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(inst[20:16]),
        .data1_i(inst[15:11]),
        .select_i(regDst),
        .data_o(writeToReg)
        );	
MUX_2to1 #(.size(5)) Mux_Write_Reg_if_jal(
        .data0_i(writeToReg),
        .data1_i(5'b11111),
        .select_i(jal),
        .data_o(writeToReg_two)
        );  

		
Reg_File Registers(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(inst[25:21]) ,  
        .RTaddr_i(inst[20:16]) ,  
        .RDaddr_i(writeToReg_two) ,  
        .RDdata_i(writeBackData_two)  , 
        .RegWrite_i(regWrite),
        .RSdata_o(rs) ,  
        .RTdata_o(rt)   
        );
	
Decoder Decoder(
        .instr_op_i(inst[31:26]), 
        .funct_i(inst[5:0]),
	    .RegWrite_o(regWrite), 
	    .ALU_op_o(aluOP),   
	    .ALUSrc_o(aluSrc),   
	    .RegDst_o(regDst),   
		.Branch_o(branch),
        .Jump_o(j),
        .MemWrite_o(memWrite),
        .MemRead_o(memRead),
        .MemToReg_o(memToReg),
        .Link_o(jal),
        .ifJr_o(jrReturn)
	    );

ALU_Ctrl AC(
        .funct_i(inst[5:0]),   
        .ALUOp_i(aluOP),   
        .ALUCtrl_o(aluCtrl) 
        );
	
Sign_Extend SE(
        .data_i(inst[15:0]),
        .data_o(extendOut)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(rt),
        .data1_i(extendOut),
        .select_i(aluSrc),
        .data_o(muxOut)
        );	
		
ALU ALU(
        .src1_i(rs),
	    .src2_i(muxOut),
	    .ctrl_i(aluCtrl),
	    .result_o(result),
		.zero_o(zero)
	    );
	
Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(result),
	.data_i(rt),
	.MemRead_i(memRead),
	.MemWrite_i(memWrite),
	.data_o(memData)
	);

MUX_2to1 #(.size(32)) choose_back(
        .data0_i(result),
        .data1_i(memData),
        .select_i(memToReg),
        .data_o(writeBackData)
        );	
MUX_2to1 #(.size(32)) choose_back_two(
        .data0_i(writeBackData),
        .data1_i(currentPC+32'd4),
        .select_i(jal),
        .data_o(writeBackData_two)
        );  

Adder Adder2(
        .src1_i(seqPC),     
	    .src2_i(jump),     
	    .sum_o(branPC)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(extendOut),
        .data_o(jump)
        ); 	

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(seqPC),
        .data1_i(branPC),
        .select_i(selectPC),
        .data_o(nextPC)
        );	

MUX_2to1 #(.size(32)) Mux_PC_Source_two(
        .data0_i(nextPC),
        .data1_i({nextPC[31:28],inst[25:0],2'b00}),
        .select_i(j),
        .data_o(nextPC_two)
        );

MUX_2to1 #(.size(32)) Mux_PC_Source_three(
        .data0_i(nextPC_two),
        .data1_i(rs),
        .select_i(jrReturn),
        .data_o(nextPC_three)
        );
endmodule