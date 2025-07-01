/*
interview question- set a key of any number in env and get it in agent .
*/

import uvm_pkg::*;
`include "uvm_macros.svh"


class my_agent extends uvm_agent;
  `uvm_component_utils(my_agent)

  int key;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);


    if (!uvm_config_db#(int)::get(this, "", "key", key)) begin
      `uvm_fatal("CONFIG", "Failed to get the key from my_env")
    end

    `uvm_info("AGENT", $sformatf("Got the key from my_env = %0d",key), UVM_MEDIUM)
  endfunction
endclass

class my_env extends uvm_env;
  `uvm_component_utils(my_env)

  my_agent agnt;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    
    uvm_config_db#(int)::set(this, "agnt", "key", 42);

    agnt = my_agent::type_id::create("agnt", this);
  endfunction

endclass

module tb;
 
  initial 
    begin

      run_test("my_env");
      
   end
  
  
endmodule 


