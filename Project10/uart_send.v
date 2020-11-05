module uart_send
  #(
    parameter CLKS_PER_BIT = 217
  )
  (
    input i_clk,				// 25 MHz
    input [7:0] i_tx_byte,		// incoming byte to transmit
    input i_tx_dv,				// set to 1 to start transition
    output o_tx_active,			// active while transmitting
    output o_tx_serial,			// serial signal
    output o_tx_done  			// set to 1 at time when transmission finishes
  );

  reg [7:0] r_tx_byte;			// cache byte that we are sending
  reg r_tx_active;				// set to 1 while transmitting
  reg r_tx_done;
  reg r_tx_serial;
  reg [2:0] r_bit_index;
  reg [7:0] r_counter;
  
  localparam STATE_IDLE = 0;
  localparam STATE_STARTBIT = 1;
  localparam STATE_DATABITS = 2;
  localparam STATE_STOPBIT = 3;
  localparam STATE_CLEANUP = 4;
  
  reg [2:0] state;
  
  always @(posedge i_clk)
  	begin
      case (state)
        STATE_IDLE :
          begin
            r_tx_done <= 0;
            r_tx_active <= 0;
            r_tx_serial <= 1;

            if (i_tx_dv) 
              begin
                // start transmission
                // cache byte that will be transmitted
                r_tx_byte[7:0] <= i_tx_byte[7:0];
                
                // report that tx is active
                r_tx_active <= 1;
                
                // transition to STARTBIT state
                r_counter <= 0;
                state <= STATE_STARTBIT;
              end
          end
        STATE_STARTBIT :
          begin
            r_tx_serial <= 0;

            if (r_counter == (CLKS_PER_BIT-1)) 
              begin
                // STARTBIT has finished
                
                // prepare to send bit 0
                r_bit_index <= 0;
                
                // transition to DATABITS state
                r_counter <= 0;
                state <= STATE_DATABITS;                
              end
            else
              begin
                r_counter <= r_counter + 1;
              end
          end
        STATE_DATABITS :
          begin
            r_tx_serial <= r_tx_byte[r_bit_index];

            if (r_counter == (CLKS_PER_BIT-1)) 
              begin
                // current bit has finished transmission
                r_counter <= 0;
                
                if (r_bit_index == 7)
                  begin
                    // finished transmitting the last bit
                    
                    // transition to STOPBIT state
                    state <= STATE_STOPBIT;
                  end
                else
                  begin
                    // start transmitting the next bit
                   	r_bit_index <= r_bit_index + 1;
                  end
              end
            else
              begin
                r_counter <= r_counter + 1;
              end
          end
        STATE_STOPBIT :
          begin
            r_tx_serial <= 1;
            
            if (r_counter == (CLKS_PER_BIT-1))
              begin
                // finished transmitting the stopbit
                
                //  output 'tx_done' for a single clock cycle
                r_tx_done <= 1;
                
                // transition to CLEANUP state
                state <= STATE_CLEANUP;
              end
            else
              begin
                r_counter <= r_counter + 1;
              end
          end
        STATE_CLEANUP :
          begin
            // finish writing 'tx_done' flag
            r_tx_done <= 0;
            
            // finish writing 'tx_active' flag
            r_tx_active <= 0;
            
            // transition back to 'IDLE' state
            state <= STATE_IDLE;
          end
        default :
          begin
            state <= STATE_IDLE;
          end
      endcase
    end  
  
  assign o_tx_active = r_tx_active;
  assign o_tx_done = r_tx_done;
  assign o_tx_serial = r_tx_serial;
  
endmodule