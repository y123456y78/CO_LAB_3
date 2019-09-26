///0612544

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter

//Main function
always@(*)
  case(ctrl_i)
     4'b0000 : result_o <= src1_i&src2_i;
     4'b0001 : result_o <= src1_i|src2_i;
     4'b0010 : result_o <= src1_i+src2_i;
     4'b0110 : result_o <= src1_i-src2_i;
     4'b0111 : result_o <= (src1_i < src2_i)?1:0;
     default: result_o <= 0;
  endcase
assign zero_o = (result_o == 0);
endmodule





                    
                    
