/*
1.Analysis port used for one to many communication.
2.It can be connected with zero,one,or many analysis implementation ports.
3.It has write method which gets implemented in traget component ,it is a non-blocking method.
    eg- (source transaction,destination scoreboard)
4.The direction of connection is from port to implementation port.
     syntax:-mon_h.ap.connect(sb.analysis_imph)
     
*/
`include "uvm_macros.svh"
import uvm_pkg::*;

class seq_item extends uvm_sequence_item;
  
  `uvm_object_utils(seq_item)

  rand bit [3:0] addr;
  rand bit [3:0] data;


  function new(string name = "seq_item");
	super.new(name);
  endfunction
	
  constraint addr_c {addr inside {[0:100]};}
  constraint data_c {data inside {[0:100]};}

endclass

class producer extends uvm_component;
  `uvm_component_utils(producer)

  seq_item req;
  uvm_analysis_port #(seq_item) a_put;


	
  function new(string name = "producer", uvm_component parent = null);
		super.new(name, parent);
		a_put = new("a_put", this);
  endfunction

  task run_phase(uvm_phase phase);
	super.run_phase(phase);
	req = seq_item::type_id::create("req");
	assert(req.randomize());
    `uvm_info(get_type_name(), $sformatf("Send addr = %0h,data=%0h", req.addr,req.data),UVM_NONE);
	a_put.write(req);
	endtask
endclass

class consumer_A extends uvm_component;
  `uvm_component_utils(consumer_A)
	seq_item req;
	uvm_analysis_imp #(seq_item, consumer_A) analysis_imp_A;
	
	function new(string name = "consumer_A", uvm_component parent = null);
		super.new(name, parent);
		analysis_imp_A = new("analysis_imp_A", this);
	endfunction
	
  virtual function void write(seq_item req);
    `uvm_info(get_type_name(), $sformatf("Recieved addr = %0h,data=%0h", req.addr,req.data),
UVM_NONE);
  endfunction
endclass

class consumer_B extends uvm_component;
  	`uvm_component_utils(consumer_B)
	seq_item req;
	uvm_analysis_imp #(seq_item, consumer_B) analysis_imp_B;

	
  function new(string name = "consumer_B", uvm_component parent = null);
		super.new(name, parent);
		analysis_imp_B = new("analysis_imp_B", this);
  endfunction

  virtual function void write(seq_item req);
    `uvm_info(get_type_name(), $sformatf("Recieved addr = %0h,data=%0h", req.addr,req.data),UVM_NONE);
  endfunction

endclass

class consumer_C extends uvm_subscriber #(seq_item);
  `uvm_component_utils(consumer_C)
	seq_item req;
   uvm_analysis_imp #(seq_item, consumer_C) analysis_imp_C;	
 
	
  function new(string name = "consumer_C", uvm_component parent = null);
		super.new(name, parent);
     analysis_imp_C = new("analysis_imp_C", this);
  endfunction

  virtual function void write (seq_item req);
    `uvm_info(get_type_name(), $sformatf("Recieved addr = %0h,data=%0h", req.addr,req.data),UVM_NONE);
  endfunction

endclass

class env extends uvm_env;
  `uvm_component_utils(env)
	producer   pro;
	consumer_A con_A;
	consumer_B con_B;
	consumer_C con_C;
	
	function new(string name = "env", uvm_component parent = null);
		super.new(name, parent);
	endfunction

  function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pro = producer::type_id::create("pro", this);
		con_A = consumer_A::type_id::create("con_A", this);
		con_B = consumer_B::type_id::create("con_B", this);
		con_C = consumer_C::type_id::create("con_C", this);
  endfunction

  function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		pro.a_put.connect(con_A.analysis_imp_A);
		pro.a_put.connect(con_B.analysis_imp_B);
		pro.a_put.connect(con_C.analysis_export);
	endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
	env env_o;
	

  function new(string name = "test", uvm_component parent = null);
		super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env_o = env::type_id::create("env_o", this);
  endfunction

  task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	#50;
	phase.drop_objection(this);
endtask
endclass

module tb_top;
	initial 
      begin
		run_test("test");
	  end
endmodule
