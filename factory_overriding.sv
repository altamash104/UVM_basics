/*
1.Factory is a singleton(can create only one object) class used to create or build UVM component during runtime.
2.It has the ability to modify the data types and number of objects that make up the testbench hierachy
3.UVM factory is a mechanism to improve flexibility and scalability of the testbench by allowing the user to 
"substitute an existing class object by any of its inherited child class objects".
4.for the factory to create components and objects.
  -step1:Register class types with the factory.
  -step2:Creating components and object using factory.
  -step3:Overriding components and object

4.
*/



import uvm_pkg::*;
`include "uvm_macros.svh"

class my_driver extends uvm_driver;
`uvm_component_utils(my_driver)

function new(string name="my_driver",uvm_component parent=null);
super.new(name,parent);
endfunction

task run_phase(uvm_phase phase);
`uvm_info(get_type_name(),"I am in Parent Driver Class",UVM_LOW)
endtask
endclass

class driver_ex extends my_driver;
`uvm_component_utils(driver_ex)

function new(string name="driver_ex",uvm_component parent=null);
super.new(name,parent);
endfunction

task run_phase(uvm_phase phase);
`uvm_info(get_type_name(),"I am in extended Driver Class",UVM_LOW)
endtask
endclass

class agent1 extends uvm_agent;
`uvm_component_utils(agent1)

my_driver drv_h;

function new(string name="agent1",uvm_component parent=null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
drv_h = my_driver::type_id::create("drv_h",this);
endfunction
endclass

class agent2 extends uvm_agent;
`uvm_component_utils(agent2)

my_driver drv_h;

function new(string name="agent2",uvm_component parent=null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
drv_h = my_driver::type_id::create("drv_h",this);

endfunction
endclass

class env extends uvm_env;
`uvm_component_utils(env)

agent1 agt_h1;
agent2 agt_h2;

function new(string name="env",uvm_component parent=null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
agt_h1 = agent1::type_id::create("agt_h1",this);
agt_h2 = agent2::type_id::create("agt_h2",this);

endfunction
endclass

class test extends uvm_test;
`uvm_component_utils(test)

env env_h;

function new(string name="test",uvm_component parent=null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
env_h = env::type_id::create("env_h",this);
//driver::type_id::set_type_override(driver_ex::get_type());
//set_inst_override("*.agt_h1.*","my_driver","driver_ex");

set_inst_override_by_type("*",my_driver::get_type(),driver_ex::get_type());

//set_type_override_by_type(agent1::get_type(),agent2::get_type());


endfunction

function void end_of_elaboration_phase(uvm_phase phase);
super.end_of_elaboration_phase(phase);
uvm_top.print_topology();
endfunction
endclass

module top();
initial
run_test("test");
endmodule
