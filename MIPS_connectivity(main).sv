// MIPS_connectivity(main).sv
// Módulo principal do processador MIPS de ciclo único.
// Integra o datapath (ALU, registradores, memórias) e a unidade de controle para executar instruções em um único ciclo de clock.

module SingleCycleMIPS (
    input logic clk,                         // Clock do sistema
    input logic reset                        // Sinal de reset
);

    // Sinais internos do datapath
    logic [31:0] PC, PCNext, PCPlus4, Instr, SrcA, SrcB, ALUResult, ReadData, WriteData, Result;
    logic [31:0] SignImm;
    logic [4:0] WriteReg;
    
    // Sinais de controle
    logic RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Zero;
    logic [2:0] ALUControl;

    // Contador de programa (PC)
    ProgramCounter PCMod (
        .clk(clk),
        .reset(reset),
        .PCNext(PCNext),
        .PC(PC)
    );

    // Memória de instruções: fornece a instrução atual com base no PC
    InstructionMemory InstrMem (
        .Address(PC),
        .Instruction(Instr)
    );

    // Banco de registradores: lê dois registradores e escreve em um por ciclo
    RegisterFile RegFile (
        .clk(clk),
        .RegWrite(RegWrite),
        .ReadReg1(Instr[25:21]),            // rs
        .ReadReg2(Instr[20:16]),            // rt
        .WriteReg(WriteReg),
        .WriteData(Result),
        .ReadData1(SrcA),
        .ReadData2(WriteData)
    );

    // Unidade de controle: gera sinais de controle com base no opcode
    ControlUnit CtrlUnit (
        .Opcode(Instr[31:26]),
        .Funct(Instr[5:0]),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUControl(ALUControl)
    );

    // Extensão de sinal: converte imediato de 16 bits para 32 bits
    assign SignImm = {{16{Instr[15]}}, Instr[15:0]};

    // Seleciona registrador de destino (rd para R-type, rt para I-type)
    assign WriteReg = RegDst ? Instr[15:11] : Instr[20:16];

    // Seleciona segunda entrada da ALU (registrador ou imediato)
    assign SrcB = ALUSrc ? SignImm : WriteData;

    // ALU: realiza operações aritméticas e lógicas
    ALU ALUM (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    // Memória de dados: suporta leitura (lw) e escrita (sw)
    DataMemory DataMem (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Address(ALUResult),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );

    // Seleciona dados para escrita no registrador (resultado da ALU ou memória)
    assign Result = MemtoReg ? ReadData : ALUResult;

    // Calcula próximo PC: PC+4 para instruções sequenciais ou desvio condicional
    assign PCPlus4 = PC + 4;
    assign PCNext = (Branch & Zero) ? (PCPlus4 + (SignImm << 2)) : PCPlus4;

endmodule
