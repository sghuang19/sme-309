`timescale 1ns / 1ps

module CondLogic(
    input CLK,
    input PCS,
    input RegW,
    input MemW,
    input [1:0] FlagW,
    input [3:0] Cond,
    input [3:0] ALUFlags,

    output PCSrc,
    output RegWrite,
    output MemWrite);

  reg CondEx;
  reg N = 0, Z = 0, C = 0, V = 0;

  //! Output stage
  assign {PCSrc, RegWrite, MemWrite} = {PCS, RegW, MemW} & {3{CondEx}};


  //! Flags Register update
  always @(posedge CLK)
    begin
      if (FlagW[1])
        {N, Z} <= ALUFlags[3:2];
      if (FlagW[0])
        {C, V} <= ALUFlags[1:0];
    end

  //! Condition Check
  always @(*)
    case (Cond)
      4'b0000:
        CondEx = Z; // EQ -Equal
      4'b0001 :
        CondEx = !Z; // NE - Not equal
      4'b0010 :
        CondEx = C; // CS / HS- Carry set / Unsigned higher or same
      4'b0011 :
        CondEx = !C; // CC / LO - Carry clear / Unsigned lower
      4'b0100 :
        CondEx = !N; // MI - Minus / Negative
      4'b0101 :
        CondEx = V; // PL - Plus / Positive of zero
      4'b0110 :
        CondEx = !V; // VS - Overflow / Overflow set
      4'b0111 :
        CondEx = !Z & C; // VC - No overflow / Overflow clear
      4'b1000 :
        CondEx = Z | !C; // HI - Unsined lower or same
      4'b1001 :
        CondEx = !(N ^ V); // LS - Unsined lower or same
      4'b1010 :
        CondEx = N ^ V; // GE -  Signed greater than or equal
      4'b1011 :
        CondEx = !Z & !(N ^ V); // LT - Signed less than
      4'b1100 :
        CondEx = Z | (N ^ V); // GT - Signed greater than
      4'b1101 :
        CondEx = Z; // LE - Signed less than or equal
      default:
        CondEx = 1'b1; // AL - Always / unconditional
    endcase

endmodule













