// Design
// MIPS connectivity - versão com saída simplificada

`include "MIPS_datapath_components.txt"
`include "MIPS_controller.txt"

// Módulo principal MIPS
module MIPS #(
  parameter BITS = 32
)(
  input logic clk,
  input logic rst
);
    
    // Sinais internos
    logic [BITS-1:0] PCin, PCout, PCplus4, instruction, jump32;
    logic [27:0] jump28;  // 28 bits para endereço de jump
    logic [BITS-1:0] immediate32, branchMinus4, branchAddress;
    logic signed [BITS-1:0] A, B, ALUout;
    logic [BITS-1:0] MEMout;
    logic regWrite, regDst, MemToReg, ALUSrc;
    logic [1:0] ALUOp;
    logic [2:0] ALUcontrol;
    logic MemWrite, MemRead, branch, jump, zero;
    
    // Instanciação dos módulos com as conexões corrigidas
    // O PC usa os 32 bits, mas para a instrução e memória usamos apenas as partes necessárias:
    register PC (clk, rst, 1'b1, PCin, PCout);
    instMem instMem_inst(PCout[5:0], instruction); // usa apenas os 6 bits para endereçamento na instMem
    SL2 #(.IN_WIDTH(26), .OUT_WIDTH(28)) SL2_jump (instruction[25:0], jump28);
    adder add4 (32'd4, PCout, PCplus4);
    SEX SEX_inst (instruction[15:0], immediate32);
    SL2 #(.IN_WIDTH(32), .OUT_WIDTH(32)) SL2_branch (immediate32, branchMinus4);
    adder addBranch (branchMinus4, PCplus4, branchAddress);
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
    // Para a dataMem usa-se o endereço proveniente de ALUout (apenas 6 bits)
    dataMem dataMemory (clk, ALUout[5:0], MemWrite, B, MemRead, MEMout);
    // Controller recebe os 6 bits do opcode (instruction[31:26])
    controller ctrl (instruction[31:26],
                     regWrite, regDst, MemToReg,
                     ALUSrc, ALUOp, MemWrite, MemRead, branch, jump);
    
    assign jump32 = {PCplus4[31:28], jump28};
    assign PCin = jump ? jump32 : ((branch & zero) ? branchAddress : PCplus4);
    
    // Saída de depuração simplificada:
    // Apenas imprime "PC ALUout" a cada borda de clock (quando não estiver em reset)
    always_ff @(posedge clk) begin
      if (!rst) begin
        $display("%0d %0d", PCout, ALUout);
      end
    end

endmodule
