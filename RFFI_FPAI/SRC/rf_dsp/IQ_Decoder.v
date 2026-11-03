module iq_decoder #(parameter data_width = 64,parameter fifo_deep = 8)(
    input sclk,
    input s_rst_n,
    input s_tvalid,
    input [data_width-1:0]      s_tdata,
    input [data_width/8-1:0]    s_tkeep,
    input s_tlast,
    output wire s_tready
);
localparam total_byte = data_width/8;


wire  [data_width-1:0] fifo_data_in;
wire w_en;
reg  r_en;
wire [data_width-1:0] dout;
wire full;
wire empty;
wire f_rst;
reg  [data_width-1:0] datareg;


integer i;


assign s_tready = !full;
assign w_en = s_tvalid&& s_tready;
assign fifo_data_in = datareg;
assign f_rst = !s_rst_n;

always @(posedge sclk or negedge s_rst_n) begin
    if(!s_rst_n)begin
        datareg <= 'b0;
    end
    else begin
        if(w_en)begin
            for(i =0;i<total_byte;i=i+1)begin
                datareg[i*8+:8] <= s_tdata[i*8+:8]&{8{s_tkeep[i]}};
            end
        end
    end
end




fifo_rf   fifo_i(
  .clk(sclk),
  .srst(f_rst),
  .din(fifo_data_in),
  .wr_en(w_en),
  .rd_en(r_en),
  .dout(dout),
  .full(full),
  .empty(empty)
);

fifo_rf   fifo_q(
  .clk(sclk),
  .srst(f_rst),
  .din(fifo_data_in),
  .wr_en(w_en),
  .rd_en(r_en),
  .dout(dout),
  .full(full),
  .empty(empty)
);




endmodule