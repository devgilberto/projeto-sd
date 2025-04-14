 // Design
// MIPS controller

// Módulo controller - recebe o opcode e gera os sinais de controle
module controller (
  input  logic [5:0] opcode,
  output logic regWrite,
  output logic regDst,
  output logic MemToReg,
  output logic ALUSrc,
  output logic [1:0] ALUOp,
  output logic MemWrite,
  output logic MemRead,
  output logic branch,
  output logic jump
);
  
  always_comb begin    
    case (opcode)
      6'b000000: begin // R-type
        regWrite  = 1;
        regDst    = 1;
        MemToReg  = 0;
        ALUSrc    = 0;
        ALUOp     = 2'b10;
        MemWrite  = 0;
        MemRead   = 0;
        branch    = 0;
        jump      = 0;
      end
      
      6'b000100: begin // beq
        regWrite  = 0;
        regDst    = 0;
        MemToReg  = 0;
        ALUSrc    = 0;
        ALUOp     = 2'b01;
        MemWrite  = 0;
        MemRead   = 0;
        branch    = 1;
        jump      = 0;
      end
      
      6'b100011: begin // lw
        regWrite  = 1;
        regDst    = 0;
        MemToReg  = 1;
        ALUSrc    = 1;
        ALUOp     = 2'b00;
        MemWrite  = 0;
        MemRead   = 1;
        branch    = 0;
        jump      = 0;
      end
      
      6'b101011: begin // sw
        regWrite  = 0;
        regDst    = 0;
        MemToReg  = 0;
        ALUSrc    = 1;
        ALUOp     = 2'b00;
        MemWrite  = 1;
        MemRead   = 0;
        branch    = 0;
        jump      = 0;
      end
      
      6'b000010: begin // jump
        regWrite  = 0;
        regDst    = 0;
        MemToReg  = 0;
        ALUSrc    = 0;
        ALUOp     = 2'b00;
        MemWrite  = 0;
        MemRead   = 0;
        branch    = 0;
        jump      = 1;
      end
      
      default: begin
        regWrite  = 0;
        regDst    = 0;
        MemToReg  = 0;
        ALUSrc    = 0;
        ALUOp     = 2'b00;
        MemWrite  = 0;
        MemRead   = 0;
        branch    = 0;
        jump      = 0;
      end
    endcase
  end
  
endmodule
