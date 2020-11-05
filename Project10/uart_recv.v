// Developed on https://edaplayground.com/x/NY8h

module uart_recv
#(
  	// 25(Mhz) / 115200(baudrate) = 217 clocks per bit
    parameter CLKS_PER_BIT = 217                
)
(
    input i_clk,						// 25Mhz
    input i_rx_serial,					// incoming serial data
    output o_rx_dv,						// set to 1 for a single clock
  										//   cycle when o_rx_byte 
  										//   is valid
  output [7:0] o_rx_byte				// data byte received from
  										//   i_rx_serial
);
  
  localparam STATE_IDLE = 0;			// waiting for start bit (0)
  localparam STATE_STARTBIT = 1;		// sync to 50% of start bit
  localparam STATE_DATABITS = 2;		// receive 8 bits of data
  localparam STATE_STOPBIT = 3;			// receive 1 stop bit (1)
  localparam STATE_CLEANUP = 4;			// cleanup receiving data 
  										//    and return to IDLE

  reg [2:0] r_state = STATE_IDLE;
  reg r_rx_dv;							// flag to 1 while r_rx_byte 
  										//    is valid
  reg [7:0] r_rx_byte;					// store 8bits of data
  reg [10:0] r_counter;					// counter for each bit
  reg [2:0] r_bit_index;				// index into 8 bits of data
  
  
  always @(posedge i_clk)
    begin
  
      case (r_state)
        STATE_IDLE : begin
          r_rx_dv <= 0;
          
          if (i_rx_serial == 0) begin
            r_state <= STATE_STARTBIT;
            r_counter <= 0;
          end
        end
        STATE_STARTBIT : begin
          if (r_counter == CLKS_PER_BIT/2)
            begin
              // half way through the start bit
              r_counter <= 0;
              r_state <= STATE_DATABITS;
              r_bit_index <= 0;
            end
          else
            begin
                r_counter <= r_counter + 1;
            end
        end
        STATE_DATABITS : begin
          if (r_counter == CLKS_PER_BIT)
            begin
              r_counter <= 0;
              r_rx_byte[r_bit_index] = i_rx_serial;		// NOTE: LSB first
              if (r_bit_index == 7)
                begin
                  r_state <= STATE_STOPBIT;
                end
              else
                begin
                  r_bit_index <= r_bit_index + 1;
                end
            end
          else
            begin
              r_counter <= r_counter + 1;
            end
        end
        STATE_STOPBIT : begin
          if (r_counter == CLKS_PER_BIT)
            begin
              // todo: check that stop bit is set correctly to 1

              r_rx_dv <= 1;
              r_state <= STATE_CLEANUP;          
            end
          else
            r_counter <= r_counter + 1;
        end
        STATE_CLEANUP : begin
          r_rx_dv <= 0;
          r_state <= STATE_IDLE;
        end
        default : begin
          r_state <= STATE_IDLE;
        end

      endcase
    end
  

  assign o_rx_dv = r_rx_dv;
  assign o_rx_byte[7:0] = r_rx_byte[7:0];
  
endmodule