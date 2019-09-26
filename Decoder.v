//0612544


module Decoder(
    instr_op_i,
    funct_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	Jump_o,
	MemWrite_o,
	MemRead_o,
	MemToReg_o,
    Link_o,
    ifJr_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;
input       [5:0]funct_i;
output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output			Jump_o;
output			MemWrite_o;
output		MemRead_o;
output			MemToReg_o;
output			Link_o;
output          ifJr_o;
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg			Jump_o;
reg			MemWrite_o;
reg		MemRead_o;
reg			MemToReg_o;
reg			Link_o;
reg     ifJr_o;

//Parameter
parameter addi = 6'b001000, slti = 6'b001010, r_format = 6'b000000,  beq = 6'b000100;
parameter lw=6'b100011,sw=6'b101011,jump=6'b000010,jal=6'b000011;

//Main function
always@(*)begin
  ifJr_o <= (instr_op_i == 6'b000000)&(funct_i == 6'b001000);
end
always@(*)
  case(instr_op_i)
    addi   : begin
      RegWrite_o = 1'b1;
      ALU_op_o = 3'b110;
      ALUSrc_o = 1'b1;
      RegDst_o = 1'b0;
      Branch_o = 1'b0;
      Jump_o   = 1'b0;
      MemWrite_o = 1'b0;
      MemRead_o  = 1'b0;
      MemToReg_o = 1'b0;
      Link_o = 1'b0;
    end
    slti   : begin
      RegWrite_o = 1'b1;
      ALU_op_o = 3'b111;
      ALUSrc_o = 1'b1;
      RegDst_o = 1'b0;
      Branch_o = 1'b0;
      Jump_o   = 1'b0;
      MemWrite_o = 1'b0;
      MemRead_o  = 1'b0;
      MemToReg_o = 1'b0;
      Link_o = 1'b0;
    end
    r_format: 
      if(funct_i == 6'b001000)begin
      RegWrite_o = 1'b0;
      ALU_op_o = 3'b101;
      ALUSrc_o = 1'b0;
      RegDst_o = 1'b0;
      Branch_o = 1'b0;
      Jump_o   = 1'b1;
      MemWrite_o = 1'b0;
      MemRead_o  = 1'b0;
      MemToReg_o = 1'b0;
      Link_o = 1'b0;
      end
      else begin
      RegWrite_o = 1'b1;
      ALU_op_o = 3'b010;
      ALUSrc_o = 1'b0;
      RegDst_o = 1'b1;
      Branch_o = 1'b0;
      Jump_o   = 1'b0;
      MemWrite_o = 1'b0;
      MemRead_o  = 1'b0;
      MemToReg_o = 1'b0;
      Link_o = 1'b0;
      end
    beq: begin
      RegWrite_o = 1'b0;
      ALU_op_o = 3'b001;
      ALUSrc_o = 1'b0;
      RegDst_o = 1'b0;
      Branch_o = 1'b1;
      Jump_o   = 1'b0;
      MemWrite_o = 1'b0;
      MemRead_o  = 1'b0;
      MemToReg_o = 1'b0;
      Link_o = 1'b0;
    end
    lw: begin
      RegWrite_o = 1'b1;
      ALU_op_o = 3'b110;
      ALUSrc_o = 1'b1;
      RegDst_o = 1'b0;
      Branch_o = 1'b0;
      Jump_o   = 1'b0;
      MemWrite_o = 1'b0;
      MemRead_o  = 1'b1;
      MemToReg_o = 1'b1;
      Link_o = 1'b0;
    end
    sw: begin
      RegWrite_o = 1'b0;
      ALU_op_o = 3'b110;
      ALUSrc_o = 1'b1;
      RegDst_o = 1'b0;
      Branch_o = 1'b0;
      Jump_o   = 1'b0;
      MemWrite_o = 1'b1;
      MemRead_o  = 1'b0;
      MemToReg_o = 1'b0;
      Link_o = 1'b0;
    end
    jump: begin
      RegWrite_o = 1'b0;
      ALU_op_o = 3'b101;
      ALUSrc_o = 1'b0;
      RegDst_o = 1'b0;
      Branch_o = 1'b0;
      Jump_o   = 1'b1;
      MemWrite_o = 1'b0;
      MemRead_o  = 1'b0;
      MemToReg_o = 1'b0;
      Link_o = 1'b0;
    end
    jal: begin
      RegWrite_o = 1'b1;
      ALU_op_o = 3'b101;
      ALUSrc_o = 1'b0;
      RegDst_o = 1'b0;
      Branch_o = 1'b0;
      Jump_o   = 1'b1;
      MemWrite_o = 1'b0;
      MemRead_o  = 1'b0;
      MemToReg_o = 1'b0;
      Link_o = 1'b1;
    end
  endcase
endmodule





                    
                    