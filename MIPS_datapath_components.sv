module register #(
  parameter width = 32
)(
  input  logic clk,
  input  logic rst,
  input  logic ld,
  input  logic [width-1:0] D,
  output logic [width-1:0] Q
);
  always_ff @(posedge clk) begin
    if (rst)
      Q <= 0;
    else if (ld)
      Q <= D;
  end
endmodule

module registerFile #(
  parameter adsWidth = 5,
  parameter regWidth = 32
)(
  input  logic clk,
  input  logic rst,
  input  logic ld,
  input  logic [adsWidth-1:0] wrAds,
  input  logic [regWidth-1:0] D,
  input  logic [adsWidth-1:0] rdAds1,
  input  logic [adsWidth-1:0] rdAds2,
  output logic [regWidth-1:0] Q1,
  output logic [regWidth-1:0] Q2
);
  logic [regWidth-1:0] regs [2**adsWidth-1:0];
  
  always_ff @(posedge clk) begin
    if (rst)
      regs <= '{default:0};
    else if (ld && wrAds != 0)
      regs[wrAds] <= D;
  end
  
  assign Q1 = rdAds1 == 0 ? 0 : regs[rdAds1];
  assign Q2 = rdAds2 == 0 ? 0 : regs[rdAds2];
endmodule

module ALU #(
  parameter size = 32
)(
  input  logic [size-1:0] A,
  input  logic [size-1:0] B,
  input  logic [2:0] ALUctrl,
  output logic [size-1:0] RES,
  output logic zero
);
  always_comb begin
    case (ALUctrl)
      3'b000: RES = A & B;
      3'b001: RES = A | B;
      3'b010: RES = A + B;
      3'b110: RES = A - B;
      default: RES = 0;
    endcase
    zero = (RES == 0);
  end
endmodule

module ALUctrl(
  input  logic [5:0] funct,
  input  logic [1:0] ALUop,
  output logic [2:0] ALUctrl
);
  always_comb begin
    if (ALUop == 2'b10) begin
      case (funct)
        32: ALUctrl = 3'b010;
        34: ALUctrl = 3'b110;
        36: ALUctrl = 3'b000;
        37: ALUctrl = 3'b001;
        default: ALUctrl = 3'b000;
      endcase
    end else if (ALUop == 2'b00)
      ALUctrl = 3'b010;
    else if (ALUop == 2'b01)
      ALUctrl = 3'b110;
    else
      ALUctrl = 3'b000;
  end
endmodule

module adder #(
  parameter size = 32
)(
  input  logic [size-1:0] A,
  input  logic [size-1:0] B,
  output logic [size-1:0] RES
);
  assign RES = A + B;
endmodule

module SEX #(
  parameter insize = 16,
  parameter outsize = 32
)(
  input  logic [insize-1:0] IN,
  output logic [outsize-1:0] OUT
);
  assign OUT = {{(outsize-insize){IN[insize-1]}}, IN};
endmodule

module dataMem #(
  parameter adsWidth = 4,
  parameter byteWidth = 8
)(
  input  logic clk,
  input  logic [adsWidth-1:0] wrRdAds,
  input  logic wrEn,
  input  logic [4*byteWidth-1:0] D,
  input  logic rdEn,
  output logic [4*byteWidth-1:0] Q
);
  logic [4*byteWidth-1:0] MEM [2**adsWidth-1:0];
  
  always_comb begin
    if (rdEn)
      Q = MEM[wrRdAds];
  end
  
  always_ff @(posedge clk) begin
    if (wrEn) begin
      MEM[wrRdAds] <= D;
      $display("MEM[%0d] = %08h", wrRdAds, D);
    end
  end
endmodule

module instMem #(
  parameter adsWidth = 4,
  parameter byteWidth = 8
)(
  input  logic [adsWidth-1:0] ads,
  output logic [4*byteWidth-1:0] Q
);
  logic [4*byteWidth-1:0] IMEM [2**adsWidth-1:0];
  
  initial begin
    $readmemh("MIPS_instructions.txt", IMEM);
    for (int i = 0; i < 9; i++)
      $display("MEM[%0d] = %h", i, IMEM[i]);
  end
  
  assign Q = IMEM[ads];
endmodule
