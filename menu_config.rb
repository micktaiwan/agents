MENU = {

  :main => [['H', "H - Help",       {:go=>:help}],
            ['N', "N - Network",    {:go=>:display_network}],
            ['Q', "Q - Quit menu",  {:go=>:quit}]],
            
  :display_network => [['Q', "Q - Back", {:go=>:main}]],
  
  :help => [['', "Space: toggle strings", {}],
            ['', "2    : toggle forces", {}],
            ['', "", {}],
            ['Q', "Q - Back", {:go=>:main}]]
  
}

