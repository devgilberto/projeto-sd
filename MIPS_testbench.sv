module test;

  MIPS MIPS_DUT(clk, rst);
  
  logic clk;
  logic rst;
  
  initial begin
    clk = 1;
    rst = 1;
    #10;
    rst = 0;
    
    #100; 
    $finish;
  end
  
  always #5 clk = ~clk;
  
endmodule
