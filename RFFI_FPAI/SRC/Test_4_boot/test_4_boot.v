

module test_4_boot (
    input sclk,
    input s_rst_n,
    output reg _test 
);

reg [63:0] cnt;
localparam  time_period = 64'd100_000_000;


always @(posedge sclk or negedge s_rst_n) begin
    if(!s_rst_n)begin
        _test <= 'b0;
        cnt <= 'b0;
    end
    else begin
        if(cnt>=time_period)begin
            cnt <= 'd0;
            _test <= ~_test;
        end
        else 
            cnt <= cnt+1;
    end
end

    
endmodule