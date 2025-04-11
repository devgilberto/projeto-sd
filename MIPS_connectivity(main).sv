// Design
// MIPS connectivity

`include "MIPS_datapath_components.txt"
`include "MIPS_controller.txt"

// name: MIPS
// declaration: clock, reset.

module MIPS #(
  parameter BITS = 32
  )(
  input logic clk,
  input logic rst,
  );
    
    register PC (clk, rst, 1, PCin, PCout);
    instMem instMem_inst(PCout, instruction);
    SL2 SL2_jump (instruction[25:0],jump28);
    adder add4 (32'd4, PCout, PCplus4);
    SEX SEX_inst (instruction[15:0], immediate32);
    SL2 SL2_branch (immediate32, branchMinus4);
    adder addBranch (branchMinus4,PCplus4,branchAddress);
    registerFile RF (clk, rst, regWrite,
                     regDst?instruction[15:11]:instruction[20:16],
                     MemToReg?MEMout:ALUout, 
                     instruction[25:21],instruction[20:16],
                     A,B
                    );
    ALU ALU_inst (A,
                  ALUSrc?immediate32:B,
                  ALUcontrol, ALUout, zero);
    ALUctrl ALUctrl_inst (instruction[5:0], ALUOp, ALUcontrol);
    dataMem dataMemory (clk, ALUout, MemWrite, B, MemRead, MEMout);
  controller ctrl (instruction[31:26],
                     regWrite, regDst, MemToReg,
                     ALUSrc, ALUOp, MemWrite, MemRead, branch, jump);
    
    logic [BITS-1:0] PCin;
    logic [BITS-1:0] PCout;
    logic [BITS-1:0] PCplus4;
    logic [BITS-1:0] instruction;
    logic [BITS-1:0] jump28;
    logic [BITS-1:0] jump32;
    logic [BITS-1:0] immediate32;
    logic [BITS-1:0] branchMinus4;
    logic [BITS-1:0] branchAddress;
    logic signed [BITS-1:0] A;
    logic signed [BITS-1:0] B;
    logic signed [BITS-1:0] ALUout;
    logic [BITS-1:0] MEMout;
    logic regWrite;
  	logic regDst;
    logic MemToReg;
    logic ALUSrc;
    logic [1:0] ALUOp;
    logic [2:0] ALUcontrol;
    logic MemWrite;
    logic MemRead;
    logic branch;
    logic jump; 
    logic zero;
    
    assign jump32 = {PCplus4[31:28],jump28[27:0]};
    assign PCin = jump?jump32:((branch & zero)?branchAddress:PCplus4);
    
  always begin
    #2 $display ("opcode:%b",instruction[31:26]);
    $display ("PCout=%d",PCout);
    $display ("A=%d",A);
    $display ("B=%d",B);
    $display ("ALUout=%d",ALUout);
  end
  
endmodule
