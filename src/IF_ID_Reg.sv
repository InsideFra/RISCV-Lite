import my_pkg::*;	

module IF_ID_Reg (
	input reg [31:0] 	in_PC_link,
	input reg [31:0] 	in_PC_add, 
	input reg [31:0] 	in_instr, 
	input reg 			in_P,
	input reg 			clk,
	input reg 			rstn,
	input reg 			en,
	output reg [31:0] 	out_PC_link,
	output reg [31:0] 	out_PC_add,
	output reg 			out_P,
	output reg [31:0] 	out_instr
);

always @ (posedge clk) begin
	if(!rstn) begin
        out_PC_link		<= 32'b0;
        out_PC_add 		<= 32'b0;
        out_instr 		<= 32'b0;
        out_P			<= 1'b0	;  
	end
	else if(en) begin
        out_PC_link		<= in_PC_link;
        out_PC_add 		<= in_PC_add ;
        out_instr 		<= in_instr ;
        out_P			<= in_P		;  
	end
end
endmodule
