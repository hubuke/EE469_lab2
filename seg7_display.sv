module eight_seven_segment_driver(clk, reset, segment_data, digit_select);
    input logic clk, // system clock
    input logic reset, // asynchronous reset
    output reg [27:0] segment_data, // 28-bit output for segment data
    output reg [7:0] digit_select // 8-bit output for digit selection

    reg [3:0] counter; // counter for digit selection

    // 7-segment lookup table
    // 7'babcdefg
    //         | dp
    // dp g f e d c b a
    reg [7:0] seg_table [16] = {
        8'b11111100, // 0
        8'b01100000, // 1
        8'b11011010, // 2
        8'b11110010, // 3
        8'b01100110, // 4
        8'b10110110, // 5
        8'b10111110, // 6
        8'b11100000, // 7
        8'b11111110, // 8
        8'b11110110, // 9
        8'b11101110, // A
        8'b00111110, // b
        8'b10011100, // C
        8'b01111010, // d
        8'b10011110, // E
        8'b10001110  // F
    };

    always @ (posedge clk or negedge reset) begin
        if (reset == 0) begin
            counter <= 4'b0000; // reset counter
            digit_select <= 8'b00000001; // select first digit
            segment_data <= seg_table[0]; // display 0 on first digit
        end
        else begin
            // increment digit counter
            counter <= counter + 1;
            if (counter == 4'b1000) begin
                counter <= 4'b0000; // reset counter
            end
            
            // select digit based on counter
            case (counter)
                4'b0000: digit_select <= 8'b00000001;
                4'b0001: digit_select <= 8'b00000010;
                4'b0010: digit_select <= 8'b00000100;
                4'b0011: digit_select <= 8'b00001000;
                4'b0100: digit_select <= 8'b00010000;
                4'b0101: digit_select <= 8'b00100000;
                4'b0110: digit_select <= 8'b01000000;
                4'b0111: digit_select <= 8'b10000000;
                default: digit_select <= 8'b00000000;
            endcase
            
            // display appropriate digit on selected digit
            case (digit_select)
                8'b00000001: segment_data <= seg_table[0]; // display 0
                8'b00000010: segment_data <= seg_table[1]; // display 1
                8'b00000100: segment_data <= seg_table[2]; // display 2
                8'b00001000: segment_data <= seg_table[3]; // display 3
                8'b00010000: segment_data <= seg_table[4]; // display 4
                8'b00100000: segment_data <= seg_table[5]; // display 5
                8'b01000000: segment_data <= seg_table[6]; // display 6
                8'b10000000: segment_data <= seg_table[7]; // display 7
                default: segment_data <= 8'b11111100; // display off
            endcase
        end
    end
endmodule


// This module uses a counter to select one of the eight digits, and displays the appropriate digit on that segment. 
// The segment data is stored in a lookup table, which maps each hexadecimal digit to the appropriate 7-segment display configuration.

// Note that you'll also need to connect the output signals of this module to the appropriate pins on the Nexys A7-100t board. 
// Consult the board's reference manual for more information on the pinout.
