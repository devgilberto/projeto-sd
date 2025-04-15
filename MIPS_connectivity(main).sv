`include "MIPS_datapath_components.sv"
`include "MIPS_controller.sv"

module MIPS #(
  parameter BITS = 32
)(
  input logic clk,
  input logic rst
);
    
  logic [BITS-1:0] PCin, PCout, PCplus4, instruction;
  logic [BITS-1:0] immediate32, branchAddress;
  logic signed [BITS-1:0] A, B, ALUout;
  logic [BITS-1:0] MEMout;
  logic regWrite, regDst, MemToReg, ALUSrc;
  logic [1:0] ALUOp;
  logic [2:0] ALUcontrol;
  logic MemWrite, MemRead, branch, jump, zero;
    
  register PC (clk, rst, 1'b1, PCin, PCout);
  instMem instMem_inst(PCout[5:2], instruction);
  adder add4 (32'd4, PCout, PCplus4);
  SEX SEX_inst (instruction[15:0], immediate32);
  adder addBranch ({immediate32 << 2}, PCplus4, branchAddress);
  registerFile RF (
    clk, rst, regWrite,
    regDst ? instruction[15:11] : instruction[20:16],
    MemToReg ? MEMout : ALUout, 
    instruction[25:21], instruction[20:16],
    A, B
  );
  ALU ALU_inst (
    A,
    ALUSrc ? immediate32 : B,
    ALUcontrol, ALUout, zero
  );
  ALUctrl ALUctrl_inst (instruction[5:0], ALUOp, ALUcontrol);
  dataMem dataMemory (clk, ALUout[3:0], MemWrite, B, MemRead, MEMout);
  controller ctrl (instruction[31:26],
                   regWrite, regDst, MemToReg,
                   ALUSrc, ALUOp, MemWrite, MemRead, branch, jump);
    
  assign PCin = jump ? {PCplus4[31:28], instruction[25:0], 2'b00} :
                (branch & zero) ? branchAddress : PCplus4;
    
  always_ff @(posedge clk) begin
    if (!rst)
      $display("%0d %0d", PCout/4, ALUout);
  end

endmodule
